#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float tri(vec2 r) { return max( dot( vec2(abs(r.x),r.y), vec2(.866,.5)), - r.y ) - .433; }
float circle(vec2 r, float radius) { return length(r) - radius; }


void main() { 
    vec2 r = ref;

    // to make a heart, start from a circle, and deform the space in the
    // y axis with a symmetric parabola on the x axis
    float f = 
        fill( circle( vec2( r.x, r.y  - .9 * abs(r.x) + .5 * abs(r.x*r.x) ), .5), 1.) * 
        stroke( tri( r*4. - vec2(.0,.4)), .1, .0);
        
    oPixel = vec4(vec3(f), 1.);
}