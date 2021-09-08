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

    // This result is not exactly the same, that the one in the PixelSpirit Deck...
    // In the deck that I have, the solution uses a 'for loop' that breaks the radial symmetry
    // 'for loops' are not recommended in shaders, because shaders are executed for every pixel.
    // if your loop has 12 steps, you're going to repeat those steps for every pixel !
    // This solution has only one step and keeps the radial symmetry.
    // This means it is 12 times more efficient !
    vec2 r = moda(ref,12.);

    float f = 
        stroke( circle( r + vec2(-.39,.35), .5), .03, 1.) * 
        stroke( circle( r - vec2(.16,.5), .5), .06, 0.) + 
        stroke( circle( r - vec2(.16,.5), .5), .03, 1.);
        
    oPixel = vec4(vec3(f), 1.);
}