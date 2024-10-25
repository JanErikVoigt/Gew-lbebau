shader_type spatial;

void vertex() {
	bool up = (VERTEX.y > 0.0);
	bool side = VERTEX.x > 0.0;

	VERTEX.z *= INSTANCE_CUSTOM.x;

	if (VERTEX.z < 0.0) {
		if (VERTEX.x > 0.0) {
			VERTEX.z += INSTANCE_CUSTOM.y;
		}
		if (VERTEX.y > 0.0) {
			VERTEX.z += INSTANCE_CUSTOM.z;
		}
	}


	//VERTEX = vec3(VERTEX.x,VERTEX.y,VERTEX.z * INSTANCE_CUSTOM.x);
	//COLOR = INSTANCE_CUSTOM;
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = COLOR.xyz;//vec4(1.0,1.0,1.0,1.0);
	ROUGHNESS = 1.0;
	SPECULAR = 0.2;
	METALLIC = 0.01;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
