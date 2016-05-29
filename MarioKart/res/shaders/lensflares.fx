
texture sunLight;
texture lensDirt;
texture lensChroma;

float2 sunPos = float2(0, 0);
float4 sunColor = float4(1, 1, 1, 1);
float lensDirtStrength = 0.8;
float lensChromaStrength = 0.8;


sampler SunSampler = sampler_state
{
    Texture = (sunLight);
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler LensDirtSampler = sampler_state
{
    Texture = (lensDirt);
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler LensChromaSampler = sampler_state
{
    Texture = (lensChroma);
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};
 

float4 LensflarePixelShader(float2 texCoords : TEXCOORD) : COLOR {
	
	float4 mainColor = 0;
	float4 godRays = tex2D(SunSampler, texCoords);
	
	float4 lensFlare1 = tex2D(LensDirtSampler, texCoords * 1.5 + sunPos / 2) * 1.2;
	float4 lensFlare2 = tex2D(LensDirtSampler, texCoords * 0.5 - sunPos / 2) * 0.8;

	float4 finalLensFlareDirt = (lensFlare1 + lensFlare2) / 2;
	float4 lensFlareChroma = tex2D(LensChromaSampler, texCoords + sunPos / 12) * 0.8;
	
	lensFlareChroma *= finalLensFlareDirt;
	lensFlareChroma *= lensChromaStrength;

	finalLensFlareDirt *= godRays;
	finalLensFlareDirt *= lensDirtStrength;
	
	mainColor += saturate(finalLensFlareDirt * sunColor);
	mainColor += saturate(godRays * sunColor) * 1.2;
	mainColor += saturate(lensFlareChroma);
	
	return mainColor;
}
 

technique LensFlares {
	pass p0 {
		AlphaBlendEnable = true;
		PixelShader = compile ps_2_0 LensflarePixelShader();
    }
}
 
 
// Fallback
technique Fallback {
    pass P0 {
        // Just draw normally
    }
}