#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy / iResolution.xy) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

#iChannel0 "self"

void main() {

    // reference frame
    vec2 r = ref * 2.;

    vec2 e = vec2(1.) / iResolution.xy;

    vec2 t = tex;
    float v = 0.;
    bool page = mod(float(iFrame),2.) == 0.;

    for (float x = t.x-e.x; x<=t.x+e.x; x += e.x ) {
       for (float y = t.y-e.y; y<=t.y+e.y; y += e.y ) {
           if ((x == t.x) && (y == t.y)) continue;
           v += page ? texture(iChannel0,vec2(x,y)).x : texture(iChannel0,vec2(x,y)).y;
       }
    }

    float c = page ? texture(iChannel0,t).x : texture(iChannel0,t).y;
    float cx = page ? texture(iChannel0,t+vec2(e.x,.0)).x : texture(iChannel0,t+vec2(e.x,0.)).y;
    float cy = page ? texture(iChannel0,t+vec2(0.,e.y)).x : texture(iChannel0,t+vec2(0.,e.y)).y;

    v /= 4.;
    v -= page ? texture(iChannel0,t).y : texture(iChannel0,t).x;

    v -= (v/4.); // damping

    v += mod(float(iFrame),100.) == 0. ? smoothstep(.6,.4,length(r)) : 0.; 

    float nn = fbm(r + vec2(c-cx,c-cy)*3. );
    vec2 res = vec2(v,c);

    oPixel = vec4(vec3( c,v, nn), 1.);   

    oPixel = vec4(vec3(v),1.);
 } 