#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#include '../constants.glsl'
#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

out vec4 pixel;
void main() {

    vec2 r = ref(UV, u_resolution) * 2.;

    // mouse in normalized coordinates
    vec2 m = u_mouse/u_resolution;
    // controls the number of iterations
    int n = int(floor(m.x*6.));

    // with start with a normalized reference frame
    vec2 lr = r;
    for (int i=0; i<n; i++) {
        // we apply a radial symetry of 6, and a translation
        lr = modpolar(lr*2.,6.,radians(60.)) - vec2(.0,1.);
    }

    // in the last transformation we just draw one hexagon.
    float v = stroke( hex(lr, .5), .1 , EPS, true);

    pixel = vec4(vec3(v),1.);
}