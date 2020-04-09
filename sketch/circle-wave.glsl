#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'

void main() {

    vec2 r = ref*7.;

    // repeat space in both directions
    vec2 r1 = fract(r) - .5;
    // get the integer or the coordinate to differentiate the squares
    vec2 r2 = floor(r) * 36.;
    
    // make a rotation with an offset that depends
    // on the y and y component of the square 
    vec2 r3 = r1 * rot(radians(r2.x + r2.y + iTime * 180.));

    float f = 
        // draw a square
        fill(rect(r1, vec2(.8)),true) *
        // clip a circle inside with the calculated rotation 
        fill(circle(r3 - vec2(.0,.1), .2), false) *
        // clip a border of the frame
        fill(rect(r, vec2(9.75) ), true);

    oPixel = vec4(vec3(f),1.);
}