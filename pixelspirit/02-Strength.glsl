#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y)) 

#define PI 3.14159265359

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/


// You can build a vec3 with a single float, it will copy the value to the 3 channels, x,y,z
// You can also build a vec4 with a vec3 + 1 float and other combinations
// Here we modulate the vertical line on the last example with sin
// because ref.y is between -1,1 multiplied by PI it becomes -PI,PI
// scaled by .2 and added to the ref.x the vertical line becomes wavy...
// try swaping the coordinates and change the scale factor.

void main() {
    float v = step(0., ref.x + .2 * sin(ref.y * PI));
    oPixel = vec4(vec3(v), 1.);
}