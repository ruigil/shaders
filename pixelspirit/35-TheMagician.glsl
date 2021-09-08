#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float circle(vec2 r, float radius) { return length(r) - radius; }

void main() { 

    // this is the magic, a horizontal flip modulated by the sign of the vertical axis
    // the sign function return 1,-1 or 0 to represent the sign of the variable.
    vec2 r = vec2(ref.x * (ref.y == 0. ? 1. : sign(ref.y)), ref.y);

    float f = 
        stroke( circle( r - vec2(.4,.0), .5), .05, 1.) * 
        stroke( circle( r + vec2(.4,.0), .5), .1, 0.) + 
        stroke( circle( r + vec2(.4,.0), .5), .05, 1.);
        
    oPixel = vec4(vec3(f), 1.);
}