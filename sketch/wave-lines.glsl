#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

void main() {

    vec2 r = ref*20.;

    // adding an oscillator to the reference frame
    // two waves with diffrerent frequencies and offsets
    r += vec2(0., sin(r.x + iTime) + sin(.5 * r.x - iTime) );

    float f = 
        // the line is just a rect, repeated in the y
         fill(rect(vec2(r.x, fract(r.y) - .5), vec2(30.,.1)),true) * 
        // clip the top and bottom
        fill(abs(r.y) - 15.,true);

    oPixel = vec4(vec3(f),1.);
}