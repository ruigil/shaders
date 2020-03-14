#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/


void main() { 

    vec2 r = ref;

    // a logaritmic spiral
    float f = smoothstep(.0,.01, sin( atan(-r.y,r.x) - 1.618 * log( length(r) )) );
        
    oPixel = vec4(vec3(f), 1.);
}