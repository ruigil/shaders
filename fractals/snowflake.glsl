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
    int n = int(floor(m.x*5.));

    // we create an original symmetry on the x axis
    // and then we apply another on -150 degrees to copy
    // the upper square down. This gives a raidal symmetry of 3
    vec2 lr = fold( fold(r,radians(90.)), radians(-150.)) - vec2(.0,.3);
    // then we iterate the koch curve, by combining the x simmetry
    // with a 60 degree symmetry fold
    for (int i=0; i<n; i++) {
        lr = fold(3. * fold(lr, radians(90.)) - vec2(.5,.0) , radians(60.)) - vec2(.5,.0);
    }

    // draw a shape in the resulting reference frame
    float v = stroke( rect(lr, vec2(1.,.3)) , .2, EPS, true);

    pixel = vec4(vec3(v),1.);
}