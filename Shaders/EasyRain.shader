// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EasyRain/Rain_v0.3"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_Albedo("Albedo", 2D) = "white" {}
		_Height("Height", 2D) = "white" {}
		[Normal]_Normals("Normals", 2D) = "white" {}
		_NormalStrength("Normal Strength", Range( -1 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.1
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_HumidityLevel("Humidity Level", Range( 0 , 1)) = 0.2
		_HumidityStrength("Humidity Strength", Range( 0 , 1)) = 0.147
		_HumidityGradient("Humidity Gradient", Range( -1 , 1)) = -0.5
		_WaterLevel("Water Level", Range( 0 , 1)) = 0
		_WaterStrength("Water Strength", Range( 0 , 1)) = 0.95
		_WaterGradient("Water Gradient", Range( -1 , 1)) = -0.5
		_PuddleLevel("Puddle Level", Range( 0 , 1)) = 0
		_PuddleGradient("Puddle Gradient", Range( -1 , 1)) = -0.5
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 texcoord_0;
			float2 texcoord_1;
		};

		uniform float _NormalStrength;
		uniform sampler2D _Normals;
		uniform sampler2D _Height;
		uniform half _PuddleLevel;
		uniform float _PuddleGradient;
		uniform half _WaterLevel;
		uniform float _WaterGradient;
		uniform float _WaterStrength;
		uniform half _Smoothness;
		uniform sampler2D _Albedo;
		uniform float _HumidityLevel;
		uniform float _HumidityGradient;
		uniform float _HumidityStrength;
		uniform float _Metallic;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.texcoord_0.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
			o.texcoord_1.xy = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 tex2DNode213 = tex2D( _Height, i.texcoord_1 );
			float lerpResult18_g38 = lerp( 0.0 , 0.5 , 1.0);
			float clampResult6_g38 = clamp( ( ( tanh( ( ( tex2DNode213.r - _PuddleLevel ) * ( _PuddleGradient * 100.0 ) ) ) + 1.0 ) * lerpResult18_g38 ) , 0.0 , 1.0 );
			float lerpResult18_g34 = lerp( 0.0 , 0.5 , _WaterStrength);
			float clampResult6_g34 = clamp( ( ( tanh( ( ( tex2DNode213.r - _WaterLevel ) * ( _WaterGradient * 100.0 ) ) ) + 1.0 ) * lerpResult18_g34 ) , 0.0 , 1.0 );
			float clampResult188 = clamp( clampResult6_g34 , _Smoothness , 1.0 );
			float clampResult207 = clamp( clampResult6_g38 , 0.0 , clampResult188 );
			float3 lerpResult74 = lerp( UnpackScaleNormal( tex2D( _Normals, i.texcoord_0 ) ,_NormalStrength ) , float3( 0,0,1 ) , clampResult207);
			o.Normal = lerpResult74;
			float lerpResult18_g37 = lerp( 0.0 , 0.5 , _HumidityStrength);
			float clampResult6_g37 = clamp( ( ( tanh( ( ( tex2DNode213.r - _HumidityLevel ) * ( _HumidityGradient * 100.0 ) ) ) + 1.0 ) * lerpResult18_g37 ) , 0.0 , 1.0 );
			float4 temp_cast_0 = (clampResult6_g37).xxxx;
			float4 clampResult180 = clamp( ( tex2D( _Albedo, i.texcoord_0 ) - temp_cast_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Albedo = clampResult180.xyz;
			o.Metallic = _Metallic;
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
7;29;1906;1004;3220.369;1192.71;2.2;True;False
Node;AmplifyShaderEditor.CommentaryNode;206;-2816,-224;Float;False;1947.8;1593.4;Height Maps;15;194;191;137;179;154;67;195;192;177;162;185;35;85;215;216;;0.5597427,0.7184585,0.875,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;215;-2176,320;Float;False;777;280;Texture HeightMap;2;213;214;;0.6544118,0.4738844,0.2454044,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;214;-2128,384;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;162;-1664,1104;Float;False;Property;_WaterGradient;Water Gradient;13;0;-0.5;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;185;-1664,1184;Float;False;Property;_WaterStrength;Water Strength;12;0;0.95;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;35;-1664,1024;Half;False;Property;_WaterLevel;Water Level;11;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;213;-1824,384;Float;True;Property;_Height;Height;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;67;-1664,1264;Half;False;Property;_Smoothness;Smoothness;4;0;0.1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;195;-1664,944;Float;False;Property;_PuddleGradient;Puddle Gradient;15;0;-0.5;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;137;-1664,864;Half;False;Property;_PuddleLevel;Puddle Level;14;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;192;-1152,1136;Float;False;NoiseAdjust;-1;;34;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;177;-1664,704;Float;False;Property;_HumidityGradient;Humidity Gradient;10;0;-0.5;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;208;-1264,-1008;Float;False;463;472.0013;Textures;2;52;69;;0.2608131,0.4456806,0.9852941,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-1936,-832;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;154;-1664,624;Float;False;Property;_HumidityLevel;Humidity Level;8;0;0.2;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;179;-1664,784;Float;False;Property;_HumidityStrength;Humidity Strength;9;0;0.147;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;194;-1152,880;Float;False;NoiseAdjust;-1;;38;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;98;-1639,-609;Float;False;Property;_NormalStrength;Normal Strength;3;0;0;-1;1;0;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;85;-2752,-176;Float;False;1355.899;474.4;Default Rain Noise;8;89;101;9;198;20;8;196;86;;0.7941176,0.3153115,0.3153115,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;188;-704,1248;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.FunctionNode;191;-1152,624;Float;False;NoiseAdjust;-1;;37;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;52;-1216,-960;Float;True;Property;_Albedo;Albedo;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;207;-704,880;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;86;-1904,-96;Float;False;313;154;Normalize [0 - 1];2;88;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;69;-1216,-752;Float;True;Property;_Normals;Normals;2;1;[Normal];None;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;155;-384,-480;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;-1344,176;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-1872,-48;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;180;-167.0001,-351.3003;Float;False;3;0;FLOAT4;0.0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,1,1,1;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;20;-2720,208;Float;False;Property;_MainNoiseSize;Main Noise Size;6;0;0.25;0;10;0;1;FLOAT
Node;AmplifyShaderEditor.Vector3Node;196;-2720,48;Float;False;Property;_MainNoiseOffset;Main Noise Offset;7;0;0,0,0;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.FunctionNode;101;-2112,-48;Float;False;FBM (3D);-1;;39;1;0;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-1728,-48;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;198;-2464,-112;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT3;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-2720,-112;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2272,-48;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1,1,1;False;1;FLOAT3
Node;AmplifyShaderEditor.ClampOpNode;89;-1568,-48;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;42;-128,-96;Float;False;Property;_Metallic;Metallic;5;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;74;-128,-224;Float;False;3;0;FLOAT3;0,0,1;False;1;FLOAT3;0,0,1;False;2;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;333.5998,-243.8;Float;False;True;2;Float;ASEMaterialInspector;0;Standard;Synthia/Rain_v0.3;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;213;1;214;0
WireConnection;192;0;213;1
WireConnection;192;1;35;0
WireConnection;192;2;162;0
WireConnection;192;3;185;0
WireConnection;194;0;213;1
WireConnection;194;1;137;0
WireConnection;194;2;195;0
WireConnection;188;0;192;0
WireConnection;188;1;67;0
WireConnection;191;0;213;1
WireConnection;191;1;154;0
WireConnection;191;2;177;0
WireConnection;191;3;179;0
WireConnection;52;1;80;0
WireConnection;207;0;194;0
WireConnection;207;2;188;0
WireConnection;69;1;80;0
WireConnection;69;5;98;0
WireConnection;155;0;52;0
WireConnection;155;1;191;0
WireConnection;216;0;89;0
WireConnection;216;1;213;1
WireConnection;87;0;101;0
WireConnection;180;0;155;0
WireConnection;101;0;9;0
WireConnection;88;0;87;0
WireConnection;198;0;8;0
WireConnection;198;1;196;0
WireConnection;9;0;198;0
WireConnection;9;1;20;0
WireConnection;89;0;88;0
WireConnection;74;0;69;0
WireConnection;74;2;207;0
WireConnection;0;0;180;0
WireConnection;0;1;74;0
WireConnection;0;3;42;0
WireConnection;0;4;188;0
ASEEND*/
//CHKSM=B2257D431ED205C68F5E37CB20A613190C3A343A