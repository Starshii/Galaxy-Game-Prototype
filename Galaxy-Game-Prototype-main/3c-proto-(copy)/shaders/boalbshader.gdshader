shader_type spatial;


void vertex() {
	VERTEX += sin(TIME * 2.0) * 0.001;
	
	// Rotation
	vec2 OriginalPos = vec2(VERTEX.x, VERTEX.z);
	mat2 Angle = mat2(vec2(cos(TIME), -sin(TIME)), vec2(sin(TIME), cos(TIME)));
	VERTEX.xz = Angle * OriginalPos;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
