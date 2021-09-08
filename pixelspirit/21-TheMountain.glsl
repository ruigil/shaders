#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float rect(vec2 r, vec2 size) { return max(abs(r.x) - size.x, abs(r.y) - size.y); }

void main() { 

    // we make the new reference frame symmetric around the x axis 
    // and rotate it 45 degrees...
    vec2 r = vec2(abs(ref.x),ref.y) * rot(radians(45.));
    
    float f = 
        fill(rect(r, vec2(.5)), 1.) +
        // ...this allow us to have two squares for the price of one :)
        fill(rect(r - vec2(.4), vec2(.3)), 1.) *
        stroke(rect(r, vec2(.5)), .07, .0);
         

    oPixel = vec4(vec3(f), 1.);
}