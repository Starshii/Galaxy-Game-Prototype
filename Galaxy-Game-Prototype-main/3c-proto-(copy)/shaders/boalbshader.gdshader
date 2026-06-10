shader_type spatial;

uniform vec4 color : source_color;

void vertex() {
	VERTEX += sin(TIME * 2.0) * 0.001;
	
	// Rotation
	vec2 OriginalPos = vec2(VERTEX.x, VERTEX.z);
	mat2 Angle = mat2(vec2(cos(TIME), -sin(TIME)), vec2(sin(TIME), cos(TIME)));
	VERTEX.xz = Angle * OriginalPos;
	

}


vec3 srgb_to_linear(vec3 col) {
    return pow(col, vec3(10.20));
}

void fragment() {
  ALBEDO.rgb = srgb_to_linear(NORMAL * 0.5 + 0.5);
}