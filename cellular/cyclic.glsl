#version 300 es
precision highp float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
// buffer to keep the state of the simulation
uniform sampler2D u_buffer0;

#include '../constants.glsl'
#include '../utils/noise.glsl'
#include '../utils/2d-utils.glsl'
#include '../utils/gradients.glsl'

// The cyclic cellular automaton can be interpreted as a model to 
// thermodynamic cycles. Each cell can be in a discrete state from 1 to N, and
// if one of its neighbors is the successor state, modular N+1, (which means that 0 is the 
// successor state of N, then the next iteration the cell becomes its successor.
// We can see each state as a specie, zebras eat grass, lions eat zebras, and microbes eat lions when they die,
// repeating the cycle.
// https://en.wikipedia.org/wiki/Cyclic_cellular_automaton
#if defined(BUFFER_0)
float cyclic(vec2 r, float size, float ntypes) {
    vec2 current = floor(r * floor(size) ) + .5;  ; // current cell
    
    // current type
    float type = texture(u_buffer0, fract(unref(current/size, u_resolution)) ).r;
    // count successors
    float cs = 0.;

    // the sucessor of this type.
    float successor = mod( floor(type * (ntypes+1.)) + 1., ntypes);
    
    // count for neighbors successors
    for(int i= -1; i <= 1; i += 1) {
        for(int j= -1; j <= 1; j += 1) {
            // what is the neighbor type ?
            float nt = texture(u_buffer0, fract( unref((current + vec2(i,j) ) / size, u_resolution )) ).r;
            // if it is a successor add it to the count.
            cs +=  float( floor(nt * (ntypes+1.)) == successor);   
        } 
    }
    
    // if the cell has more than one successor, then it becomes 
    // the successor normalized, or else it stays the same type.
    return cs >= 1. ? (successor/ntypes) : type;
}

out vec4 pixel; 
void main() {

    // size of the simulation
    float size = 400.;
    // number of types
    float ntypes = 24.;

    // reference frame [-0.5,0.5] with corrected aspect ratio
    vec2 rf = ref(UV, u_resolution);
    
    // every 15 seconds restart the simulation
    float c =  mod(floor(u_time),15.) == 0. ? 
        // initialized a random cell 
        floor(hash(floor(u_time) + floor(rf*size)+400.)*ntypes)/ntypes : 
        // perform the simulation
        cyclic(rf, size, ntypes);

    pixel = vec4(vec3(c),1.); 
}
#else
// we just copy the texture buffer to the screen
// and apply a gradient to the types...
out vec4 pixel; 
void main() {
    pixel = vec4( lava( texture(u_buffer0,UV).r) , 1.);
}
#endif  