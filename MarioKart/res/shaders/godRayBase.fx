texture sunLight;

float2 sunPos = float2(0, 0);
float godRayStrength = 1.9;
float godRayStartOffset = 0.4;
float godRayLength = 0.9;
static int godRaySamples = 26;


sampler SunSampler = sampler_state {
    Texture = (sunLight);
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 blur(float2 texCoords, float4 color) {	
	texCoords -= sunPos;
	
    for(int i = 0; i < godRaySamples; i++) {
    	float scale = godRayStartOffset + godRayLength * (i / (float)(godRaySamples - 1));
    	color += tex2D(SunSampler, texCoords * scale + sunPos);
   	}
	
	color /= godRaySamples; 
	
	return color;
}


float4 GodrayPixelShader(float2 texCoords : TEXCOORD) : COLOR {
	float4 godrayColorBase = tex2D(SunSampler, texCoords);
	
	float4 godrayColor = blur(texCoords, godrayColorBase);
	godrayColor *= godRayStrength;
	
	float4 finalColor = godrayColorBase * 0.5 + godrayColor * 3;
	
	return finalColor;
}
 
 
technique GodrayBase {
	pass p0 {
		AlphaBlendEnable	= true;
		PixelShader = compile ps_2_0 GodrayPixelShader();
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