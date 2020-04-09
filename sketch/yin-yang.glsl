#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'
#include '../animation/easing-functions.glsl'

void main() {

    vec2 r = ref;

    // pattern 010101
    float p = floor(mod(iTime,2.));
    
    // two alternate time steps
    float t1 = fract(iTime) * p;
    float t2 = fract(iTime) * abs(1.-p);
    
    // two rotation controlled by the timesteps
    vec2 r1 = r * rot(easePow(t1, 2., modeInOut)*6.283*.5); 
    vec2 r2 = r * rot(-easePow(t2, 2., modeInOut)*6.283); 

    // The Yin Yang Symbol
    float f = 
        xor(
            min(fill(r2.x, true) * 
            fill(circle(r2, .5), true) *
            fill(circle(vec2(r2.x,r2.y - .25), .25),false) +
            fill(circle(vec2(r2.x,r2.y + .25), .25),true) +
            stroke(circle(r2, .5), .01, true), 1.),
            fill(circle( vec2(r1.x,abs(r1.y) - .25), .1), true)
        );

    oPixel = vec4(vec3(f),1.);
}