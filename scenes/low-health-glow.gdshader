shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Get the UV coordinates (normalized between 0 and 1)
    vec2 uv = UV;

    // Set the gradient color: opaque on the left, transparent on the right
    float alpha = 0.5 - uv.x;

    // Assign a base color (e.g., white) and apply the gradient to the alpha
    vec4 color = vec4(1.0, 0.0, 0.0, alpha);

    // Output the final color
    COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
