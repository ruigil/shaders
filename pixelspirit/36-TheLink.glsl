#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float rect(vec2 r, vec2 size) { return max(abs(r.x)-size.x,abs(r.y)-size.y); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float flip(float v) { return v == 0. ? 1. : sign(v); }

void main() { 

    // a vertical flip on the horizontal axis
    vec2 r = vec2(ref.x, ref.y * flip(ref.x) ) * rot(radians(-45.));

    float f = 
        stroke( rect( r - vec2(.18), vec2(.3)), .1, 1.) * 
        stroke( rect( r + vec2(.18), vec2(.3)), .2, 0.) + 
        stroke( rect( r + vec2(.18), vec2(.3)), .1, 1.) +
        // we build little diamonds by scaling non uniformly the x and y component of a square
        fill( rect( (abs(ref) - vec2(.0,.95)) * vec2(1.,.5) * rot(radians(45.)), vec2(.02)), 1.);
        
    oPixel = vec4(vec3(f), 1.);
}