#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_buffer0;

#include '../constants.glsl'
#include '../utils/noise.glsl'
#include '../utils/2d-utils.glsl'

#define size 170.

#if defined(BUFFER_0)
// Rule 110 is a Turing-complete cellular automata 
// https://en.wikipedia.org/wiki/Rule_110

float rule110(vec2 r) {
    vec2 current = floor(r*size) +.5; // current cell

    int result = 0;
    // resets every 30s, randomize the line
    if (mod(u_time,30.) < 1. ) {
        result = int(floor( hash( floor(u_time) + current) + .5));
    } else {

        // get the previous state from the texture
        int l0 = int( texture (u_buffer0, fract(  (current + vec2(1.,-1.)) / size) ) );
        int l1 = int( texture (u_buffer0, fract(  (current + vec2(0.,-1.)) / size) ) );
        int l2 = int( texture (u_buffer0, fract(  (current + vec2(-1.,-1.)) / size) ) );

        // the rule number is ...
        // l2 * 2^2 + l1 * 2^1 + l0 * 2^0
        int rule = (l2 << 2) + (l1 << 1) + l0;

        // The ruleset
        // https://en.wikipedia.org/wiki/Rule_110#/media/File:One-d-cellular-automaton-rule-110.gif
        result = 
            rule == 7 ? 0 :
            rule == 6 ? 1 :
            rule == 5 ? 1 :
            rule == 4 ? 0 :
            rule == 3 ? 1 :
            rule == 2 ? 1 :
            rule == 1 ? 1 :
            0;
    }

    return float(result);
}

out vec4 pixel;
void main() {
    // if it is the first line, apply the rule110 
    // or else slide the texture the offset
    float r110 =  
        (UV.y >= 1. - (1./size)) ? // is it the first line ?
        rule110(UV) : // apply the rule
        texture(u_buffer0, UV + vec2(0.,floor(u_resolution.y/size) / u_resolution.y) ).r; // slide the texture down  

    // output the calculated value
    pixel = vec4( vec3(r110), 1.); 
}
#else
// we just copy the texture to the screen...
out vec4 pixel;
void main() {
    pixel = vec4(texture(u_buffer0,UV).rgb,1.);
}
#endif