#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float tri(vec2 r) { return max( dot( vec2(abs(r.x),r.y), vec2(.866,.5)), - r.y ) - .433; }
float diamond(vec2 r) { return tri(vec2(r.x, abs(r.y))); }

void main() { 

    vec2 r = ref;

    float f = 
        fill(tri(r), 1.) *
        fill(diamond((r - vec2(0.,.2)) * 1.6), 0.);
        
    oPixel = vec4(vec3(f), 1.);
}