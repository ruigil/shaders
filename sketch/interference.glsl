#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'

void main() {

    vec2 r = ref*40.;

    // time speed
    float t = .01 * iTime * 6.238;

    // one oscilator
    vec2 c = r + 30. * vec2(cos(t*3.), sin(t*2.));

    // add sin waves from the oscilator and one at the center
    float f = clamp( sin(length(c)) + sin(length(r)) , 0., 1. );

    oPixel = vec4(vec3(f),1.);
}