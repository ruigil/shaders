#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float tri(vec2 r) { return max(abs(r.x) + 0.5 * r.y - .433, - r.y - .433 ); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }

float poly(vec2 r, float radius, float n) { 
    return length(r) * cos(mod(atan(r.y, r.x) - 1.57, 6.28 / n) - (3.14 / n)) - radius;
}

vec2 moda(vec2 r, float n) {
    float angle = atan(r.y,r.x);
    return r * rot( mod(angle, 6.283 / n) - angle);
}

void main() { 
    
    vec2 r = ref * rot(radians(22.5));
    
    vec2 p = moda(r * 2., 8.) * rot(radians(67.5)) - vec2(.0,.6);
    vec2 p1 = moda(r *2. * rot(radians(22.5)),8.) * rot(radians(67.5)) - vec2(.0,.333);

    float f = max(fill(tri(p), 1.), fill(tri(p1), 1.));
    
    for (float i=0.; i<8.; i++) {
        f *= stroke(tri(ref * 2.2 * rot(radians(90. + (i*(360./8.)))) - vec2(.0,.8)), .05, .0);
    }
    
    f *= stroke(poly(r, .1, 8.), .02, .0);    
    
    oPixel = vec4(vec3(f), 1.);
}

