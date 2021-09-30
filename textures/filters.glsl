#version 300 es
precision highp float;

uniform vec2 u_resolution; // defined as R
uniform vec2 u_mouse; // defined as M

// you need to specify a texture in the settings.json
// please check the vs code glsl canvas extension documentation
uniform sampler2D u_texture_0;

#include '../constants.glsl'
#include '../utils/kernels.glsl'

// apply a convolution with a specific kernel
vec4 convolution(float[9] kernel, sampler2D t, vec2 p) {
    vec4 value = vec4(0);
    
    for(int i=0; i<9; i++) 
        value += kernel[i] * texture(t, p + vec2( (i/3) - 1 , (i%3) - 1 ) * PIXEL_SIZE);
        
    return value;
}

out vec4 pixel;
void main() {
    // Normalized mousel coordinates (from 0 to 1)
    vec2 m = M/R;

    // kernels available
    // K_EMBOSS
    // K_GAUSSIAN_BLUR
    // K_BOX_BLUR
    // K_EDGE
    // K_SHARPEN
    vec4 color = UV.x < m.x ?
        texture(u_texture_0, UV) :
        convolution(K_EMBOSS, u_texture_0, UV);
    
    pixel = vec4(color.rgb,1.);
}