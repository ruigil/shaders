#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float stroke(float f, float w, float i) { return abs(i - smoothstep(0., .01, abs(f) - (w *.5) )); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float rays(vec2 r, float n) { return mod(atan(r.y,r.x),6.283/n)-(3.14/n); }
float poly(vec2 r, float radius, float n) { return length(r) * cos(mod(atan(r.y, r.x) - 1.57, 6.28 / n) - (3.14 / n)) - radius; }

void main() { 
    vec2 r = ref * rot(radians(22.5)); 

    // We just multiply the rays with a mask zo make the inner part of the wheel
    float f = 
        stroke( rays(ref,8.), .1, 1.) * 
        stroke( poly(r,.31,8.), .20, 1.) + 
        stroke( poly(r,.5,8.), .07, 1.) + 
        stroke( poly(r,.15,8.), .02, 1.);

    oPixel = vec4(vec3(f), 1.);
}