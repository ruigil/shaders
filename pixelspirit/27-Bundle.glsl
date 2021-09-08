#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }

// sdf that defines an hexagon shape
// we could use the generic 'poly' of the last one, but this one is more efficient 
float hex(vec2 r, float radius) { return max(abs(r.y), dot(abs(r),vec2(0.866,.5)) ) - radius; }

// this function creates a radial symmetry with 'n' sides.
// the builtin function mod(n) remaps the number line between 0..n
// this one does the same with angles and points
vec2 moda(vec2 r, float n) { 
    float angle = atan(r.y,r.x); 
    return r * rot( mod(angle, 6.283 / n) - angle); 
}

void main() { 
    // these rotations is just because our definition of an hexagon is flat top up, 
    // and not pointy side up
    vec2 r = moda(ref * rot(radians(-30.)), 3.) * rot(radians(60.));
  
    // because of the radial symmetry, we only need to draw one interior hexagon
    // it will be replicated 3 times.
    float f = stroke(hex(r, .5), .07, 1.) + fill(hex(r + vec2(.12, -.2), .15), 1.);

    oPixel = vec4(vec3(f), 1.);
}
