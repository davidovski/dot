#version 330

float maxoff = 10;
float minoff = 2;
float hue = 0.3;

float block_max = 500;
float block_min = 200;

in vec2 texcoord;             // texture coordinate of the fragment
uniform sampler2D tex;        // texture of the window

vec4 default_post_processing(vec4 c);

uniform float time; // Time in miliseconds.

float max_opacity = 0.9;
float opacity_threshold(float opacity)
{
  // if statement jic?
  if (opacity >= max_opacity)
  {
    return 1.0;
  }
  else 
  {
    return min(1, opacity/max_opacity);
  }

}

// Pseudo-random function (from original shader)
float random(float n) {
    return fract(sin(n) * 43758.5453f);
}

float rand_offset(float b, float off) {
    return (random(b*64) - 0.5) * (off*2);
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

vec4 anim(float alpha) {
    float block = mix(block_max, block_min, alpha);
    vec2 bs = floor(texcoord / block) * block + block/2;

    float b = random(bs.y) * random(mod(time/10000,2));

    float off = mix(maxoff, minoff, alpha);
    if (b > alpha) {
        off = 0;
    }

    // Offsets in pixels for each color
    vec2 uvr = vec2(rand_offset(b*1, off), rand_offset(b*6, off));
    vec2 uvg = vec2(rand_offset(b*2, off), rand_offset(b*7, off));
    vec2 uvb = vec2(rand_offset(b*3, off), rand_offset(b*8, off));

    // Calculate offset coords
    uvr += texcoord;
    uvg += texcoord;
    uvb += texcoord;

    // Fetch colors using offset coords
    vec3 offset_color;
    offset_color.x = texelFetch(tex, ivec2(uvr), 0).x;
    offset_color.y = texelFetch(tex, ivec2(uvg), 0).y;

    offset_color.x = hueShift(texelFetch(tex, ivec2(uvr), 0).xyz, hue).x;
    offset_color.y = hueShift(texelFetch(tex, ivec2(uvg), 0).xyz, hue).y;
    offset_color.z = hueShift(texelFetch(tex, ivec2(uvb), 0).xyz, hue).z;

    offset_color.xyz = hueShift(offset_color.xyz, -hue);
    
    // Set the new color
    vec4 c;
    c.w = texelFetch(tex, ivec2(uvr), 0).w;
    c.xyz = offset_color;

    return default_post_processing(c);
}

vec4 window_shader() {
    vec4 c = texelFetch(tex, ivec2(texcoord), 0);
    c = default_post_processing(c);
    float opacity = opacity_threshold(c.w);
    if (opacity != 1.0)
    {
        c = anim(opacity);
    }
    //c = anim(opacity);
    return default_post_processing(c);
}

