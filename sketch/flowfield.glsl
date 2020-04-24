#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

void main() {

    // a flow field is a space where each point is interpreted as a
    // direction, or vector. This means that particles or objects
    // in the flowfield will move acordingly to the local values of
    // the field

    // here a flowfield is contructed interpreting the value noise
    // between [0,1] to be an angle for the direction

    vec2 r = ref*10.;

    vec2 nr = r;

    // the grid resolution of the flowfield
    vec2 fl = floor(r); 
    vec2 fr = fract(r) - .5;

    // drawing the grid
    float f = stroke(rect(fr, vec2(1.)), .05, true);
    // value noise
    float n = noise(vec3(fl/5.,iTime)); 

    // painting the square
    f += n;  

    // the value is interpreted as an angle
    fr *= rot(radians( n * 360.));
    
    // draw the arrow
    f += stroke(fr.y,.1,true) * stroke(fr.x,.5,true) + fill(circle(fr+vec2(.25,.0),.1),true);


    oPixel = vec4(vec3(f),1.);   
}