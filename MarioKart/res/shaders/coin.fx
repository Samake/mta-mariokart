#define GENERATE_NORMALS
#include "mta-helper.fx"

float textureSize = 256;
float bumpMapFactor = 0.001;
float3 sunPos = float3(1, 0, 0);
float4 sunColor = float4(1, 1, 1, 1);
float4 ambientColor = float4(1, 1, 1, 1);
float ambientIntensity = 1.0;
float diffuseIntensity = 1.0;
float specularIntensity = 1.0;
float specularSize = 1.0;


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
	float3 Binormal : TEXCOORD3;
	float3 Tangent : TEXCOORD4;
	float3 View : TEXCOORD5;
};


VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
    MTAFixUpNormal(input.Normal);

    output.Position = MTACalcScreenPosition(input.Position);
	output.worldNormal = MTACalcWorldNormal(input.Normal);
	output.worldPosition = MTACalcWorldPosition(input.Position);
	output.TexCoord = input.TexCoord;

	float3 Tangent = input.Normal.yxz;
    Tangent.xz = input.TexCoord.xy;
    float3 Binormal = normalize(cross(Tangent, input.Normal));
    Tangent = normalize(cross(Binormal, input.Normal));

	output.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    output.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
	
	output.View = normalize(float4(gCameraPosition, 1.0) - output.worldPosition);

	output.Color = input.Color;
	
    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{	
	float4 mainColor = tex2D(MainSampler, input.TexCoord);

	float3 normalMap = calculateTextureNormals(MainSampler, input.TexCoord, mainColor, textureSize) * 2.0 - 1.0;
    normalMap = normalize(float3(normalMap.x * bumpMapFactor, normalMap.y * bumpMapFactor, normalMap.z)); 
	
	float3 lightDirection = normalize(gCameraPosition - sunPos);
    float4 diffuseColor = saturate(dot(-lightDirection, input.worldNormal));
	
	float3 lightRange1 = normalize(normalize(gCameraPosition - input.worldPosition) - lightDirection);
    float specularLight1 = pow(saturate(dot(lightRange1, normalMap)), specularSize);
	float4 specularColor1 = float4(sunColor.rgb * specularLight1, 1);
	
	float3 lightRange2 = normalize(normalize(gCameraPosition - input.worldPosition) - lightDirection);
    float specularLight2 = pow(saturate(dot(lightRange2, normalMap)), specularSize / 2);
	float4 specularColor2 = float4(sunColor.rgb * specularLight2, 1);
	
	
	specularColor1 *= mainColor.r * mainColor.r;
	specularColor2 *= mainColor.g;
	specularColor1 *= 1.5;
	specularColor2 /= 1.5;
	
	float4 finalSpecular = ((specularColor1 + specularColor2) / 3);
	
	float lightAwayDot = -dot(lightDirection, input.worldNormal);
	if (lightAwayDot < 0.003) finalSpecular = 0;
	
    float4 finalColor = float4(ambientColor.rgb * ambientIntensity, 1) + float4((diffuseColor.rgb * diffuseIntensity)* sunColor.rgb, 1) + saturate(finalSpecular * specularIntensity);
	finalColor.rgb *= 0.5;
	finalColor.a = mainColor.a;
	
	return finalColor * mainColor;
}


technique Coins
{
    pass Pass0
    {
		AlphaBlendEnable = false;
        AlphaRef = 1;
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