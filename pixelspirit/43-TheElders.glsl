#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
float circle(vec2 r, float radius) { return length(r) - radius; }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }

vec2 moda(vec2 r, float n) {
    float angle = atan(r.y,r.x);
    return r * rot( mod(angle, 6.283 / n) - angle);
}

void main() { 

    // same technique as the last one, adding just a small tilt
    vec2 r = moda(ref* rot(radians(30.)),3.);

    float f = 
        stroke( circle( r + vec2(-.16,.3), .5), .08, 1.) + 
        stroke( circle( r + vec2(.34,.01), .5), .08, 1.) *
        stroke( circle( r + vec2(-.16,.3), .5), .16, 0.); 
        
    oPixel = vec4(vec3(f), 1.);
}