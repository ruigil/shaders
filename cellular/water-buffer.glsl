#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy / iResolution.xy) 

#include '../utils/noise.glsl'

#iChannel0 "self"

void main() {

    // the water simulation needs two buffers
    // with the current and the previous state
    // we keep the current state in the x channel
    // and the previous state in the y channel

    // reference frame
    vec2 r = ref;
    // mouse in normalized coordinates
    vec2 m = iMouse.xy/iResolution.xy;
    // an epsilon for finite differences
    vec3 e = vec3(1./iResolution.xy, 0.);
    // texture coordinates
    vec2 t = tex;

    // the new state 
    float v = 0.;

    // i mouse is clicked add to the heighfield
    if (iMouse.z > 0.) {
        v = smoothstep(.05,.0,length(tex-m));
    } else

    // add random rain
    if (hash(33.*t+iTime) < .001) {
        v = smoothstep(.1,.0,length( hash22(t*33.) ))*5.;
    }

    // current state
    v += texture(iChannel0, t + e.xz ).x; // north
    v += texture(iChannel0, t - e.xz ).x; // south
    v += texture(iChannel0, t + e.zy ).x; // east
    v += texture(iChannel0, t - e.zy ).x; // west
    v /= 2.;
    
    // previous state
    v -= texture(iChannel0,t).y;
    v *= .99; // damping

    // we switch the current and the previous state 
    // for the next iteration
    oPixel = vec4(v, texture(iChannel0, t).x, 0. , 0.);   
 } 