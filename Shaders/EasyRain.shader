// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EasyRain/Rain_v0.5"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Ripples("Ripples", 2D) = "bump" {}
		_Height("Height", 2D) = "white" {}
		[Normal]_Normals("Normals", 2D) = "white" {}
		_NormalStrength("Normal Strength", Range( -2 , 2)) = 1
		_BaseSmoothness("Base Smoothness", Range( 0 , 1)) = 0.2
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_HumidityLevel("Humidity Level", Range( 0 , 1)) = 0.2
		_HumidityStrength("Humidity Strength", Range( 0 , 1)) = 0.147
		_HumidityGradient("Humidity Gradient", Range( -1 , 1)) = -0.5
		_WaterLevel("Water Level", Range( 0 , 1)) = 0
		_WaterStrength("Water Strength", Range( 0 , 1)) = 0.95
		_WaterGradient("Water Gradient", Range( -1 , 1)) = -0.5
		_PuddleLevel("Puddle Level", Range( 0 , 1)) = 0
		_PuddleStrength("Puddle Strength", Range( 0 , 1)) = 1
		_PuddleGradient("Puddle Gradient", Range( -1 , 1)) = -0.5
		_PuddleColor("Puddle Color", Color) = (0,0,0,0)
		_PuddleDarkness("Puddle Darkness", Range( 0 , 1)) = 0.2
		_DropStrength("Drop Strength", Range( 0 , 10)) = 1
		_DropSize("Drop Size", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float _NormalStrength;
		uniform sampler2D _Normals;
		uniform sampler2D _Height;
		uniform half _PuddleLevel;
		uniform float _PuddleGradient;
		uniform float _DropStrength;
		uniform sampler2D _Ripples;
		uniform float _DropSize;
		uniform sampler2D _Albedo;
		uniform float4 _PuddleColor;
		uniform float _HumidityLevel;
		uniform float _HumidityGradient;
		uniform float _HumidityStrength;
		uniform float _PuddleDarkness;
		uniform float _Metallic;
		uniform float _PuddleStrength;
		uniform half _WaterLevel;
		uniform float _WaterGradient;
		uniform float _WaterStrength;
		uniform half _BaseSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord80 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 uv_TexCoord214 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float4 tex2DNode213 = tex2D( _Height, uv_TexCoord214 );
			float lerpResult18_g38 = lerp( 0 , 0.5 , 1.0);
			float clampResult6_g38 = clamp( ( ( tanh( ( ( tex2DNode213.r - _PuddleLevel ) * ( _PuddleGradient * 100 ) ) ) + 1 ) * lerpResult18_g38 ) , 0 , 1 );
			float temp_output_194_0 = clampResult6_g38;
			float clampResult207 = clamp( temp_output_194_0 , 0 , 1 );
			float3 lerpResult74 = lerp( UnpackScaleNormal( tex2D( _Normals, uv_TexCoord80 ) ,_NormalStrength ) , float3( 0,0,1 ) , clampResult207);
			float3 ase_worldPos = i.worldPos;
			float2 appendResult223 = (float2(frac( ( ase_worldPos * _DropSize ).x ) , frac( ( ase_worldPos * _DropSize ).z )));
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles210 = 7 * 7;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset210 = 1.0f / 7;
			float fbrowsoffset210 = 1.0f / 7;
			// Speed of animation
			float fbspeed210 = _Time[ 1 ] * 30;
			// UV Tiling (col and row offset)
			float2 fbtiling210 = float2(fbcolsoffset210, fbrowsoffset210);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex210 = round( fmod( fbspeed210 + 0, fbtotaltiles210) );
			fbcurrenttileindex210 += ( fbcurrenttileindex210 < 0) ? fbtotaltiles210 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox210 = round ( fmod ( fbcurrenttileindex210, 7 ) );
			// Multiply Offset X by coloffset
			float fboffsetx210 = fblinearindextox210 * fbcolsoffset210;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy210 = round( fmod( ( fbcurrenttileindex210 - fblinearindextox210 ) / 7, 7 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy210 = (int)(7-1) - fblinearindextoy210;
			// Multiply Offset Y by rowoffset
			float fboffsety210 = fblinearindextoy210 * fbrowsoffset210;
			// UV Offset
			float2 fboffset210 = float2(fboffsetx210, fboffsety210);
			// Flipbook UV
			half2 fbuv210 = appendResult223 * fbtiling210 + fboffset210;
			// *** END Flipbook UV Animation vars ***
			float2 lerpResult251 = lerp( float2( 0,0 ) , (UnpackScaleNormal( tex2D( _Ripples, fbuv210 ) ,_DropStrength )).xy , clampResult207);
			float3 appendResult250 = (float3(( (lerpResult74).xy + lerpResult251 ) , (lerpResult74).z));
			o.Normal = appendResult250;
			float lerpResult18_g39 = lerp( 0 , 0.5 , _HumidityStrength);
			float clampResult6_g39 = clamp( ( ( tanh( ( ( tex2DNode213.r - _HumidityLevel ) * ( _HumidityGradient * 100 ) ) ) + 1 ) * lerpResult18_g39 ) , 0 , 1 );
			float lerpResult268 = lerp( 0 , _PuddleDarkness , temp_output_194_0);
			float4 clampResult180 = clamp( ( tex2D( _Albedo, uv_TexCoord80 ) - ( ( float4( 1,1,1,0 ) - _PuddleColor ) * ( clampResult6_g39 + lerpResult268 ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,1 ) );
			o.Albedo = clampResult180.rgb;
			o.Metallic = _Metallic;
			float clampResult292 = clamp( clampResult207 , 0 , _PuddleStrength );
			float lerpResult18_g40 = lerp( 0 , 0.5 , _WaterStrength);
			float clampResult6_g40 = clamp( ( ( tanh( ( ( tex2DNode213.r - _WaterLevel ) * ( _WaterGradient * 100 ) ) ) + 1 ) * lerpResult18_g40 ) , 0 , 1 );
			float clampResult188 = clamp( clampResult6_g40 , _BaseSmoothness , 1 );
			float clampResult293 = clamp( ( clampResult292 + clampResult188 ) , 0 , 1 );
			o.Smoothness = clampResult293;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14501
1963;92;1405;808;2104.342;-938.0022;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;206;-3008,48;Float;False;2094;1673.9;Height Maps;20;218;179;154;177;195;67;137;162;185;35;194;191;192;215;85;263;274;278;282;299;;0.5597427,0.7184585,0.875,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;215;-2240,96;Float;False;642.4;272.5;Texture HeightMap;2;214;213;;0.6544118,0.4738844,0.2454044,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;228;-2308.8,-288;Float;False;957.3997;296.5999;Fixed Animation UVs;7;240;221;239;238;223;227;226;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;214;-2208,160;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;221;-2272,-224;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;240;-2272,-80;Float;False;Property;_DropSize;Drop Size;22;0;Create;True;0;1;0.8;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-1856,1200;Half;False;Property;_PuddleLevel;Puddle Level;16;0;Create;True;0;0;0.6455908;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;299;-1352.342,1328.002;Float;False;Constant;_Float0;Float 0;23;0;Create;True;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;-1952,-224;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;213;-1904,158.4;Float;True;Property;_Height;Height;2;0;Create;True;0;None;30db1a333b34fb94b9cfd15f61b5bad8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;195;-1856,1280;Float;False;Property;_PuddleGradient;Puddle Gradient;18;0;Create;True;0;-0.5;-0.37;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;263;-1184.1,767.8096;Float;False;Property;_PuddleDarkness;Puddle Darkness;20;0;Create;True;0;0.2;0.13;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-1856,1040;Float;False;Property;_HumidityGradient;Humidity Gradient;12;0;Create;True;0;-0.5;-0.1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-1856,960;Float;False;Property;_HumidityLevel;Humidity Level;10;0;Create;True;0;0.2;0.9974852;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-1857.3,1121.3;Float;False;Property;_HumidityStrength;Humidity Strength;11;0;Create;True;0;0.147;0.246;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;194;-1184,1200;Float;False;NoiseAdjust;-1;;38;735a84e76a7a3e04a8e15a153cd81df3;0;4;1;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;238;-1824,-224;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FractNode;226;-1600,-224;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;191;-1184,944;Float;False;NoiseAdjust;-1;;39;735a84e76a7a3e04a8e15a153cd81df3;0;4;1;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;227;-1600,-160;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;268;-832,944;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;223;-1488,-224;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;278;-1520,112;Float;False;567.8104;261.0916;Puddle Color;3;277;276;275;;0.05985078,0.1115074,0.3014706,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;264;-679.8995,623.0092;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;208;-1120,-720;Float;False;364.8;472.6013;Textures;2;69;52;;0.2608131,0.4456806,0.9852941,1;0;0
Node;AmplifyShaderEditor.ColorNode;275;-1488,176;Float;False;Property;_PuddleColor;Puddle Color;19;0;Create;True;0;0,0,0,0;0.4039216,0.4705882,0.4784314,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;210;-1328,-224;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;7;False;2;FLOAT;7;False;3;FLOAT;30;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;98;-1424,-400;Float;False;Property;_NormalStrength;Normal Strength;4;0;Create;True;0;1;1;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;280;-602.1858,539.1078;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;274;-1424.494,1340.311;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1856,1360;Half;False;Property;_WaterLevel;Water Level;13;0;Create;True;0;0;0.9971817;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-1328,-48;Float;False;Property;_DropStrength;Drop Strength;21;0;Create;True;0;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;80;-1424,-544;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;185;-1856,1520;Float;False;Property;_WaterStrength;Water Strength;14;0;Create;True;0;0.95;0.648;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-1856,1440;Float;False;Property;_WaterGradient;Water Gradient;15;0;Create;True;0;-0.5;-0.07;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;282;-1094.984,315.1083;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;192;-1184,1456;Float;False;NoiseAdjust;-1;;40;735a84e76a7a3e04a8e15a153cd81df3;0;4;1;FLOAT;0;False;11;FLOAT;0;False;12;FLOAT;0;False;13;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;207;-606.4,1198.4;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;276;-1264,176;Float;False;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;217;-1024,-208;Float;True;Property;_Ripples;Ripples;1;0;Create;True;0;None;344e53d5caf48d04ea94bca56ea850ba;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;69;-1072,-464;Float;True;Property;_Normals;Normals;3;1;[Normal];Create;True;0;None;31d59f49be09a1741904100118f0b303;True;0;True;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;289;-881.5999,1347.2;Float;False;Property;_PuddleStrength;Puddle Strength;17;0;Create;True;0;1;0.227;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1856,1600;Half;False;Property;_BaseSmoothness;Base Smoothness;5;0;Create;True;0;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;248;-480,-64;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;74;-512,-320;Float;False;3;0;FLOAT3;0,0,1;False;1;FLOAT3;0,0,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;188;-608,1584;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-1104,176;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;292;-584.9542,1368.6;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;279;-726.9858,76.7081;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;52;-1072,-672;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;None;a45ea0c1bca244d45a869e13570b6b59;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;246;-256,-368;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;251;-192,-64;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;85;-2960,384;Float;False;1355.899;474.4;Default Rain Noise;8;89;101;9;198;20;8;196;86;;0.7941176,0.3153115,0.3153115,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;287;-351.5812,1396.209;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;249;16,-320;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;155;-512,-672;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;247;-256,-272;Float;False;False;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;86;-2112,464;Float;False;313;154;Normalize [0 - 1];2;88;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;293;-24.25464,1399.599;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;144,208;Float;False;Property;_Metallic;Metallic;6;0;Create;True;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;101;-2320,512;Float;False;FBM (3D);-1;;41;61109b682eb52c547b06c8c814388475;0;1;2;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2480,512;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;290;-348.1504,1290.199;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;250;192,-288;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;-2672,448;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2928,768;Float;False;Property;_MainNoiseSize;Main Noise Size;8;0;Create;True;0;0.25;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;196;-2928,608;Float;False;Property;_MainNoiseOffset;Main Noise Offset;9;0;Create;True;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;296;356.3395,486.2261;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;8;-2928,448;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;218;-1856,880;Half;False;Property;_NoiseStrength;Noise Strength;7;0;Create;True;0;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;297;415.3395,226.2261;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-2080,512;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;89;-1776,512;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-1936,512;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;180;160,-672;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;496,144;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;EasyRain/Rain_v0.5;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;239;0;221;0
WireConnection;239;1;240;0
WireConnection;213;1;214;0
WireConnection;194;1;213;1
WireConnection;194;11;137;0
WireConnection;194;12;195;0
WireConnection;194;13;299;0
WireConnection;238;0;239;0
WireConnection;226;0;238;0
WireConnection;191;1;213;1
WireConnection;191;11;154;0
WireConnection;191;12;177;0
WireConnection;191;13;179;0
WireConnection;227;0;238;2
WireConnection;268;1;263;0
WireConnection;268;2;194;0
WireConnection;223;0;226;0
WireConnection;223;1;227;0
WireConnection;264;0;191;0
WireConnection;264;1;268;0
WireConnection;210;0;223;0
WireConnection;280;0;264;0
WireConnection;274;0;213;1
WireConnection;282;0;280;0
WireConnection;192;1;274;0
WireConnection;192;11;35;0
WireConnection;192;12;162;0
WireConnection;192;13;185;0
WireConnection;207;0;194;0
WireConnection;276;1;275;0
WireConnection;217;1;210;0
WireConnection;217;5;229;0
WireConnection;69;1;80;0
WireConnection;69;5;98;0
WireConnection;248;0;217;0
WireConnection;74;0;69;0
WireConnection;74;2;207;0
WireConnection;188;0;192;0
WireConnection;188;1;67;0
WireConnection;277;0;276;0
WireConnection;277;1;282;0
WireConnection;292;0;207;0
WireConnection;292;2;289;0
WireConnection;279;0;277;0
WireConnection;52;1;80;0
WireConnection;246;0;74;0
WireConnection;251;1;248;0
WireConnection;251;2;207;0
WireConnection;287;0;292;0
WireConnection;287;1;188;0
WireConnection;249;0;246;0
WireConnection;249;1;251;0
WireConnection;155;0;52;0
WireConnection;155;1;279;0
WireConnection;247;0;74;0
WireConnection;293;0;287;0
WireConnection;101;2;9;0
WireConnection;9;0;198;0
WireConnection;9;1;20;0
WireConnection;290;0;292;0
WireConnection;290;1;188;0
WireConnection;250;0;249;0
WireConnection;250;2;247;0
WireConnection;198;0;8;0
WireConnection;198;1;196;0
WireConnection;296;0;293;0
WireConnection;297;0;42;0
WireConnection;87;0;101;0
WireConnection;89;0;88;0
WireConnection;88;0;87;0
WireConnection;180;0;155;0
WireConnection;0;0;180;0
WireConnection;0;1;250;0
WireConnection;0;3;297;0
WireConnection;0;4;296;0
ASEEND*/
//CHKSM=69D9CD771FC937F8C49A3FFA369D95C27DD46007