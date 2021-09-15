#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_buffer0;

#include '../constants.glsl'
#include '../utils/2d-utils.glsl'

out vec4 pixel;
void main() {
    vec2 r = ref(UV, u_resolution) * 2.;

    // there is no real 3d in this sketch !
    // only a perspective transform

    // this translation simulates 
    // the rotation on a x axis in 3d
    r -= vec2(.0, .5*sin(u_time) );

    // this 2d rotation simulates 
    // a rotation in z axis in 3d
    r *= rot(radians(10. * sin(u_time * .5)));

    // the perspective transform
    vec2 pr = vec2(r.x * abs(1./r.y), abs(1./r.y)  );

    // this 2d rotation simulates 
    // the rotation on the y axis in 3d
    pr *= rot(radians(30.*sin(u_time * .5)));

    // simulates forward motion
    pr.y += u_time;

    float v = 
        // the tiles
        stroke( rect( fract(pr)-.5, vec2(.5) ), .3, EPS, true) *
        // hide the horizon
        smoothstep(.1, 1., abs(r.y) );

    pixel = vec4( vec3(v), 1.0 );
} 