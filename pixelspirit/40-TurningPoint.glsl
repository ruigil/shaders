#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float tri(vec2 r) { return max( dot( vec2(abs(r.x),r.y), vec2(.866,.5)), - r.y ) - .433; }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float flip(float v) { return v == 0. ? 1. : sign(v); }

void main() { 

    // This one is quite magical.. double flip !
    vec2 r = - ref * flip(ref.y);

    float f = 
        stroke(tri((r - vec2(.2, .15)) * 2.), .15, 1.) + 
        stroke(tri( - (r + vec2(.2, .15)) * 2.), .15, 1.) * 
        stroke(tri((r - vec2(.2, .15)) * 2.), .25, 0.);
        
    oPixel = vec4(vec3(f), 1.);
}