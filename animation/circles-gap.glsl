#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'
#include '../utils/shaping-functions.glsl'


// using easing functions with noise
void main() {
    
    vec2 r = ref;

    float f = 0.; // result

    for (float i = 0.; i < 4.; i++) { // 4 circles

        float t = fract( iTime / 4. ); // time domain
        float n = noise( vec2(i , floor( (iTime / 4. ) + .5)) ); // noise dependent on time and index

        f = max(f, 
                // the circle with variable radius
                stroke( circle(r, .1 + n * abs(easePow(t, 3., modeInOut) - .5) ), .01, true) *
                // the gaps with variable number of rays and rotation 
                fill( rays( r * rot( sign(n - .5) * easePow(t, 4., modeInOut) * 6.283 * floor(n * 4.)) , 1. + floor(5. * n) ), false)
            );  
    }


    oPixel = vec4(vec3(f),1.);
}