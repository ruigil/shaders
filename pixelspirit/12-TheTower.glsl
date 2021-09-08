#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }

float rect(vec2 r, vec2 size) { return max(abs(r.x) - size.x, abs(r.y) - size.y); }

// this function will work like and exclusive or 'xor' boolean operation
// it will return 1. when both are different and 0. if they are the same.
float xor(float f1, float f2) { return abs(f1 - f2); }

void main() { 

    float f = 
        xor( fill(rect(ref,vec2(.2,.5)),1.),  stroke( ref.x + .8 * ref.y, .05 , 1.));
    oPixel = vec4(vec3(f), 1.);
}