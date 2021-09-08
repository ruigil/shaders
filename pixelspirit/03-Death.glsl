#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y)) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

// The first value in the step function can be anything, 
// but it is good practice to define a convention 
// Here we will lock the first value at 0. and we try to define a function on the second parameter
// This way, the step function will show us when the function crosses the zero boundary
// In this case we have the equation of a line  mX - Y + b = 0 so, it will be black below the 
// line and white above.

void main() { 
    float v = step(0., 0.5 * ref.x + ref.y);
    oPixel = vec4( vec3(v), 1. );
}