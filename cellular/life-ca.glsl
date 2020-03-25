
#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex gl_FragCoord.xy/iResolution.xy 

#include '../utils/noise.glsl'

#iChannel0 "self"

#define size 200.

// Conway Game of Life is a popular Cellular Automaton
// https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
float life(vec2 r) {
    vec2 current = floor(tex*size) + .5; // current cell
    float alive = texture(iChannel0,current/size).r; // is it alive ?
    float nb = 0.; // neighbours
    
    // count neighbours...
    for(int i= -1; i <= 1; i += 1) {
        for(int j= -1; j <= 1; j += 1) {
            nb += texture(iChannel0, (current + vec2(i,j)) / size ).r;
        }
    }
    nb -= alive; // do not count self
    
    // rules...
    return (bool(alive) && (nb == 2. || nb == 3.)) || (!bool(alive) && nb == 3.) ? 1. : 0.;
}

void main() {

    float l = 
        // every thousand frames reset the board
        mod(float(iFrame),1000.) == 0. ? 
        // initialize with random 0 or 1, 50% chance
        floor( hash(iTime + floor(tex*size)) +.5 ) : life(tex);
    
    oPixel = vec4(vec3(l),1.); 
}