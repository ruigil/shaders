#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform float u_time;

#include '../constants.glsl'
#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'
#include '../utils/complex-math.glsl'

out vec4 pixel;
void main() {

    // convert to polar
    vec2 r = toPolar(ref(UV, u_resolution) * 40.);

    // add two oscilators on the radial coordinate
    r += vec2(r.x * (sin(r.y * 3. + u_time) *.2 + sin(r.y * 7. - u_time) *.2),0.);

    float f = 
        // repeat on the radial axis and convert to cartesian
        stroke(circle(toCarte(vec2(fract(r.x), r.y)), .5), .1, EPS, true) *
        // clip boundary
        fill(circle(toCarte(r), 10.), EPS, true);

    pixel = vec4(vec3(f),1.);
}