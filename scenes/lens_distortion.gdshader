shader_type canvas_item;

uniform float distortion = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 pos;

void fragment() {    
		vec3 col = texture(screen_texture, SCREEN_UV).xyz;
		vec2 uv = SCREEN_UV + (1.0 - length(SCREEN_UV - pos)) * (SCREEN_UV - pos) * distortion;
		//float distX = SCREEN_UV.x - pos.x;
		//float distY = SCREEN_UV.y - pos.y;
		//float dist = length(SCREEN_UV - pos);
		//vec2 newUV = vec2(SCREEN_UV.x - distX * dist, SCREEN_UV.y - distY * dist);
		COLOR.xyz = vec3(0.0);
		COLOR.xyz = texture(screen_texture, uv).xyz;
}
