#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/hash.glsl'


void main() {

    vec2 r = ref;

    // the size of the maze
    float grid = 30.;
    
    // here we use the function sign 
    // that returns 1 or -1 of a random function. 
    // this will give us flipped reference frame 
    // in the x axis with 50% probability 
    vec2 m = fract(grid * vec2( signz(hash12(floor(grid * r)) - .5) * r.x,  r.y ));

    // draw a diagonal line
    float v = stroke(m.x - m.y, .1, .1, true);

    // clip borders
    v *= fill( rect(r,vec2(1.6)) , true);

    oPixel = vec4(vec3(v),1.);
}