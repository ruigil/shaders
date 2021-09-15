#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_buffer0;

#include '../constants.glsl'
#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'
#include '../utils/complex-math.glsl'

out vec4 pixel;
void main() {

    // convert to polar
    vec2 r = toPolar(ref(UV, u_resolution) * 2. ); 

    // add two oscilators on the radial coordinate
    
    vec2 ra = r + vec2(r.x + .1 * (sin(r.y * 2. + u_time) + sin(r.y * 1. - u_time) ),0.);
    vec2 rg = r + vec2(r.x + .1 * (sin(r.y * 5. + u_time) + sin(r.y * 3. - u_time) ),0.);
    vec2 rb = r + vec2(r.x + .1 * (sin(r.y * 3. + u_time) + sin(r.y * 5. - u_time) ),0.);
    
    float red = fill(circle(toCarte(ra), 1.), EPS, true);
    float green = fill(circle(toCarte(rg), 1.), EPS, true);
    float blue = fill(circle(toCarte(rb), 1.), EPS, true);

    pixel = vec4(red,green,blue,1.);
}