shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float flip_progress : hint_range(0.0, 1.0) = 0.0;
uniform bool vertical_flip = false;
uniform bool reverse_direction = false;

void fragment() {
    vec2 uv_centered = UV - 0.5;
    
    float angle = flip_progress * 3.14159;
    float cos_a = cos(angle);
    float sin_a = sin(angle);
    
    // Reverse direction by flipping sin_a sign
    if (reverse_direction) sin_a = -sin_a;
    
    bool flip_x = !vertical_flip;
    float coord = flip_x ? uv_centered.x : uv_centered.y;
    float camera_distance = 5.0;
    
    float denom = cos_a * camera_distance + coord * sin_a;
    if (abs(denom) < 0.001) discard;
    
    float orig_coord = (coord * camera_distance) / denom;
    float perspective_factor = (camera_distance - orig_coord * sin_a) / camera_distance;
    float other_coord = (flip_x ? uv_centered.y : uv_centered.x) / perspective_factor;
    
    vec2 orig_uv = flip_x ? 
        vec2(orig_coord, other_coord) + 0.5 :
        vec2(other_coord, orig_coord) + 0.5;
    
    vec2 scale = (dFdx(SCREEN_UV) + dFdy(SCREEN_UV)) / (dFdx(UV) + dFdy(UV));
    vec2 screen_uv = orig_uv * scale + (SCREEN_UV - UV * scale);
    
    if (any(greaterThan(orig_uv, vec2(1.0))) || any(lessThan(orig_uv, vec2(0.0)))) discard;
    
    COLOR = texture(SCREEN_TEXTURE, screen_uv);
}