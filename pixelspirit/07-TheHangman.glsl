#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w) { return step( 0., (w *.5) - abs(f) ); }

void main() { 
    // The same line as the last one 06, but we make it symmetric with 'abs'
    vec2 r = abs(ref);
    float f = stroke(1.3 * r.x - r.y, .2);
    oPixel = vec4( vec3(f), 1.);
}