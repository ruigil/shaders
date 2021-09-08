#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

void main() {
    // reference frame
    vec2 r = ref;

    // float accumulator
    float f = 0.;

    // One way to build fractals is to iterate
    // a transformation and accumulate a value

    // here we have a function exp that serves as the value to accumulate.
    
    // it has the protery of exp(0) = 1 and the negative side 
    // tends to zero without reaching it.

    // we use it to accumulate on the direction of the y axis
    // then we apply a iterative transformation, that rotates the space

    // this allow us to view all the result of all the rotations of the space
    for (float i = .0 ; i < 5. ; i++) {
        // abs to introduce a symmetry of the axis
        r = abs(2.*fract(r)-1.) * 
            // a rotation that varies in time and in the iteration
            rot(radians(90.*sin( (iTime*.2) + i/6.283) ) );

        // accumulate exp in the y axis multipling by a value to modulate
        // the accumulation. If we iterate more, this value must be bigger.
        f += exp(-abs(r.y) * 10. );
    }

    oPixel = vec4(vec3(f),1.);
 }

