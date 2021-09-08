#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y)) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

// The 'abs' returns the absolute number, wich means that it will always return a positive number.
// so .1 - abs(ref.x) will always be negative except when ref.x is lesser than .1
// because ref.x is 0 on the center of the screen, it will return a vertical line with .2 thickness .1 * 2 sides of the zero boundary 

void main() { 
    float v = step( 0., .1 - abs(ref.x) );
    oPixel = vec4( vec3(v), 1. );
}
