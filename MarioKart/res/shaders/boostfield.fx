#include "mta-helper.fx"

float Time : Time;
float scrollSpeed = 1;

sampler TextureSampler = sampler_state
{
    Texture = <gTexture0>;
};

struct VertexShaderInput
{
	float3 Position : POSITION0;
	float4 Color : COLOR0;
	float2 TexCoord : TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 Position : POSITION0;
	float4 Color : COLOR0;
	float2 TexCoord : TEXCOORD0;
};

VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

	input.Position.z += 0.05;
    output.Position = MTACalcScreenPosition(input.Position);
	output.TexCoord = input.TexCoord;
	output.Color = float4(1, 1, 1, 1);
	
    return output;
}

float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	float timer = Time * scrollSpeed;
	input.TexCoord.xy += timer;
	
	float4 mainColor = tex2D(TextureSampler, input.TexCoord.yx * 0.5);
	float4 itemColor = mainColor * input.Color;  
	
    return itemColor;
}
 
technique Boostfield
{
    pass Pass0
    {
		AlphaBlendEnable = false;
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