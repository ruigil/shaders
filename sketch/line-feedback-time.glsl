#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy / iResolution.xy) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

#iChannel0 "self"

void main() {

    // this is the same that line feedback
    // but we repeat the pattern in time, using time
    // as a vertical coordinate

    // the size of the reference frame
    float size = 20.;

    // the reference frame is between [-1,1] * size
    vec2 r = ref * size;

    float tt = mod(floor(iTime*60.), 30.);

    // initialize the output value with the previous frame
    float f = texture(iChannel0, tex).r; 

    // the reference frame is deformed with noise
    r +=  vec2(.0, tt - 15. + noise( vec2(tt + r.x*3., tt )) );

    // the final value
    f = min(
            1., // is no greater than 1
            (f + // we add the previous value

            (stroke(r.y, .05, true) * // and the new line
            stroke(r.x, 30.,true))) // that we clip the borders
        );

    oPixel = vec4(vec3(f),1.);
}