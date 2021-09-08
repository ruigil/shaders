
#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define mouse ((iMouse.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex gl_FragCoord.xy/iResolution.xy 

#include '../utils/noise.glsl'
#include '../utils/2d-utils.glsl'
#iChannel0 "self"

//#iChannel0::MinFilter "NearestMipMapNearest"
#iChannel0::MagFilter "Nearest"
#iChannel0::WrapMode "Repeat"

#define size 100.

// Conway Game of Life is a popular Cellular Automaton
// https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
float rule110(vec2 r) {
    vec2 current = floor(tex*size) + .5; // current cell
    float alive = 1.-texture(iChannel0,current/size).r; // is it alive ?
    float nb = 0.; // neighbours
    
    // count neighbours...
    for(int i= -1; i <= 1; i += 1) {
        for(int j= -1; j <= 1; j += 1) {
            nb += 1.-texture(iChannel0, (current + vec2(i,j)) / size ).r;
        }
    }
    nb -= alive; // do not count self
    
    // rules...(
    return (bool(alive) && (nb == 2. || nb == 3.)) || (!bool(alive) && nb == 3.) ? 1. : 0.;
}


void main() {
    vec2 current = floor(tex*size); // current cell
    float r110 = texture(iChannel0,current /size ).r;

    vec2 coord = floor(tex*size);

    if (coord.y == 0.) {
        if (iFrame == 1) {
            r110 = floor( hash(iTime + floor(tex*size)) +.5);
        } else {
            r110 = texture(iChannel0, (current + vec2(0,.5)) / size ).r;
        }
    }


    
    oPixel = vec4(vec3(r110),1.); 
}