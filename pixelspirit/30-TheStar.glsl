
#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float tri(vec2 r) { return max( dot( vec2(abs(r.x),r.y), vec2(.866,.5)), - r.y ) - .433; }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }

// we build a six-point star with two equilateral triangles
float star6(vec2 r) { return min(tri(r),tri(-r)); }

void main() { 

    vec2 r = ref;
    
    float f = 
        // the rays are a fractional part of the angle
        (stroke( mod( atan(r.y, r.x), 6.283/8.) - (3.14/8.), .1, 1.) +
        fill( star6(r), 1.)) * 
        stroke( star6( (r * 2.4) * rot( radians(30.) )), .08,.0) *
        stroke( star6(r), .04, .0) *
        stroke( star6(r * 1.2), .03, .0);

    oPixel = vec4(vec3(f), 1.);
}