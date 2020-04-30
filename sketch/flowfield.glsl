#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy/iResolution.xy)


#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

#iChannel0::MagFilter "Linear"
#iChannel0::WrapMode "Repeat"
#iChannel0 "self"


void main() {

    // a flow field is a vector field where each point is 
    // interpreted as a direction for movement or flow. 
    // This means that particles or objects the flowfield 
    // will move acordingly to the local values of vector field

    // here a flowfield is contructed interpreting the value noise
    // between [0,1] to be an angle for the direction

    vec2 r = ref;

    // we create a vector field
    vec2 ff = vec2(.0,.005)*rot(radians(noise(vec3(r, iTime*.1)) * 360.) ); 

    // we use the vector field to sample the texture feedback
    // and do a texture advection to generate flow
    float t = texture(iChannel0,fract(tex+ff)).r-.04;
    
    // we use another noise field to add some white points as sources
    float f = max(t,step(noise(vec3(r*55.,iTime*2.)),.1));

    oPixel = vec4(vec3(f),1.);   
}