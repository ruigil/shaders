#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

// We changed 'step' to 'smoothstep' on the stroke function.
// it does the same, but with a 'soft' transition between 0 and 1
// that we can control with the 2 first parameters.
// This allow us to remove the aliasing of curved shapes.
float stroke(float f, float w) { return smoothstep( 0., .01, (w *.5) - abs(f) ); }

void main() { 
    // We use the function 'length' that calculate a distance.
    // Behind the scenes length uses formula sqrt ( x*x + y*y )
    // It will calculate a distance to the origin of 'ref' (the center of the screen).
    // We remove .4, so the distance will be -.4 at the origin, and will grow to infinity 
    // the farter the pixel is from the origin the greater distance.
    // because our function 'stroke' works at the zero boundary, 
    // it will draw a circle with radius .4

    // These kind of functions are called 'Signed Distance Functions' because it is a 
    // function that for every pixel it will return a distance that is signed.
    // in this case, it is negative inside the circle and positive outside and 
    // zero at the boundary
    float v = stroke(length(ref) - .4, .05);


    oPixel = vec4( vec3(v), 1.);
}