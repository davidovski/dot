#version 330

int delta = 20;
float barh = 0.05;
float barw = 0.6;
int nbar = 8;

float maxoff = 32;
float minoff = 2;
float hue = 0.3;

// blinds
int blinds_spacing = 4;
int blinds_width = 1;
float blinds_intensity = 1.2;

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

vec4 blinds(vec4 c, vec2 coords) {
    if (mod(coords.y, blinds_spacing)  < blinds_width) {
        return c * blinds_intensity;
    }

    return c;
}

vec3 hueShift( vec3 color, float hueAdjust ){

    const vec3  kRGBToYPrime = vec3 (0.299, 0.587, 0.114);
    const vec3  kRGBToI      = vec3 (0.596, -0.275, -0.321);
    const vec3  kRGBToQ      = vec3 (0.212, -0.523, 0.311);

    const vec3  kYIQToR     = vec3 (1.0, 0.956, 0.621);
    const vec3  kYIQToG     = vec3 (1.0, -0.272, -0.647);
    const vec3  kYIQToB     = vec3 (1.0, -1.107, 1.704);

    float   YPrime  = dot (color, kRGBToYPrime);
    float   I       = dot (color, kRGBToI);
    float   Q       = dot (color, kRGBToQ);
    float   hue     = atan (Q, I);
    float   chroma  = sqrt (I * I + Q * Q);

    hue += hueAdjust;

    Q = chroma * sin (hue);
    I = chroma * cos (hue);

    vec3    yIQ   = vec3 (YPrime, I, Q);

    return vec3( dot (yIQ, kYIQToR), dot (yIQ, kYIQToG), dot (yIQ, kYIQToB) );

}

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

vec4 window_color(vec2 uv) {
    return blinds(texelFetch(tex, ivec2(uv), 0), uv);
}

vec4 window_shader() {
    float b = get_box();

    if (b == -1.0) {
        vec4 c = window_color(ivec2(texcoord));
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
    offset_color.x = window_color(uvr).x;
    offset_color.y = window_color(uvg).y;
    offset_color.z = window_color(uvb).z;

    offset_color.x = hueShift(window_color(uvr).xyz, hue).x;
    offset_color.y = hueShift(window_color(uvg).xyz, hue).y;
    offset_color.z = hueShift(window_color(uvb).xyz, hue).z;

    offset_color.xyz = hueShift(offset_color.xyz, -hue);
    // Set the new color
    vec4 c;
    c.w = texelFetch(tex, ivec2(uvr), 0).w;
    c.xyz = offset_color;

    c.xyz = hueShift(c.xyz, random(mod(b, 2000)));

    return default_post_processing(c);
}

