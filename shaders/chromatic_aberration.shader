shader_type canvas_item;

uniform bool apply = true;
uniform float amount = 1.0;
//uniform sampler2D offset_texture : hint_white;

void fragment() {
	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	float adjusted_amount = amount / 100.0;
    c.r = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + adjusted_amount, SCREEN_UV.y), 0.0).r;
	c.g = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).g;
	c.b = textureLod(SCREEN_TEXTURE, vec2(SCREEN_UV.x + adjusted_amount, SCREEN_UV.y), 0.0).b;
	COLOR.rgb = c;
}