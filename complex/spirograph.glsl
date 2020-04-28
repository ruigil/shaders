#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy/iResolution.xy)

#include '../utils/complex-math.glsl'
#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

#iChannel0 "self"

void main() {
    
    vec2 r = ref*2.5;

    int n = 5;

    // the fourier serie of oscilators
    // we model a fourier series as an array of vec3
    // x = amplitude, y = frequency, z = phase;
    // by selecting the proper coefficients we can draw anything
    vec3 fos[6] = vec3[6](
        vec3(.2, -11.,3.),
        vec3(.5, -7.,.0),
        vec3(.9, -1.,2.0),
        vec3(.4, 1.,.0),
        vec3(.3, 7.,1.),
        vec3(.1, 11.,.0)
    );
    
    // frame feedback
    float f = texture(iChannel0, tex ).r; 

    float t = iTime/6.238;

    // calculate the parametric curve
    for (int i=0; i<fos.length(); i++) 
        r +=  toCarte( vec2( fos[i].x, fos[i].z + t * fos[i].y ) );

    // draw a point
    f += fill(circle(r,.01), true);

    oPixel = vec4(vec3(f),1.);
}