#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float tri(vec2 r) { return max(abs(r.x) + 0.5 * r.y - .433, - r.y - .433 ); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float circle(vec2 center, float radius) { return length(center) - radius; }

void main() { 

    vec2 r = ref;

    // to model this, we choose to define a triangle, 
    // and then using to create a fill 
    // and a stroke that we use as a mask for the circle
    // remember we apply mask by multiplying 1. * 0. = 0.
    float triangle = tri(r *2. + vec2(0.,.433)); 
    
    float f = 
        fill(triangle, 1.) +
        stroke(triangle, .1, .0) *
        stroke(circle(r - vec2(0., .2), .3), .05, 1.);
        
    oPixel = vec4(vec3(f), 1.);
}