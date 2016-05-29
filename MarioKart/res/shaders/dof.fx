texture screenSource;
texture blurredSource;
texture farPlane;
float2 screenSize = float2(0, 0);

sampler ScreenSourceSampler = sampler_state {
    Texture = <screenSource>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


sampler FarPlaneSampler = sampler_state {
    Texture = <farPlane>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};

sampler BlurredSampler = sampler_state {
    Texture = <blurredSource>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Mirror;
    AddressV = Mirror;
};


float4 PixelShaderFunction(float2 texCoords : TEXCOORD0) : COLOR0 {	
	
	float4 baseColor = tex2D(ScreenSourceSampler, texCoords);
	float4 farPlaneColor = tex2D(FarPlaneSampler, texCoords);
	float4 blurColor = tex2D(BlurredSampler, texCoords);
	
	float4 finalColor = lerp(baseColor, blurColor, saturate(farPlaneColor.r));
	
	return finalColor;
}
 
 
technique Dof
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}