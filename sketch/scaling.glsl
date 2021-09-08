#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'


// accept value between [-1,1]
// returns a scale between double and half
float scale(float d) {
    return min( - 1./ (min(1. + d, 1.5) - 2.), - 1. / (min(1. + d *.5, 1.5) - 2.) );
}

void main() {

    // inspired by Victor Vasarely

    // reference frame
    vec2 r = ref * 7.;

    // the distortion is fake, nothing to do with real perspective
    // we generate a field between [-1,0]
    // and use it to distort the scale of the grid
    r *= scale(-sin(radians((max(1.-length(r*.15),0.))*(90.))));

    // fractional reference frame
    vec2 fr = fract(r) -.5;

    // to generate pattern of 01010101
    float t = floor(mod(floor(r.x)+floor(r.y),2.));
    // a grid
    float f = stroke(rect(fr, vec2(1.)), .05, true );
   
    // use the pattern to choose the shape
    f += bool(t) ? 
          fill(circle(fr,.3 ), .01, sign(r.x*r.y) < 0. ) 
        : fill(rect(fr*rot(iTime),vec2(.4)), .01, true );

    oPixel = vec4(vec3(f),1.);   
}