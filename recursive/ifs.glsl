#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#include '../constants.glsl'
#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

vec2 uvSierpinskiCarpet(vec2 uv, int n) {
    for (int i=0; i<n; i++) {
        uv = fold(uv*3.,radians(45.))-vec2(2.0,1.0);
        uv = vec2(uv.x,uv.y-1.);
    }
    return uv;    
}

vec2 affine(vec2 r, vec2 tr, vec2 sc, float dg) {
    return ((r+tr)*rot(radians(dg))*sc);
}

float generator(vec2 r, int n) {
    float acc = 0.;

    for (int i=0; i<n; i++) {
        vec2 r1 = affine(r, vec2(-.3), vec2(1.5,2.), 45. );
        float s1 = fill(rect(r, vec2(.5) ), EPS, true);
        float s2 = fill(rect(r1, vec2(.5)), EPS, true );
        acc = max(max(acc, s1 ), s2);
    }

    return acc;
}

out vec4 pixel;
void main() {

    vec2 r = ref(UV, u_resolution) * 2.;

    float f = fill(rect(uvSierpinskiCarpet(r,1), vec2(.5)), EPS, true);

    pixel = vec4(vec3(f),1.);
}