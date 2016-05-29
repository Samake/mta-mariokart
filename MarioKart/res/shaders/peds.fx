#define GENERATE_NORMALS
#include "mta-helper.fx"

float3 sunPos = float3(1, 0, 0);
float4 sunColor = float4(1, 1, 1, 1);
float4 ambientColor = float4(1, 1, 1, 1);
float textureSize = 128.0;

float ambientIntensity = 1.0;
float specularSize = 6;
float lightShiningPower = 1;
float normalStrength = 1;
float bumpMapFactor = 1.2;
float specularIntensity = 1;
float specularFadeStart = 30;
float specularFadeEnd = 150;
float fogStart = 90;
float fogEnd = 900;


sampler MainSampler = sampler_state
{
    Texture = (gTexture0);
};

struct VertexShaderInput
{
	float3 Position : POSITION0;
	float4 Color : COLOR0;
	float3 Normal : NORMAL0;
	float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 Position : POSITION0;
	float4 Color : COLOR0;
	float2 TexCoord : TEXCOORD0;
	float3 worldPosition : TEXCOORD1;
	float3 worldNormal : TEXCOORD2;
	float3 lightDirection : TEXCOORD3;
	float3 Binormal : TEXCOORD4;
	float3 Tangent : TEXCOORD5;
	float DistFade : TEXCOORD6;
	float Depth : TEXCOORD7;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
    MTAFixUpNormal(input.Normal);

	//input.Position.z *= 0.01;
    output.Position = MTACalcScreenPosition(input.Position);
	output.worldNormal = MTACalcWorldNormal(input.Normal);
	output.worldPosition = MTACalcWorldPosition(input.Position);
	output.lightDirection = normalize(gCameraPosition - sunPos);
	
    float3 Tangent = input.Normal.yxz;
    Tangent.xz = input.TexCoord.xy;
    float3 Binormal = normalize(cross(Tangent, input.Normal));
    Tangent = normalize(cross(Binormal, input.Normal));

	output.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    output.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);

    float lightIntensity = dot(output.worldNormal, -output.lightDirection);
	
	output.TexCoord = input.TexCoord;

	float4 agpColor = float4(sunColor.rgb * lightIntensity, 1);
	float4 agpDiffuse = MTACalcGTABuildingDiffuseAGP(output.worldNormal, input.Color, agpColor, output.lightDirection);
	float4 agpGTALights = MTACalcGTALights(input.Color);
	output.Color = (agpDiffuse + agpGTALights) / 2;
	
    float DistanceFromCamera = MTACalcCameraDistance(gCameraPosition, output.worldPosition);
    output.DistFade = MTAUnlerp(specularFadeEnd, specularFadeStart, DistanceFromCamera);
	
	output.Depth = output.Position.z;

    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	
	float4 mainColor = tex2D(MainSampler, input.TexCoord);
	
   	float3 normalMap = bumpMapFactor * MTACalcNormalMap(MainSampler, input.TexCoord.xy, mainColor, textureSize) - bumpMapFactor / 2;  
    normalMap = normalize(normalMap.x * input.Tangent + normalMap.y * input.Binormal + input.worldNormal);
	
    float3 lightRange = normalize(normalize(gCameraPosition - input.worldPosition) - input.lightDirection);
    float specularLight = pow(saturate(dot(lightRange, input.worldNormal)), specularSize);
	float4 finalSpecular = float4(sunColor.rgb * specularLight, 1);
	finalSpecular.rgb *= mainColor.g;
	finalSpecular.rgb *= specularIntensity;
	
	float lightAwayDot = -dot(input.lightDirection, input.worldNormal);
	
	float4 dynamicLightColor = mainColor * input.Color;
	
	if (lightAwayDot < 0) finalSpecular = dynamicLightColor / 8;

	dynamicLightColor.rgb *= ambientColor.rgb * ambientIntensity;
	dynamicLightColor.rgb += finalSpecular.rgb * lightShiningPower * saturate(input.DistFade);
    
	return dynamicLightColor;
}

technique Peds
{
    pass Pass0
    {
		AlphaBlendEnable = false;
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunction();
    }
}

// Fallback
technique Fallback
{
    pass P0
    {
        // Just draw normally
    }
}