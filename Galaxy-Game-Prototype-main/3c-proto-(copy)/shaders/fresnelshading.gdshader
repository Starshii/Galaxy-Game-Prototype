shader_type spatial;

uniform vec3 HLColour : source_color;

void fragment() {
    ALBEDO += clamp(-dot(NORMAL, vec3(0.0, 0.0, 1.0)) + 0.5, 0.0, 1.0) * HLColour;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
