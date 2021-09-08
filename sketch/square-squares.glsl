#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

void main() {
    // this is a remix of a generative artwork by William J. Kolomyjec
    // http://dada.compart-bremen.de/item/agent/644

    vec2 r = ref*6.;

    // repeat space in both directions
    vec2 r1 = fract(r) - .5;
    // grid coordinates
    vec2 r2 = floor(r) * 36.;

    // draw a white square
    float f = fill(rect(r1, vec2(.8)),true);

    // random number of inner squares
    float ns = 2. + floor(4.* hash(r2));
    for (float s=0.; s < ns; s++) {
        // size of inner squares
        float size = (.1 + (.1*s)) * (.7/(ns*.1));
  
        // center offset of the inner square
        vec2 center = (.35 - size * .5) * vec2(noise(r2+iTime)-.5,noise(r2.yx+iTime)-.5);
  
        // clip a rect inside with the calculated size and offset 
        f *= stroke(rect(r1 - center, vec2( size  )), .03, false);
    }

    // clip a border of the frame
    f *= fill(rect(r, vec2(9.75) ), true);

    oPixel = vec4(vec3(f),1.);
}