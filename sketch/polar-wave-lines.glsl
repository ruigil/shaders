#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'
#include '../complex/complex-math.glsl'


void main() {

    // convert to polar
    vec2 r = toPolar(ref*20.);

    // add two oscilators on the radial coordinate
    r += vec2(r.x * (sin(r.y * 3. + iTime) *.2 + sin(r.y * 7. - iTime) *.2),0.);

    float f = 
        // repeat on the radial axis and convert to cartesian
        stroke(circle(toCarte(vec2(fract(r.x), r.y)), .5), .1, true) *
        // clip boundary
        fill(circle(toCarte(r), 10.), true);

    oPixel = vec4(vec3(f),1.);
}