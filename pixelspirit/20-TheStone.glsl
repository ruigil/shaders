#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float rect(vec2 r, vec2 size) { return max(abs(r.x) - size.x, abs(r.y) - size.y); }

void main() { 

    vec2 r = ref * rot(radians(45.));
    
    float f = 
        fill(rect(r, vec2(.5)), 1.) *
        // here we take me min of the tow axis r.x and r.y (union)
        // we can see that tey are rotated 45 degrees
        stroke(min(abs(r.x), abs(r.y)), 0.05, 0.);
        
    oPixel = vec4(vec3(f), 1.);
}