#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w) { return step( 0., (w *.5) - abs(f) ); }

void main() { 
    // The equation of a line and a stroke, the same that in 03 and 04
    float f = stroke( 1.3 * ref.x -  ref.y, .2);
    oPixel = vec4( vec3(f), 1. );
}