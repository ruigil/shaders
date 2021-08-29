#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'

void main() {
    vec2 r = (ref * (3. + sin(iTime))) * rot(radians(sin(iTime*.2)*45.));

    // create tiles and every other tile rotate the pattern 90 degrees
    r = mod(floor(r.x) + floor(r.y) , 2.) == 0. ? 
            fract(r)-.5 : fract(r.yx)-.5;
    
    // the pattern   
    float v = 
        fill( rect( r, vec2(.5,1.1) ), .01,  true) *
        fill( sin((r.x-.707) *60.), .1, true) *
        smoothstep(.0,1.0, abs(r.y)) *

        fill( rect( r, vec2(1.,.6) ), .01, false) +
        fill( rect( r, vec2(1.1,.5) ), .01, true) *
        fill( sin((r.y-.707) *60.), .1, true) *
        smoothstep(1.,.0, abs(r.x));

    oPixel = vec4( vec3(v), 1.0 );
} 