#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'

void main() {
    vec2 r = ref;

    // there is no real 3d in this sketch !
    // only a perspective transform

    // this translation simulates 
    // the rotation on a x axis in 3d
    r -= vec2(.0, .5*sin(iTime) );

    // this 2d rotation simulates 
    // a rotation in z axis in 3d
    r *= rot(radians(10. * sin(iTime * .5)));

    // the perspective transform
    vec2 pr = vec2(r.x * abs(1./r.y), abs(1./r.y)  );

    // this 2d rotation simulates 
    // the rotation on the y axis in 3d
    pr *= rot(radians(30.*sin(iTime * .5)));

    // simulates forward motion
    pr.y += iTime;

    float v = 
        // the tiles
        stroke( rect( fract(pr)-.5, vec2(.5) ), .3, true) *
        // hide the horizon
        smoothstep(.1, 1., abs(r.y) );

    oPixel = vec4( vec3(v), 1.0 );
} 