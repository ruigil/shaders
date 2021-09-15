#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#include '../constants.glsl'
#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'
#include '../utils/complex-math.glsl'

out vec4 pixel;
void main() {

    // eclipse shader
    // the corona is built with a deformed circle
    // to have noise stich in a circular way, 
    // we need to sample it in a polar form

    // reference frame
    vec2 r = ref(UV, u_resolution) * 2.;
 
    // convert to polar coordinates
    vec2 pr = toPolar(r);

    // noise in the angular component
    pr.y +=  noise(r * pr.x + u_time * .1 ) - .5;
    
    // noise in the radial component
    pr.x += noise( toCarte(vec2( 10. + 5. * sin(u_time*.05), pr.y) ) );
    
    float f =
        // the sun 
        xor(stroke(circle(r,.3),.01,  EPS, true)*.7,
        // the moon
        fill(circle(r,.29), .01, false) *
        // the corona 
        fill(circle(toCarte(pr), .7), .1, true) * fbm(pr.xy-u_time*.2));

    pixel = vec4(vec3(f),1.);   
}