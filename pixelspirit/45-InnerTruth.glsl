#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float circle(vec2 r, float radius) { return length(r) - radius; }

void main() { 

    // There is always many ways to model the final result
    // Here we just take the spiral, and modulate it with a cos
    // and use it as a mask on a circle
     vec2 r = ref;

    float l = length(r * 3.);
    float a = atan(r.y,r.x); 

    float f = 
        fill( circle(r,.67 ), 1.) *
        stroke( cos( (l - a) * 5.) , 1.5, .0) * 
        stroke( cos( (l + a) * 5.) , 1.5, 0.0);
        
    oPixel = vec4(vec3(f), 1.);
}