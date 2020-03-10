#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/
float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float rays(vec2 r, float n) { return mod(atan(r.y,r.x),6.283/n)-(3.14/n); }
float circle(vec2 r, float radius) { return length(r) - radius; }

void main() { 

    vec2 r = ref;

    // the sdf for the eye
    float eye = circle( vec2(r.x, abs(r.y) +.43), .65);
    
    float f = 
        fill( circle( vec2( abs(r.x) + .5, r.y), 1.), 1.) * 
        stroke( rays(r, 70.), .001, 1.) *
        fill(eye, 0.) + 
        stroke(eye, .02, 1.) +
        stroke( circle(r - vec2(0., .05), .22), .02, 1.) * 
        fill(eye, 1.);

    oPixel = vec4(vec3(f), 1.);
}