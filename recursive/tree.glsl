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

    // initial translation with noise
    r += vec2( (abs( noise(2. * r.yy)) - .5) *.1, .6);

    float f = 0.; // collect the result

    // for recursivity, just iterate 
    // a serie of transformations of the refrence frame
    // before drawing...
    for (float i = 0.; i < 7.; i++) {

        // add a branch with half y length offset
        f += fill(rect(r - vec2(.0,.3), vec2(.1,.6)), EPS, true);
        
        // mirror in x, translate in y and scale
        r = vec2(abs(r.x), r.y - .6) * 1.5;
        
        // rotate the reference frame for the next branch
        r *= rot(radians(35.));
        
        // add a bit of noise to make it wave.
        r -= vec2( noise(2.*r.yy ) * .1 , .0);
        
        // and repeat...
    }

    pixel = vec4(vec3(f),1.);
}