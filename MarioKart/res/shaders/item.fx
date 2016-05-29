#include "mta-helper.fx"

float brightness = 1;
float alpha = 1;

float3 sunPos = float3(1, 0, 0);
float4 sunColor = float4(1, 1, 1, 1);
float4 ambientColor = float4(1, 1, 1, 1);
float textureSize = 256.0;
float ambientIntensity = 1.0;
float specularSize = 8;
float bumpMapFactor = 0.003;
float specularIntensity = 1.0;

sampler TextureSampler = sampler_state
{
    Texture = <gTexture0>;
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
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;
	
    MTAFixUpNormal(input.Normal);

    output.Position = MTACalcScreenPosition(input.Position);
	output.worldPosition = MTACalcWorldPosition(input.Position);
	output.worldNormal = MTACalcWorldNormal(input.Normal);
	output.lightDirection = normalize(gCameraPosition - sunPos);
	
	// Fake tangent and binormal
    float3 Tangent = input.Normal.yxz;
    Tangent.xz = input.TexCoord.xy;
    float3 Binormal = normalize(cross(Tangent, input.Normal));
    Tangent = normalize(cross(Binormal, input.Normal));
    // Transfer some stuff
	output.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    output.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
	
	output.TexCoord = input.TexCoord;
	output.Color = ambientColor * ambientIntensity;
	
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	float4 mainColor = tex2D(TextureSampler, input.TexCoord);
	
	float3 normalMap = bumpMapFactor * MTACalcNormalMap(TextureSampler, input.TexCoord.xy, mainColor, textureSize) - bumpMapFactor / 2;  
    normalMap = normalize(normalMap.x * input.Tangent + normalMap.y * input.Binormal + input.worldNormal);
	
	float3 lightRange = normalize(normalize(gCameraPosition - input.worldPosition) - input.lightDirection);
    float specularLight = pow(saturate(dot(lightRange, normalMap)), specularSize);
	float value = (mainColor.r + mainColor.g + mainColor.b) / 3;
	specularLight *= value;
	
	float4 finalSpecular = float4(specularLight, specularLight, specularLight, 1);
	finalSpecular *= sunColor;
	
	float lightAwayDot = -dot(input.lightDirection, input.worldNormal);
	    
	float4 itemColor = mainColor * input.Color;
	
	if (lightAwayDot < 0) finalSpecular = finalSpecular / 4;
		
	itemColor.rgb *= brightness;
	itemColor.rgb += finalSpecular.rgb * specularIntensity;
	
	itemColor.a *= alpha;
	
    return saturate(itemColor);
}
 
technique Items
{
    pass Pass0
    {
		AlphaBlendEnable = true;
        AlphaRef = 1;
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunction();
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