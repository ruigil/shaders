#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'



float lineseg(vec2 r, vec2 a, vec2 b) {
    vec2 ra = r-a, ba = b-a;
    float h = clamp( dot(ra,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( ra - ba*h );
}

void main() {
    vec2 r = ref*6.;

    float f = 0.;//
    
    
    for (float i=0.; i<=10. ; i++) {
        f += stroke(lineseg(r,vec2(5,-5.+i),vec2(5.-i,5.)),.05,true);
        f += stroke(lineseg(r,vec2(-5,i-5.),vec2(-5.+i,5.)),.05,true);
        f += stroke(lineseg(r,vec2(5.-i,-5.),vec2(-5.,-5.+i)),.05,true);
        f += stroke(lineseg(r,vec2(-5.+i,-5.),vec2(5.,-5.+i)),.05,true);
    }
    
    oPixel = vec4(vec3(f),1.);
}
