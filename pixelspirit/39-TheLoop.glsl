#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float rect(vec2 r, vec2 size) { return max(abs(r.x)-size.x,abs(r.y)-size.y); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float flip(float v) { return v == 0. ? 1. : sign(v); }

void main() { 


    // the trick was to draw one version on the left another on the right, and flip the sign on the x axis to mix them
    // remove the flip(ref.y) to see the original

    vec2 r = vec2(ref.x*flip(ref.y),ref.y) * rot(radians(45.));
    

    float f = 
        stroke(rect(r, vec2(.4)), .05, 1.) *  
        stroke(rect(r - vec2(.3), vec2(.25)), .08, .0) + 
        stroke(rect(r - vec2(.3), vec2(.25)), .05, 1.) *
        stroke(rect(r - vec2(.6), vec2(.05)), .08, 0.) +
        stroke(rect(r - vec2(.6), vec2(.05)), .05, 1.) + 
        stroke(rect(r + vec2(.3), vec2(.25)), .05, 1.) *
        stroke(rect(r, vec2(.4)), .08, .0) + 
        stroke(rect(r + vec2(.6), vec2(.05)), .05, 1.) *
        stroke(rect(r + vec2(.3), vec2(.25)), .08, 0.); 

    oPixel = vec4(vec3(f), 1.);
}