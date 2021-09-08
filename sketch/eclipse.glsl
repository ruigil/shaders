#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'
#include '../utils/complex-math.glsl'

void main() {

    // eclipse shader
    // the corona is built with a deformed circle
    // to have noise stich in a circular way, 
    // we need to sample it in a polar form

    // reference frame
    vec2 r = ref;
 
    // convert to polar coordinates
    vec2 pr = toPolar(r);

    // noise in the angular component
    pr.y +=  noise(r * pr.x + iTime * .1 ) - .5;
    
    // noise in the radial component
    pr.x += noise( toCarte(vec2( 10. + 5. * sin(iTime*.05), pr.y) ) );
    
    float f =
        // the sun 
        xor(stroke(circle(r,.3),.01,  true)*.7,
        // the moon
        fill(circle(r,.29), .01, false) *
        // the corona 
        2.*fill(circle(toCarte(pr), .1), 1., true) * fbm(pr.xy-iTime*.2));

    oPixel = vec4(vec3(f),1.);   
}