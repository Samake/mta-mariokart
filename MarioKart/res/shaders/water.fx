#include "mta-helper.fx"

float4 waterColor = float4(0, 0, 0, 1);
texture waterTexture;
texture waterNormal;
float waterBrightness = 1;
float waterAlpha = 1;
float Time : Time;
float flowSpeed = 1.5;
float fogStart = 300;
float fogEnd = 500;
float refractionStrength = 0.5;
float3 sunPos = float3(0, 0, 0);
float4 sunColor = float4(0.0, 0.0, 0.0, 1);
float specularSize = 2;
float waterShiningPower = 1;

sampler TextureSampler = sampler_state
{
    Texture = <waterTexture>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = WRAP;
    AddressV = WRAP;
};

sampler NormalSampler = sampler_state
{
    Texture = <waterNormal>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = WRAP;
    AddressV = WRAP;
};

struct VertexShaderInput
{
    float3 Position				: POSITION; 
    float2 TextureCoordinate	: TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 Position				: POSITION;
	float3 worldPosition 		: TEXCOORD0;
	float2 TextureCoordinate	: TEXCOORD1;
	float4 RefractionPosition 	: TEXCOORD2;
	float3 lightDirection 		: TEXCOORD3;
	float Depth 				: TEXCOORD4;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	matrix refractProjection;

	output.Position = MTACalcScreenPosition(input.Position);
	output.worldPosition = MTACalcWorldPosition(input.Position.xyz);
    output.TextureCoordinate = input.TextureCoordinate;
	refractProjection = mul(gWorldViewProjection, gWorld);
    refractProjection = mul(gWorld, refractProjection);
   
    // Calculate the input position against the refractProjection matrix.
    output.RefractionPosition = mul(float4(input.Position, 1), refractProjection);
	output.lightDirection = normalize(gCameraPosition - sunPos);
	output.Depth = output.Position.z;

    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	float2 refractTexCoord;
	float4 normalMap;
	float3 normal;
	float timer = (Time/15) * flowSpeed;
	
	refractTexCoord.x = input.RefractionPosition.x / input.RefractionPosition.w / 2.0f + 0.5f;
    refractTexCoord.y = -input.RefractionPosition.y / input.RefractionPosition.w / 2.0f + 0.5f;
	
	// NORMAL MAPPING 
	float2 NormalCoords = input.TextureCoordinate;
	NormalCoords.y += timer;
	NormalCoords.x -= timer / 2;
    float4 normalMap1 = tex2D(NormalSampler, NormalCoords);
	NormalCoords.y -= timer;
	NormalCoords.x += timer / 3;
    float4 normalMap2 = tex2D(NormalSampler, NormalCoords);
	normalMap = (normalMap1 + normalMap2) / 2;
    normal = (normalMap.xyz * 2.0f) - 1.0f;

    refractTexCoord += normal.xy;
	
	input.TextureCoordinate.x += timer;
	
	float4 color = tex2D(TextureSampler, input.TextureCoordinate + refractTexCoord * refractionStrength);
	
		// Using Blinn half angle modification for performance over correctness
    float3 lightRange = normalize(normalize(gCameraPosition - input.worldPosition) - input.lightDirection);
    float specularLight = pow(saturate(dot(lightRange, normal)), specularSize);
	float specularLight2 = pow(saturate(dot(lightRange, normalMap)), specularSize / 2) / 2;
	
	float4 specularColor1 = sunColor * specularLight * color.r * color.r;
	float4 specularColor2 = sunColor * specularLight2 * normalMap.g * normalMap.g;
	
	float4 finalSpecularColor = (specularColor1 + specularColor2) / 2;
	color.rgb += finalSpecularColor.rgb * waterShiningPower;
	
	float distanceFog = saturate((input.Depth - fogStart)/(fogEnd - fogStart));
	float4 finalColor = float4(lerp(color.rgb, color.rgb / 4, distanceFog), 1);

	finalColor.rgb *= waterColor.rgb;
	finalColor.rgb *= waterBrightness;
	finalColor.a *= waterAlpha;
	
    return finalColor;
}
 
technique WaterShader
{
    pass Pass0
    {
		AlphaBlendEnable = true;
        AlphaRef = 1;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}