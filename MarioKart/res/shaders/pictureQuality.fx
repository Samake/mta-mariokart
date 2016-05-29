texture screenSource;
texture sunSource;

float saturation = 1.0;
float contrast = 1.0;
float brightness = 1.0;
float4 sunColoration = float4(0.92, 0.85, 0.7, 1.0);

bool isSun = false;

sampler ScreenSourceSampler = sampler_state {
    Texture = <screenSource>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler SunSourceSampler = sampler_state {
    Texture = <sunSource>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	
	
	float4 baseColor = tex2D(ScreenSourceSampler, texCoords);
	
	float4 sunColor = 0;
	
	if (isSun == true) {
		sunColor = tex2D(SunSourceSampler, texCoords);
		float4 fakeSun = float4(1, 1, 1, 1) * sunColor;
		sunColor += fakeSun * sunColoration;
		baseColor += sunColor * sunColoration;
	}

	float3 luminanceWeights = float3(0.299, 0.587, 0.114);
	float luminance = dot(baseColor, luminanceWeights);
	float4 finalColor = lerp(luminance, baseColor, saturation);
	finalColor.rgb *= 1.5;
	
	finalColor.a = baseColor.a;
	finalColor.rgb = ((finalColor.rgb - 0.5f) * max(contrast, 0)) + 0.5f;
	finalColor.rgb *= brightness;
	
	return finalColor;
}
 
 
technique PictureQuality
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}