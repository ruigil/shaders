#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }

// A sdf for a triangle, by taking the max of 3 lines.
// two symmetrical lines in the x axis, and one for the base in the y axis. 
// sin(60 dg) = 0.866 cos(60 dg) = .5 
float tri(vec2 r) { return max(abs(r.x) + .5 * r.y - .433, - r.y - .433 ); }

void main() { 
    vec2 r = ref;
    
    // because shapes are defined in a normalized reference frame -1,1
    // to scale their size we multiply or divide the reference frame.
    float f = fill(tri(-r), 1.) * fill(tri(r * 2.), .0); 
              
    oPixel = vec4(vec3(f), 1.);
}
