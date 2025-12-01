#version 330


int delta = 20;
float barh = 0.02;
float barw = 0.4;
int nbar = 16;

float maxoff = 5;
float minoff = 2;

in vec2 texcoord;             // texture coordinate of the fragment

uniform sampler2D tex;        // texture of the window
ivec2 window_size = textureSize(tex, 0);
ivec2 window_center = ivec2(window_size.x/2, window_size.y/2);

// Default window post-processing:
// 1) invert color
// 2) opacity / transparency
// 3) max-brightness clamping
// 4) rounded corners
vec4 default_post_processing(vec4 c);

uniform float time; // Time in miliseconds.

float alpha = round(time/delta); // Like time, but in seconds and resets to 

// Pseudo-random function (from original shader)
float random(float n) {
    return fract(sin(n) * 43758.5453f);
}

float get_box() {
    float n = random(alpha)*(nbar);

    for(int i=0;i<n;i++){
        float y = random(mod(alpha, 2048)+i) * window_size.y;
        float x = random(mod(alpha+128, 2048)+i) * window_size.x;
        float w = random(mod(alpha+64, 2048)+i) * barw*window_size.x;
        float h = random(mod(alpha+32, 2048)+i) * barh*window_size.y;
        if (texcoord.y > y && texcoord.y < y + h
         && texcoord.x > x && texcoord.x < x + w) {
            return i*w*h*y*x*n;
        }
    }
    return -1.0f;
}

float rand_offset(float b) {
    return (random(b*64) - 0.5) * (maxoff*2);
}

vec4 window_shader() {
    float b = get_box();

    if (b == -1.0) {
        vec4 c = texelFetch(tex, ivec2(texcoord), 0);
        return default_post_processing(c);
    }
    //b = random(mod(alpha, 2000));

    // Offsets in pixels for each color
    vec2 uvr = vec2(rand_offset(b*1), rand_offset(b*6));
    vec2 uvg = vec2(rand_offset(b*2),rand_offset(b*7));
    vec2 uvb = vec2(rand_offset(b*3),rand_offset(b*8));

    // Calculate offset coords
    uvr += texcoord;
    uvg += texcoord;
    uvb += texcoord;

    // Fetch colors using offset coords
    vec3 offset_color;
    offset_color.x = texelFetch(tex, ivec2(uvr), 0).x;
    offset_color.y = texelFetch(tex, ivec2(uvg), 0).y;
    offset_color.z = texelFetch(tex, ivec2(uvb), 0).z;
    
    // Set the new color
    vec4 c;
    c.w = texelFetch(tex, ivec2(uvr), 0).w;
    c.xyz = offset_color;

    return default_post_processing(c);
}

