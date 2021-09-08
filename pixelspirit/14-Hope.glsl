#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float circle(vec2 center, float radius) { return length(center) - radius; }
float xor(float f1, float f2) { return abs(f1 - f2); }

void main() { 
    vec2 r = ref;
    
    // first trick is to use 'abs(r)' to give us a symmetric merge of the circle in the origin 
    // second is that a simple line '.7 * r.x + r.y' can be seen as sdf too ! 
    // dividing the plane into positive and negative space. 
    float f = 
        xor(fill(circle(abs(r) + vec2(.25,.0), .5), 1.), fill(.7 * r.x + r.y, 1.));
              
    oPixel = vec4(vec3(f), 1.);
}