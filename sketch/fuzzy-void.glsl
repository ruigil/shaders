#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'
#include '../utils/complex-math.glsl'



void main() {

    // convert to polar
    vec2 r = toPolar(ref); 

    // add two oscilators on the radial coordinate
    
    vec2 ra = r + vec2(r.x + .1 * (sin(r.y * 2. + iTime) + sin(r.y * 1. - iTime) ),0.);
    vec2 rg = r + vec2(r.x + .1 * (sin(r.y * 5. + iTime) + sin(r.y * 3. - iTime) ),0.);
    vec2 rb = r + vec2(r.x + .1 * (sin(r.y * 3. + iTime) + sin(r.y * 5. - iTime) ),0.);

    
    float red = fill(circle(toCarte(ra), 1.), .1, true);
    float green = fill(circle(toCarte(rg), 1.), .1, true);
    float blue = fill(circle(toCarte(rb), 1.), .1, true);

    oPixel = vec4(red,green,blue,1.);
}