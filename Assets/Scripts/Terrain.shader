
Shader "Custom/Terrain" {
	Properties {
		testTexture("Texture", 2D) = "white"{}
		testScale("Scale", Float) = 1
		_GridThickness ("Grid Thickness", Float) = 0.01
	    _GridSpacing ("Grid Spacing", Float) = 10.0
	    _GridColour ("Grid Colour", Color) = (0.5, 1.0, 1.0, 1.0)
	    _BaseColour ("Base Colour", Color) = (0.0, 0.0, 0.0, 0.0)
	}
	SubShader {
		Tags { "RenderType" = "Opaque" "Queue" = "Transparent" "IgnoreProjector"="True"}
        Blend One One
		LOD 200

		Pass {
	        ZWrite Off
	        AlphaToMask On
	        Blend SrcAlpha OneMinusSrcAlpha
	     
	        CGPROGRAM
	     
	        // Define the vertex and fragment shader functions
	        #pragma vertex vert
	        #pragma fragment frag
	     
	        // Access Shaderlab properties
	        uniform float _GridThickness;
	        uniform float _GridSpacing;
	        uniform float4 _GridColour;
	        uniform float4 _BaseColour;
	     
	        // Input into the vertex shader
	        struct vertexInput {
	            float4 vertex : POSITION;
	        };
	 
	        // Output from vertex shader into fragment shader
	        struct vertexOutput {
	          float4 pos : SV_POSITION;
	          float4 worldPos : TEXCOORD0;
	        };
	     
	        // VERTEX SHADER
	        vertexOutput vert(vertexInput input) {
	          vertexOutput output;
	          output.pos = UnityObjectToClipPos(input.vertex);
	          // Calculate the world position coordinates to pass to the fragment shader
	          output.worldPos = mul(unity_ObjectToWorld, input.vertex);
	          return output;
	        }
	 
	        // FRAGMENT SHADER
	        float4 frag(vertexOutput input) : COLOR {
	          if (frac(input.worldPos.x/_GridSpacing) < _GridThickness || frac(input.worldPos.y/_GridSpacing) < _GridThickness) {
	            return _GridColour;
	          }
	          else {
	            return _BaseColour;
	          }
	        }
		    ENDCG
	   }
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.5 target, to get nicer looking lighting
		#pragma target 3.5
		#include "UnityCG.cginc"

		const static int maxLayerCount = 8;
		const static float epsilon = 1E-4;

		int layerCount;
		float3 baseColours[maxLayerCount];
		float baseStartHeights[maxLayerCount];
		float baseBlends[maxLayerCount];
		float baseColourStrength[maxLayerCount];
		float baseTextureScales[maxLayerCount];

		float minHeight;
		float maxHeight;

		sampler2D testTexture;
		float testScale;
		UNITY_DECLARE_TEX2DARRAY(baseTextures);

		struct Input {
			float3 worldPos;
			float3 worldNormal;
		};

		float inverseLerp(float a, float b, float value) {
			return saturate((value-a)/(b-a));
		}

		float3 triplanar(float3 worldPos, float scale, float3 blendAxes, int textureIndex) {
			float3 scaledWorldPos = worldPos / scale;
			float3 xProjection = UNITY_SAMPLE_TEX2DARRAY(baseTextures, float3(scaledWorldPos.y, scaledWorldPos.z, textureIndex)) * blendAxes.x;
			float3 yProjection = UNITY_SAMPLE_TEX2DARRAY(baseTextures, float3(scaledWorldPos.x, scaledWorldPos.z, textureIndex)) * blendAxes.y;
			float3 zProjection = UNITY_SAMPLE_TEX2DARRAY(baseTextures, float3(scaledWorldPos.x, scaledWorldPos.y, textureIndex)) * blendAxes.z;
			return xProjection + yProjection + zProjection;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float heightPercent = inverseLerp(minHeight,maxHeight, IN.worldPos.y);
			float3 blendAxes = abs(IN.worldNormal);
			blendAxes /= blendAxes.x + blendAxes.y + blendAxes.z;

			for (int i = 0; i < layerCount; i ++) {
				float drawStrength = inverseLerp(-baseBlends[i]/2 - epsilon, baseBlends[i]/2, heightPercent - baseStartHeights[i]);

				float3 baseColour = baseColours[i] * baseColourStrength[i];
				float3 textureColour = triplanar(IN.worldPos, baseTextureScales[i], blendAxes, i) * (1-baseColourStrength[i]);

				o.Albedo = o.Albedo * (1-drawStrength) + (baseColour+textureColour) * drawStrength;
			}

		
		}


		ENDCG


	}
	FallBack "Diffuse"
}

