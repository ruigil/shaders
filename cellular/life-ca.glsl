#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform vec3 u_color;
uniform sampler2D u_buffer0;

#include '../constants.glsl'
#include '../utils/noise.glsl'
#include '../utils/2d-utils.glsl'

#define SIZE 70.

// Conway Game of Life 
// https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life


// so we define a buffer that receives itself as an input texture, 
// that we will use to keep the state of the simulation
#if defined(BUFFER_0)

float life(vec2 r) {
    vec2 current = floor( r*SIZE) + .5; // current cell

    // we read the previous state from the texture buffer
    float alive = 1.-texture(u_buffer0, fract(unref( (current/SIZE), u_resolution )) ).r; // is it alive ?
    float nb = 0.; // neighbours

    // we count the neighbours...
    for(int i= -1; i <= 1; i += 1) {
        for(int j= -1; j <= 1; j += 1) {
            nb += 1.-texture(u_buffer0, fract( unref((current + vec2(i,j) ) / SIZE, u_resolution )) ).r;
        }
    }
    nb -= alive; // do not count self
    
    // paint a little cicle for the cells that are alive
    float cell = fill(circle(r - (current/SIZE), (1./(SIZE*2.5))), EPS, true);
    // rules... 
    // 1) if alive and 2 or 3 neighbors stay alive
    // 2) if dead and exactly three neighbors then born
    // 3) else dead...
    return (bool(alive) && (nb == 2. || nb == 3.)) || (!bool(alive) && nb == 3.) ? cell : 0.;
}
out vec4 pixel;
void main() {

    // reference frame [-0.5,0.5] with corrected aspect ratio
    vec2 rf = ref(UV, u_resolution);
    // do the same with the mouse position
    vec2 mouse = ref(u_mouse/u_resolution, u_resolution);

    // mouse center
    vec2 mc = vec2( rf - (floor(mouse*SIZE)/SIZE)) - vec2(1./(SIZE*2.) );

    float l =
        // random cell initialisation 
        floor( hash( u_time + floor(rf*SIZE) ) + .5 ) *
        // in a 3x3 square size at the mouse center 
        fill( rect( mc, vec2(3./SIZE) ), EPS, true ) +
        // plus life simulation 
        life(rf);

    pixel = vec4(vec3(1.-l),1.); 
}
#else
// we just copy the texture to the screen...
out vec4 pixel;
void main() {
    pixel = vec4(texture(u_buffer0,UV).rgb,1.);
}
#endif