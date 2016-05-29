texture bwSource;

float2 sunPos = (0, 0);
float sunSize = 0.15;


sampler BWSourceSampler = sampler_state
{
    Texture = (bwSource);
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 SunPixelShader(float2 texCoords : TEXCOORD) : COLOR
{
		
	float4 bwColor = tex2D(BWSourceSampler, texCoords);
	
    float distfromcenter = distance(sunPos, texCoords); 
	float4 sunObjectColor = lerp(float4(1, 1, 1, 1), float4(0.1, 0.1, 0.1, 0.1) * bwColor.a, saturate(distfromcenter) / sunSize / 1.5) * 3 * bwColor.r;

	return sunObjectColor;
}


technique SunShader
{
    pass P0
    {
        PixelShader  = compile ps_2_0 SunPixelShader();
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