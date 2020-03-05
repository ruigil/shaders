#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/


// Lets create a signed distance function (sdf) for circles
float circle(vec2 center, float radius) { return length(center) - radius; }

// lets create a function that will return 1 or 0 if the sdf is positive or negative. 
// When the parameter 'i' is 1. it will return 1 for the negative part of the sdf, 
// when the parameter 'i' is 0. it will do the inverse. 
float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }

void main() { 
    // first we will fill white circle at the origin with radius .5
    float v = fill(circle(ref, .5), 1.);
    // then we will fill an inverse circle offset from the origin (.1,.1)
    float mask = fill(circle(ref - vec2(.1), .4), 0.);
    // when we multiply both the inverse circle works as a mask
    // because 1. * 0. = 0.
    oPixel = vec4(vec3(v * mask), 1.);
}