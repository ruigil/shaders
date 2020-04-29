#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/complex-math.glsl'
#include '../utils/noise.glsl'

float teeth(vec2 r, float n, float a) {
    return stroke(circle(r,.4), .3, .01, true) * fill(rays(r * rot(a), 10.), .01, false);
}

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
    r = vec2(log(r.x) - iTime*.5, r.y );
    r *= scale;

    // we repeat the space
    float s = sign(mod(floor(r.y)+floor(r.x),2.)-.5);
    r = fract(r)-.5;

    float step = 6.283/10.;
    float t = iTime;
    // and draw the pattern
    float f = 
        teeth(r, 10., s*t) +
        teeth(vec2(r.x-1.,r.y), 10.,s*-t+step) +
        teeth(vec2(r.x+1.,r.y), 10.,s*-t+step) +
        teeth(vec2(r.x,r.y-1.), 10.,s*-t+step) +
        teeth(vec2(r.x,r.y+1.), 10.,s*-t+step) +
        stroke(circle(r,.31), .15, .01, true);      

    oPixel = vec4(vec3(f),1.);
}
