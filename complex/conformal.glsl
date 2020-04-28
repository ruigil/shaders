#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/complex-math.glsl'
#include '../utils/noise.glsl'


void main() {

    // this shader implements a conformal mapping
    // by using a complex function to map the plane
    vec2 r = ref*2.;

    // we transform the reference frame in polar coordinates
    vec2 z = toPolar(r);
    // a few variables for the animation
    float ct = cos(iTime*.5);
    float st = sin(iTime*.3);
    float scale = 10. / 6.283;

    // the complex transform is a dipole
    // one point is zero and the other inifinite
    r = zdiv( zadd( z, 2. * vec2(ct,st) ), zsub( z, 2.*vec2(st, ct)));

    // we apply a log scale
    r = vec2(log(r.x) - iTime, r.y + st );
    r *= scale;

    // we repeat the space
    r = fract(r)-.5;

    // and draw the pattern
    float f = 
        stroke(scale * circle(r,.3), .1, true) *
        fill(scale * rays(r * rot(-radians(iTime * 60.)), 10.), true) +
        stroke(scale * circle(r,.21), .2, true);      

    oPixel = vec4(vec3(f),1.);
}
