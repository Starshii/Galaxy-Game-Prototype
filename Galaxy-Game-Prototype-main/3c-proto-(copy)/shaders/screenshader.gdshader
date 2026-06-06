shader_type canvas_item;

uniform vec3 HLColour : source_color;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
    COLOR.xyz += clamp(-dot(NORMAL, vec3(0.0, 0.0, 1.0)) + 0.5, 0.0, 1.0) * HLColour;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
