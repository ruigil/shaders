#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y)) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/


// GLSL (Graphics Library Shading Language) is a simple language, with few functions and types
// Here we declare a variable of type float called 'v' that is the result of calling the 
// step function. The step function accepts two numbers, and returns 0. or 1. depending on who is the biggest
// step(a,b) = if a <= b return 1. else return 0; 
// because we use the same value for all 3 channel Red, Green and Blue, we get black or white.
// 'ref' is of type vec2, and it is meant to be a reference frame with the coord (0,0) in the middle of 
// the screen  going from -1. to 1. with positive numbers up and to the right, and corrected aspect ratio.
// when ref.x goes from the negative side and crosses 0, to the positive side
// the step function goes from 0 to 1 and the pixel from black to white.
// try changing 0. in the step function to a value between -1.0 and 1.0

void main() {
    float v = step(0.,ref.x);
    oPixel = vec4(vec3(v),1.);
}