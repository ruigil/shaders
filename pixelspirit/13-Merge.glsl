#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float circle(vec2 center, float radius) { return length(center) - radius; }
float xor(float f1, float f2) { return abs(f1 - f2); }

void main() { 
    vec2 r = ref;

    float f = 
        xor(fill(circle(r - vec2(.3,.0), .5), 1.), stroke(circle(r + vec2(.3,.0),.5), .04, 1.));
    oPixel = vec4(vec3(f), 1.);
}