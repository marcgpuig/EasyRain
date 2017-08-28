// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EasyRain/Rain_v0.1"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MainNoiseSize("Main Noise Size", Range( 0 , 10)) = 0.25
		_WaterLevel("Water Level", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Albedo("Albedo", 2D) = "white" {}
		_Normals("Normals", 2D) = "white" {}
		_MaxSmoothness("Max Smoothness", Range( 0 , 1)) = 0.8
		_MinSmoothness("Min Smoothness", Range( 0 , 1)) = 0.1
		_NormalStrength("Normal Strength", Range( -1 , 1)) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
			float3 worldPos;
		};

		uniform sampler2D _Normals;
		uniform float _NormalStrength;
		uniform float _MainNoiseSize;
		uniform half _WaterLevel;
		uniform sampler2D _Albedo;
		uniform float _Metallic;
		uniform half _MinSmoothness;
		uniform half _MaxSmoothness;


		float3 mod289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 appendResult118 = (float3( ( _NormalStrength - 0.0 > 0.0 ? _NormalStrength : _NormalStrength - 0.0 <= 0.0 && _NormalStrength + 0.0 >= 0.0 ? 0.0001 : _NormalStrength )  ,  ( _NormalStrength - 0.0 > 0.0 ? _NormalStrength : _NormalStrength - 0.0 <= 0.0 && _NormalStrength + 0.0 >= 0.0 ? 0.0001 : _NormalStrength )  , 1.0));
			float3 ase_worldPos = i.worldPos;
			float simplePerlin3D1_g12 = snoise( ( ase_worldPos * _MainNoiseSize ) );
			float3 temp_output_8_0_g12 = ( ( ase_worldPos * _MainNoiseSize ) * float3( 2.02,2.02,2.02 ) );
			float simplePerlin3D3_g12 = snoise( temp_output_8_0_g12 );
			float3 temp_output_9_0_g12 = ( temp_output_8_0_g12 * float3( 2.03,2.03,2.03 ) );
			float simplePerlin3D5_g12 = snoise( temp_output_9_0_g12 );
			float3 temp_output_10_0_g12 = ( temp_output_9_0_g12 * float3( 2.01,2.01,2.01 ) );
			float simplePerlin3D6_g12 = snoise( temp_output_10_0_g12 );
			float simplePerlin3D7_g12 = snoise( ( temp_output_10_0_g12 * float3( 2.02,2.02,2.02 ) ) );
			float temp_output_4_0_g12 = ( ( simplePerlin3D1_g12 * 0.5 ) + ( simplePerlin3D3_g12 * 0.25 ) + ( simplePerlin3D5_g12 * 0.125 ) + ( simplePerlin3D6_g12 * 0.0625 ) + ( simplePerlin3D7_g12 * 0.03125 ) );
			float clampResult12_g12 = clamp( temp_output_4_0_g12 , -1.0 , 1.0 );
			float clampResult89 = clamp( ( ( clampResult12_g12 * 0.5 ) + 0.5 ) , 0.0 , 1.0 );
			float lerpResult63 = lerp( -1.0 , 1.0 , _WaterLevel);
			float clampResult146 = clamp( ( clampResult89 + lerpResult63 ) , 0.0 , 1.0 );
			float3 lerpResult74 = lerp( ( UnpackNormal( tex2D( _Normals, i.texcoord_0 ) ) * appendResult118 ) , float3( 0,0,1 ) , clampResult146);
			o.Normal = lerpResult74;
			o.Albedo = tex2D( _Albedo, i.texcoord_0 ).xyz;
			o.Metallic = _Metallic;
			float clampResult65 = clamp( ( clampResult89 + lerpResult63 ) , _MinSmoothness , _MaxSmoothness );
			o.Smoothness = clampResult65;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=12101
1927;29;1906;1004;2141.64;1411.144;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;85;-2784,-144;Float;False;1248.799;287.7;Rain Noise [0-1];7;89;9;86;20;8;101;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-2736,-80;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;20;-2736,64;Float;False;Property;_MainNoiseSize;Main Noise Size;0;0;0.25;0;10;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2416,-80;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1,1,1;False;1;FLOAT3
Node;AmplifyShaderEditor.CommentaryNode;86;-2032,-80;Float;False;313;154;Normalize [0 - 1];2;88;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;101;-2256,-80;Float;False;FBM (3D);-1;;12;1;0;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-2000,-32;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-1856,-32;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;150;-1792,-960;Float;False;310;275;Avoid 0 multiplication;1;121;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-2112,-896;Float;False;Property;_NormalStrength;Normal Strength;7;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;35;-2461.201,265.1;Half;False;Property;_WaterLevel;Water Level;1;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;63;-1666.7,187.2;Float;False;3;0;FLOAT;-1.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;89;-1696,-32;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-1625.125,-1338.426;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TFHCIf;121;-1744,-896;Float;False;6;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0001;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;117;-1609.401,-654.6005;Fixed;False;Constant;_Top;Top;8;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-1456,-32;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;69;-1337.125,-1130.425;Float;True;Property;_Normals;Normals;3;0;None;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;118;-1376,-832;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.CommentaryNode;149;-1797.2,-482.0002;Float;False;748;231;TO DO;3;143;145;137;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;146;-1057.599,-139.1998;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;68;-2458.701,425.1;Half;False;Property;_MaxSmoothness;Max Smoothness;4;0;0.8;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-944,-928;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;67;-2458.701,345.1;Half;False;Property;_MinSmoothness;Min Smoothness;4;0;0.1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;143;-1425.6,-432.0002;Float;False;3;0;FLOAT;-1.0;False;1;FLOAT;1.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;137;-1747.2,-432.0002;Half;False;Constant;_PuddleLevel;Puddle Level;7;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;145;-1203.2,-384.0002;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;42;-301.2751,-120.0999;Float;False;Property;_Metallic;Metallic;2;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;65;-1165.496,196.2006;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.5;False;2;FLOAT;0.8;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;74;-656,-560;Float;False;3;0;FLOAT3;0,0,1;False;1;FLOAT3;0,0,1;False;2;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SamplerNode;52;-1337.125,-1338.426;Float;True;Property;_Albedo;Albedo;3;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;333.5998,-243.8;Float;False;True;2;Float;ASEMaterialInspector;0;Standard;Synthia/Rain_v0.1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;8;0
WireConnection;9;1;20;0
WireConnection;101;0;9;0
WireConnection;87;0;101;0
WireConnection;88;0;87;0
WireConnection;63;2;35;0
WireConnection;89;0;88;0
WireConnection;121;0;98;0
WireConnection;121;2;98;0
WireConnection;121;4;98;0
WireConnection;64;0;89;0
WireConnection;64;1;63;0
WireConnection;69;1;80;0
WireConnection;118;0;121;0
WireConnection;118;1;121;0
WireConnection;118;2;117;0
WireConnection;146;0;64;0
WireConnection;97;0;69;0
WireConnection;97;1;118;0
WireConnection;143;2;137;0
WireConnection;145;0;143;0
WireConnection;145;1;89;0
WireConnection;65;0;64;0
WireConnection;65;1;67;0
WireConnection;65;2;68;0
WireConnection;74;0;97;0
WireConnection;74;2;146;0
WireConnection;52;1;80;0
WireConnection;0;0;52;0
WireConnection;0;1;74;0
WireConnection;0;3;42;0
WireConnection;0;4;65;0
ASEEND*/
//CHKSM=5CE82C652D884612F86520FF095C5182A5A338D5