#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float circle(vec2 center, float radius) { return length(center) - radius; }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }

vec2 moda(vec2 r, float n) { 
    float angle = atan(r.y,r.x); 
    return r * rot( mod(angle, 6.283 / n) - angle); 
}

// to model a star5, we use a symmetric line around the vertical axis
// with 36 * 2. degrees and replicate the domain in the circle with 'moda' 5. times.
float star5(vec2 r) {
    r = moda(r * rot(radians(-54.)), 5. ) * rot(radians(54.));
    return (abs(r.x) * .951) + (0.309 * r.y) - .475;
}

void main() { 
    vec2 r = -ref;

    float s = star5(r * 2.);
    
    float f = 
        stroke(circle(r,.85), .04, 1.) *
        stroke(s, .5, 0.) + 
        stroke(s, .08, 1.);

    oPixel = vec4(vec3(f), 1.);
}