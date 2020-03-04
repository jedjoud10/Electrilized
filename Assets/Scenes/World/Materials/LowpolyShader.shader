Shader "Custom/FlatSurfaceShaderNew" {
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _Color2("Color 2", Color) = (1,1,1,1)
        _Color3("Color 3", Color) = (1,1,1,1)
        _Color4("Color 3", Color) = (1,1,1,1)
        _Glossiness("Gloss", Range(0.0, 1.0)) = 0.0
        _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _pow("Power", Range(1, 20)) = 0.0
        _thres("Threshold", Range(0, 1)) = 0.0
        _thres2("Threshold 2", Range(0, 1)) = 0.0
        _waterLevel("Water Level", Range(0, 100)) = 0.0
        [KeywordEnum(Approximate, Exact)] _InverseMatrix("World To Tangent Matrix", Float) = 0.0
    }
        SubShader{
            Tags { "RenderType" = "Opaque" }

            CGPROGRAM
            #pragma surface surf Standard fullforwardshadows vertex:vert
            #pragma target 3.0
            #pragma shader_feature _ _INVERSEMATRIX_EXACT


            struct Input {
                float2 uv_MainTex;
                float3 cameraRelativeWorldPos;
                float3 worldNormal;
                float3 worldPosition;
                bool isUnderwater;
                INTERNAL_DATA
            };

            half _Glossiness;
            half _Metallic;
            fixed4 _Color;
            fixed4 _Color2;
            fixed4 _Color3;
            fixed4 _Color4;
            float _pow;
            float _thres;
            float _thres2;
            float _waterLevel;

            // pass camera relative world position from vertex to fragment
            void vert(inout appdata_full v, out Input o)
            {
                UNITY_INITIALIZE_OUTPUT(Input,o);
                o.cameraRelativeWorldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0)) - _WorldSpaceCameraPos.xyz;
                o.worldPosition = v.vertex.xyz;
                o.isUnderwater = v.vertex.y < _waterLevel;
            }

            void surf(Input IN, inout SurfaceOutputStandard o) {



        #if !defined(UNITY_PASS_META)
                // flat world normal from position derivatives
                half3 flatWorldNormal = normalize(cross(ddy(IN.cameraRelativeWorldPos.xyz), ddx(IN.cameraRelativeWorldPos.xyz)));

                // construct world to tangent matrix
                half3 worldT = WorldNormalVector(IN, half3(1,0,0));
                half3 worldB = WorldNormalVector(IN, half3(0,1,0));
                half3 worldN = WorldNormalVector(IN, half3(0,0,1));

            #if defined(_INVERSEMATRIX_EXACT)
                // inverse transform matrix
                half3x3 w2tRotation;
                w2tRotation[0] = worldB.yzx * worldN.zxy - worldB.zxy * worldN.yzx;
                w2tRotation[1] = worldT.zxy * worldN.yzx - worldT.yzx * worldN.zxy;
                w2tRotation[2] = worldT.yzx * worldB.zxy - worldT.zxy * worldB.yzx;

                half det = dot(worldT.xyz, w2tRotation[0]);

                w2tRotation *= rcp(det);
            #else
                half3x3 w2tRotation = half3x3(worldT, worldB, worldN);
            #endif

                // apply world to tangent transform to flat world normal
                o.Normal = mul(w2tRotation, flatWorldNormal);
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                float4 c = _Color;
                float4 c2 = _Color2;
                float4 c3 = _Color3;
                float4 c4 = _Color4;
                float _finalBlend = pow(dot(flatWorldNormal, float3(0, 1, 0)), _pow);
                float _finalBlend2 = _finalBlend;
                float _finalBlend3 = IN.worldPosition.y;
                if (_finalBlend > _thres) 
                {
                    _finalBlend = 1;
                }
                else 
                {
                    _finalBlend = 0;
                }
                if(_finalBlend2 > _thres2)
                {
                    _finalBlend2 = 1;
                }
                else
                {
                    _finalBlend2 = 0;
                }
                if (IN.isUnderwater) 
                { 
                    _finalBlend3 = 1; 
                }
                else 
                { 
                    _finalBlend3 = 0; 
                }
                o.Albedo = lerp(lerp(c.rgb, lerp(c2.rgb, c3.rgb, _finalBlend2), _finalBlend), c4.rgb, _finalBlend3); // vertex RGB
        #endif
            }
            ENDCG
        }
            FallBack "Diffuse"
}