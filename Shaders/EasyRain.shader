// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EasyRain/Rain_v0.2"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Albedo("Albedo", 2D) = "white" {}
		_Normals("Normals", 2D) = "white" {}
		_NormalStrength("Normal Strength", Range( -1 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.1
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_MainNoiseSize("Main Noise Size", Range( 0 , 10)) = 0.25
		_HumidityLevel("Humidity Level", Range( 0 , 1)) = 0.2
		_HumidityStrength("Humidity Strength", Range( 0 , 1)) = 0.147
		_HumidityGradient("Humidity Gradient", Range( -1 , 1)) = 0.2
		_WaterLevel("Water Level", Range( 0 , 1)) = 0
		_WaterSmoothnessStrength("Water Smoothness Strength", Range( 0 , 1)) = 0.25
		_WaterGradient("Water Gradient", Range( -1 , 1)) = 0.25
		_PuddleLevel("Puddle Level", Range( 0 , 1)) = 0
		_PuddleGradient("Puddle Gradient", Range( -1 , 1)) = 0.25
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
		uniform half _PuddleLevel;
		uniform float _PuddleGradient;
		uniform sampler2D _Albedo;
		uniform float _HumidityLevel;
		uniform float _HumidityGradient;
		uniform float _HumidityStrength;
		uniform float _Metallic;
		uniform half _WaterLevel;
		uniform float _WaterGradient;
		uniform float _WaterSmoothnessStrength;
		uniform half _Smoothness;


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
			float temp_output_121_0 =  ( _NormalStrength - 0.0 > 0.0 ? _NormalStrength : _NormalStrength - 0.0 <= 0.0 && _NormalStrength + 0.0 >= 0.0 ? 0.0001 : _NormalStrength ) ;
			float3 appendResult118 = (float3(temp_output_121_0 , temp_output_121_0 , 1.0));
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
			float lerpResult18_g33 = lerp( 0.0 , 0.5 , 1.0);
			float clampResult6_g33 = clamp( ( ( tanh( ( ( clampResult89 - _PuddleLevel ) * ( _PuddleGradient * 100.0 ) ) ) + 1.0 ) * lerpResult18_g33 ) , 0.0 , 1.0 );
			float3 lerpResult74 = lerp( ( UnpackNormal( tex2D( _Normals, i.texcoord_0 ) ) * appendResult118 ) , float3( 0,0,1 ) , clampResult6_g33);
			o.Normal = lerpResult74;
			float lerpResult18_g31 = lerp( 0.0 , 0.5 , _HumidityStrength);
			float clampResult6_g31 = clamp( ( ( tanh( ( ( clampResult89 - _HumidityLevel ) * ( _HumidityGradient * 100.0 ) ) ) + 1.0 ) * lerpResult18_g31 ) , 0.0 , 1.0 );
			float4 temp_cast_0 = (clampResult6_g31).xxxx;
			float4 clampResult180 = clamp( ( tex2D( _Albedo, i.texcoord_0 ) - temp_cast_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Albedo = clampResult180.xyz;
			o.Metallic = _Metallic;
			float lerpResult18_g32 = lerp( 0.0 , 0.5 , _WaterSmoothnessStrength);
			float clampResult6_g32 = clamp( ( ( tanh( ( ( clampResult89 - _WaterLevel ) * ( _WaterGradient * 100.0 ) ) ) + 1.0 ) * lerpResult18_g32 ) , 0.0 , 1.0 );
			float clampResult188 = clamp( clampResult6_g32 , _Smoothness , 1.0 );
			o.Smoothness = clampResult188;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=12101
2090;114;1565;800;2055.385;1163.409;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;85;-2784,-144;Float;False;1248.799;287.7;Rain Noise [0-1];6;89;9;86;20;8;101;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2736,64;Float;False;Property;_MainNoiseSize;Main Noise Size;5;0;0.25;0;10;0;1;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-2736,-80;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2416,-80;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1,1,1;False;1;FLOAT3
Node;AmplifyShaderEditor.FunctionNode;101;-2256,-80;Float;False;FBM (3D);-1;;12;1;0;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;86;-2032,-80;Float;False;313;154;Normalize [0 - 1];2;88;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-2000,-32;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;98;-2112,-896;Float;False;Property;_NormalStrength;Normal Strength;2;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;150;-1792,-960;Float;False;310;275;Avoid 0 multiplication;1;121;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-1856,-32;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;177;-1276.801,115.1999;Float;False;Property;_HumidityGradient;Humidity Gradient;8;0;0.2;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;179;-1276.801,195.2;Float;False;Property;_HumidityStrength;Humidity Strength;7;0;0.147;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;89;-1696,-32;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;154;-1276.801,35.20006;Float;False;Property;_HumidityLevel;Humidity Level;6;0;0.2;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-1625.125,-1338.426;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;117;-1609.401,-654.6005;Fixed;False;Constant;_Top;Top;8;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TFHCIf;121;-1744,-896;Float;False;6;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0001;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;118;-1376,-832;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SamplerNode;69;-1337.125,-1130.425;Float;True;Property;_Normals;Normals;1;0;None;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;35;-1920,384;Half;False;Property;_WaterLevel;Water Level;9;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;52;-1337.125,-1338.426;Float;True;Property;_Albedo;Albedo;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.FunctionNode;191;-736,-32;Float;False;NoiseAdjust;-1;;31;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;185;-1920,544;Float;False;Property;_WaterSmoothnessStrength;Water Smoothness Strength;10;0;0.25;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;162;-1920,464;Float;False;Property;_WaterGradient;Water Gradient;11;0;0.25;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;137;-1920,224;Half;False;Property;_PuddleLevel;Puddle Level;12;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;195;-1920,304;Float;False;Property;_PuddleGradient;Puddle Gradient;13;0;0.25;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;155;-240,-368;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-932.8,-931.1994;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;67;-560,432;Half;False;Property;_Smoothness;Smoothness;3;0;0.1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;194;-1312,336;Float;False;NoiseAdjust;-1;;33;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;192;-1312,528;Float;False;NoiseAdjust;-1;;32;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;180;-32,-368;Float;False;3;0;FLOAT4;0.0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;42;-144,-112;Float;False;Property;_Metallic;Metallic;4;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;188;-246.9862,267.6904;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;74;-656,-320;Float;False;3;0;FLOAT3;0,0,1;False;1;FLOAT3;0,0,1;False;2;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;333.5998,-243.8;Float;False;True;2;Float;ASEMaterialInspector;0;Standard;Synthia/Rain_v0.2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;8;0
WireConnection;9;1;20;0
WireConnection;101;0;9;0
WireConnection;87;0;101;0
WireConnection;88;0;87;0
WireConnection;89;0;88;0
WireConnection;121;0;98;0
WireConnection;121;2;98;0
WireConnection;121;4;98;0
WireConnection;118;0;121;0
WireConnection;118;1;121;0
WireConnection;118;2;117;0
WireConnection;69;1;80;0
WireConnection;52;1;80;0
WireConnection;191;0;89;0
WireConnection;191;1;154;0
WireConnection;191;2;177;0
WireConnection;191;3;179;0
WireConnection;155;0;52;0
WireConnection;155;1;191;0
WireConnection;97;0;69;0
WireConnection;97;1;118;0
WireConnection;194;0;89;0
WireConnection;194;1;137;0
WireConnection;194;2;195;0
WireConnection;192;0;89;0
WireConnection;192;1;35;0
WireConnection;192;2;162;0
WireConnection;192;3;185;0
WireConnection;180;0;155;0
WireConnection;188;0;192;0
WireConnection;188;1;67;0
WireConnection;74;0;97;0
WireConnection;74;2;194;0
WireConnection;0;0;180;0
WireConnection;0;1;74;0
WireConnection;0;3;42;0
WireConnection;0;4;188;0
ASEEND*/
//CHKSM=5551C2C68268A028F7E7F1F21030AC6C768EE062