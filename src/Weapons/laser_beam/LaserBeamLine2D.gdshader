shader_type canvas_item;

uniform float time : hint_range(0, 100);
uniform float twist_factor : hint_range(0, 2);
uniform vec2 screen_size;
uniform vec4 laser_color : hint_color;

void vertex() {
    float twist_speed = 2.0; // Adjust the speed of the twist.
    float offset = sin(TIME * twist_speed) * twist_factor;

    // Calculate the cosine and sine of the offset.
    float cos_offset = cos(offset);
    float sin_offset = sin(offset);

    // Apply the twist manually to the vertices.
    float x = VERTEX.x * cos_offset - VERTEX.y * sin_offset;
    float y = VERTEX.x * sin_offset + VERTEX.y * cos_offset;
    
    VERTEX.x = x;
    VERTEX.y = y;
}


void fragment() {
    // Create the core beam color.
    vec3 core_color = vec3(1.0, 0.8, 1.0); // Adjust the color.
    vec3 twist_color = vec3(1.0, 1.0, 0.0); // Adjust the color.

	
	
    // Interpolate between core and twist colors based on distance.
    float distance = length(FRAGCOORD.xy / screen_size);
    vec3 final_color = mix(core_color, twist_color, distance);
    
    // Apply time-dependent pulsing to the final color.
    final_color *= 0.8 + 0.2 * sin(TIME * 5.0);
    
    COLOR = vec4(final_color * laser_color.xyz, 1.0);
}