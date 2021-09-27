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

#if defined(BUFFER_0)

float cyclic(vec2 r, float size, float ntypes) {
    vec2 current = floor(r * floor(size) ) + .5;  ; // current cell
    
    vec2 tr = fract(unref(current/size, u_resolution));
    float type = texture(u_buffer0, tr ).r;
    float cs = 0.;

    float successor = mod( floor(type * (ntypes+1.)) + 1., ntypes);
    // count for neighbors successors
    for(int i= -1; i <= 1; i += 1) {
        for(int j= -1; j <= 1; j += 1) {
            float nt = texture(u_buffer0, fract( unref((current + vec2(i,j) ) / size, u_resolution )) ).r;
            cs +=  ( floor(nt* (ntypes+1.)) == successor) ? 1. : 0.;   
        } 
    }
    
    float s = (1./size)*.5;


    type = cs >= 1. ? successor/ntypes : type;

    //type = successor == 1. ? 1./ntypes  : type;



    return type;// * fill(circle(r - (current/size), s) , EPS, true);
}
out vec4 pixel; 
void main() {

    float size = 400.;
    float ntypes = 24.;


    // reference frame [-0.5,0.5] with corrected aspect ratio
    vec2 rf = ref(UV, u_resolution);
    // do the same with the mouse position
    vec2 mouse = ref(u_mouse/u_resolution, u_resolution);

    // mouse center
    vec2 mc = vec2( rf - (floor(mouse*size)/size)) - vec2(1./(size*2.) );
        

    vec2 seed = floor(rf*size);
    float cell = floor(hash(seed+400.)*ntypes)/ntypes;
    //float cell = fill(circle( rf +vec2(4.*s) - s*.5, s.x*.5), EPS, true);
        //(floor( hash( floor( (rf+100.) * SIZE) ) * NTYPES ) / NTYPES);
        //fill(circle(rf - ((floor( rf*SIZE) + .5)/SIZE), (1./(SIZE*2.5))), EPS, true);
    float c =  mod(floor(u_time),15.) == 0. ?  cell : cyclic(rf, size, ntypes);

    pixel = vec4(vec3(c),1.); 
}
#else
// we just copy the texture buffer to the screen...
out vec4 pixel; 
void main() {
    pixel = vec4( lava(texture(u_buffer0,UV).r),1.);
}
#endif  