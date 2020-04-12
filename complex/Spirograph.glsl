// licence: https://creativecommons.org/licenses/by/4.0/
// link: https://www.shadertoy.com/view/ltjczK

/*
When you graph a real function y=f(x) you need a plane (2D). When you 
graph a complex function w=f(z), to see the relationship between 
the input complex plane (2D) and the output complex plane (2D), you need 4D. 
Because humans are not able to see in 4D one technique to visualize 
these functions is to use color hue, and saturation as the two extra 
dimensions. This technique is called domain coloring. 
https://en.wikipedia.org/wiki/Domain_coloring

In case you know nothing about complex numbers, or need a refresher
this youtube serie is very good !
https://www.youtube.com/watch?v=T647CGsuOVU
*/

#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/complex-math.glsl'
#include '../utils/2d-utils.glsl'

#define nf 2
// Question: Is it possible to take the Fourier series parametric curve
// and build an algorithm that obtain the value of the curve in an
// generic implicit form ? f(x,y) = 0 ? 
// the problem is how to derive an implicit polynomial from a parametric curve
// https://www.hindawi.com/journals/mpe/2009/327457/
// https://www.cs.cmu.edu/~hulya/Publications/ICIP02Paper.pdf
// this is a hard problem, an this function is not a solution 
float fsdf(vec2 r, vec3[nf] f) {
    vec2 c = vec2(0., .0);
    float a = atan(r.y,r.x);
    for (int i=0; i<f.length(); i++) {
        c +=  f[i].x*vec2(cos(a*f[i].y),sin(a*f[i].y));
    }
    return length(r)-length(c);
}

void main() {
    
    vec2 r = ref;

    // we model a fourier series as an array of vec3
    // x = amplitude, y = frequency, z = phase;
    vec3 fos[nf] = vec3[nf](
        vec3(.5, 1.,.0),
        vec3(.25, 2.,.0)
    );

    // trying to visualize a fourier series in a implicit form
    float fs = stroke(fsdf(r,fos), .01, true);


    // render a visualization of the parametric fourier series curve
    // in the time domain 
    float t = iTime* (6.238/10.);
    float f = stroke(circle(r,fos[0].x), .01, true);
    vec2 c = r;
    for (int i=0; i<nf; i++) {
        c -= fos[i].x * vec2(cos(t * fos[i].y),sin(t * fos[i].y));
        float radius = i == fos.length()-1 ? .02 : fos[i+1].x;
        f = max(f,stroke(circle(c,radius), .01, true));
    }

    oPixel = vec4(vec3(fs,.0,f),1.);
}