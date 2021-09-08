#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) ) 
#define mouse ((iMouse.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) ) 
#define tex gl_FragCoord.xy/iResolution.xy 

#include '../utils/noise.glsl'
#include '../utils/2d-utils.glsl'
#iChannel0 "self"

#define size 170.

const vec2 factor = iResolution.x < iResolution.y ? vec2(1.,(iResolution.y/iResolution.x)) : vec2((iResolution.x/iResolution.y),1.); 

vec2 unar(vec2 r) {
    return (r + (factor*.5)) / factor; 
}

// Conway Game of Life is a popular Cellular Automaton
// https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
float life(vec2 r) {

    vec2 current = floor( r*size) + .5; // current cell

    // we have to undo the aspect ratio transformation 'unrar' to index the feedback self texture
    float alive = 1.-texture(iChannel0, fract(unar((current/size))) ).r; // is it alive ?
    float nb = 0.; // neighbours

    // count neighbours...
    for(int i= -1; i <= 1; i += 1) {
        for(int j= -1; j <= 1; j += 1) {
            nb += 1.-texture(iChannel0, fract( unar((current + vec2(i,j) ) / size)) ).r;
        }
    }
    nb -= alive; // do not count self
    
    // rules... 
    // 1) if alive and 2 or 3 neighbors stay alive
    // 2) if dead and exactly three neighbors then born
    // 3) else dead...
    return (bool(alive) && (nb == 2. || nb == 3.)) || (!bool(alive) && nb == 3.) ? 1. : 0.;

}

void main() {
    
    // mouse center
    vec2 mp = vec2(ref-(floor(mouse*size)/size))-vec2(1./(size*2.));

    float l =
    // random cell 
    floor( hash( iTime + floor(ref*size) ) + .5 ) *
    // in a 3x3 square size at the mouse position 
    fill(rect(mp,vec2(3./size)), true) +
    // plus life simulation 
    life(ref);

    oPixel = vec4(vec3(1.-l),1.); 

}