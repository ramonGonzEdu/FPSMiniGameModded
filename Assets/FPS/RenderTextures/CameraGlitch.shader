Shader "Unlit/CameraGlitch"
{
    Properties
    {
        _MainTex ("Texture (RGBA)", 2D) = "white" {}
        _Color ("Some Color", Color) = (0.2,0.8,0.7,1) 

        _MinLine ("Minimum Line Brightness", Range (0,1)) = 0.6
        _MaxLine ("Maximum Line Brightness", Range (0,1)) = 1.0
        _LineCount ("LineCount", Float) = 100.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert alpha
            #pragma fragment frag alpha
            #pragma multi_compile_fog alpha

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _Color;
            float _MinLine;
            float _MaxLine;
            float _LineCount;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float map(float org, float inmin, float inmax, float outmin, float outmax) {
                return ((org - inmin) / (inmax - inmin)) * (outmax - outmin) + outmin;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                // col.a = 100;
                return col * _Color * map(sin(i.uv.y * (_LineCount*3.1415)), -1, 1, _MinLine, _MaxLine) * (clamp(map(sin(_Time.x*100 + i.uv.y*10), -1, 1, -1.5, 0.5), 0.0, 1.0) + 0.5);
                // return float4(1,1,1,1)* sin(_Time.x);
            }
            ENDCG
        }
    }
}
