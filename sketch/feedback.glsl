#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D u_buffer0;

#include '../constants.glsl'
#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'


#if defined(BUFFER_0)
out vec4 pixel;
void main() {

    vec2 r = ref(UV, u_resolution) * 2.;
    float n = noise(r.yx - u_time);

    float f = xor(
            // for a never ending feedback the ratio must be smaller
            // than the window, in this case the window = (r * .5) + .5
            // but with a bigger window the negative offsets will wrap and in this case
            // give a look of partial feedback
            texture(u_buffer0,(r * .7) + .5).r, 
            fill(circle(r - vec2(n - .5) , .5), EPS, true)
        );

    pixel = vec4(vec3(f),1.);
}
#else
out vec4 pixel;
void main() { 
    pixel = vec4(vec3(texture(u_buffer0,UV).r), 1.);
}
#endif