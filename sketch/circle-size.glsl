#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'

void main() {

    vec2 r = ref*7.;

    // repeat space in both directions
    vec2 r1 = fract(r) - .5;
 
    // time speed
    float t = .2* iTime * 6.283;
    // big circle center
    vec2 c = r + 3. * vec2(cos(t), sin(t*2.));
    // calculate the radius of circles, based on the distance
    // from the big circle 
    float radius = .4 - (length(c)*.05);

    float f = 
        // draw a square
        fill(rect(r1, vec2(.8)),true) *
        // clip a circle inside with the calculated size 
        fill(circle(r1 , radius ), false) *
        // clip a border of the frame
        fill(rect(r, vec2(9.75) ), true);

    oPixel = vec4(vec3(f),1.);
}