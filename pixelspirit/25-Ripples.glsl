#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float rect(vec2 r, vec2 size) { return max(abs(r.x) - size.x, abs(r.y) - size.y); }

void main() { 

    vec2 r = ref * rot(radians(45.));
    
    float f = 0.;
    // here we use a traditional for loop for the 4 squares.    
    for (float o = -.3; o<=.3; o += .2) {
        f = max(f,stroke(rect(r + o, vec2(.4)), .05, 1.));
    }
    
    oPixel = vec4(vec3(f), 1.);
}