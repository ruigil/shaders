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

    float v = 
        fill(circle(r + vec2(-.25), .12), EPS*5., false) *
        stroke(circle(r + vec2(.3), .2), .1, EPS*5., false) *
        stroke(circle(r + vec2(-.25,-.25), .3), .1, EPS*5., false) *
        fill(circle(r + vec2(.4,-.25), .2), EPS*5., false) *
        fill(circle(r + vec2(-.1, .5), .1), EPS*5., false) *
        fill(circle(r + vec2(-.4, .3), .15), EPS*5., false) *
        stroke(circle(r, .8), .1, EPS*5., false);

    pixel = vec4(vec3(v),1.);
}