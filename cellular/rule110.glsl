#define oPixel gl_FragColor

#include '../utils/noise.glsl'
#include '../utils/2d-utils.glsl'
#iChannel0 "self"

#define size 170.

// Rule 110 is a Turing-complete cellular automata 
// https://en.wikipedia.org/wiki/Rule_110
float rule110(vec2 r) {
    vec2 current = floor(r*size) +.5; // current cell

    int result = 0;
    // if it is the first frame or mouse down, randomize the line
    if ((iFrame <= 1) || (iMouse.z>0.)){
        result = int(floor( hash( floor(iTime) + current) + .5));
    } else {
        // get the previous state from the texture
        int l0 = int( texture (iChannel0, fract(  (current + vec2(1.,-1.)) / size) ) );
        int l1 = int( texture (iChannel0, fract(  (current + vec2(0.,-1.)) / size) ) );
        int l2 = int( texture (iChannel0, fract(  (current + vec2(-1.,-1.)) / size) ) );

        // the rule number is ...
        // l2 * 2^2 + l1 * 2^1 + l0 * 2^0
        int rule = (l2 << 2) + (l1 << 1) + l0;
        

        // The ruleset
        // https://en.wikipedia.org/wiki/Rule_110#/media/File:One-d-cellular-automaton-rule-110.gif
        result = 
            rule == 7 ? 0 :
            rule == 6 ? 1 :
            rule == 5 ? 1 :
            rule == 4 ? 0 :
            rule == 3 ? 1 :
            rule == 2 ? 1 :
            rule == 1 ? 1 :
            0;
    }

    return float(result);
}


void main() {
    vec2 ref = gl_FragCoord.xy/iResolution.xy;
    // the offset is to slide the texture down, by the size of the square   
    float offset = floor(iResolution.y/size) / iResolution.y;

    // if it is the first line, apply the rule110 
    // or else slide the texture the offset
    float r110 = (ref.y >= 1.-(1./size)) ?
        rule110(ref) :
        texture(iChannel0, ref+vec2(0.,offset)).r;  

    // output the calculated value
    oPixel = vec4(vec3(r110),1.); 
}