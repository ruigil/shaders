#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float rect(vec2 r, vec2 size) { return max(abs(r.x)-size.x,abs(r.y)-size.y); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }

void main() { 
    // magic trick using rotational symmetry
    vec2 r = abs(ref.y)-.35 < 0. ? ref : ref * rot(radians(45.));
    
    float f = 
        stroke( rect( r, vec2(.5)), .05, 1.)  + 
        stroke( rect( r* rot(radians(45.)), vec2(.5)), .05, 1.) * 
        stroke( rect( r, vec2(.5)), .1, 0.);  

    oPixel = vec4(vec3(f), 1.);
}