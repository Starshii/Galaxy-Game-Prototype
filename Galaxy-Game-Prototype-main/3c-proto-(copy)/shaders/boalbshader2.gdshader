shader_type spatial;

uniform vec4 color : source_color;

void vertex() {
	VERTEX += sin(TIME * 2.0) * 0.001;
	
	// Rotation
	vec2 OriginalPos = vec2(VERTEX.x, VERTEX.z);
	mat2 Angle = mat2(vec2(cos(TIME), -sin(TIME)), vec2(sin(TIME), cos(TIME)));
	VERTEX.xz = Angle * OriginalPos;
}

void fragment() {
	ALBEDO = color.rgb;
}
