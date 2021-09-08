#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

void main() {

    vec2 r = ref;

    // initial translation with noise
    r += vec2( (abs( noise(2. * r.yy)) - .5) *.1, .6);

    float f = 0.; // collect the result

    // for recursivity, just iterate 
    // a serie of transformations of the refrence frame
    // before drawing...
    for (float i = 0.; i < 7.; i++) {

        // add a branch with half y length offset
        f += fill(rect(r - vec2(.0,.3), vec2(.1,.6)), true);
        
        // mirror in x, translate in y and scale
        r = vec2(abs(r.x), r.y - .6) * 1.5;
        
        // rotate the reference frame for the next branch
        r *= rot(radians(35.));
        
        // add a bit of noise to make it wave.
        r -= vec2( noise(2.*r.yy ) * .1 , .0);
        
        // and repeat...
    }

    oPixel = vec4(vec3(f),1.);
}