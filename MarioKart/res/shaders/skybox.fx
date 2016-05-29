#include "mta-helper.fx"

texture skyTexture;
float brightness = 0.5;


sampler TextureSampler = sampler_state
{
    Texture = <skyTexture>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


struct VertexShaderInput
{
    float3 Position				: POSITION; 
    float2 TextureCoordinate	: TEXCOORD0;
};


struct VertexShaderOutput
{
	float4 Position				: POSITION;
	float2 TextureCoordinate	: TEXCOORD0;
};


VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
{
    VertexShaderOutput output;

	output.Position = MTACalcScreenPosition(input.Position);
    output.TextureCoordinate = input.TextureCoordinate;

    return output;
}


float4 PixelShaderFunction(VertexShaderOutput input) : COLOR0
{
	input.TextureCoordinate = 1 - input.TextureCoordinate;
	float4 color = tex2D(TextureSampler, input.TextureCoordinate);
	color.rgb *= brightness;
	
    return color;
}

 
technique SkyBox
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