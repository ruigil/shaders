#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float rect(vec2 r, vec2 size) { return max(abs(r.x) - size.x, abs(r.y) - size.y); }
float xor(float f1, float f2) { return abs(f1-f2); }

void main() { 

    vec2 r = ref * rot(radians(45.));

    float f = 
        xor(
            fill(rect((r - vec2(0.1)), vec2(.5)), 1.),
            fill(rect((r + vec2(0.1)), vec2(.5)), 1.)
        );
        
    oPixel = vec4(vec3(f), 1.);
}