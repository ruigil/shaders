#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float tri(vec2 r) { return max(abs(r.x) + 0.5 * r.y - .433, - r.y - .433 ); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }

// function composition and symmetry allow us to create a diamond by making
// a symmetric copy of the triangle on the y axis
float diamond(vec2 r) { return tri(vec2(r.x, abs(r.y))); }

void main() { 

    vec2 r = ref;

    float f = 
        stroke(diamond(r), .01, 1.) +
        stroke(diamond(r * 1.15), 0.02, 1.) +
        fill(diamond(r * 1.35), 1.);
        
    oPixel = vec4(vec3(f), 1.);
}