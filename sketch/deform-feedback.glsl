#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy / iResolution.xy) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

#iChannel0 "self"

void main() {

    // although it looks 3d, there is no such thing here
    // only one line is draw, all the others are ghosts from 
    // previous frames. because we apply an offset to the ghost line
    // and we erase below the new line, it gives the illusion of 3d

    // the size of the reference frame
    float size = 20.;

    // the reference frame is between [-1,1] * size
    vec2 r = ref * size;
    // the texture reference frame is between [0,1] * size
    vec2 t = tex * size;

    // the offset we apply to the ghost line
    vec2 offset = vec2(.2,.07);

    // initialize the output value with the previous frame
    // we offset it and substract 0.03 to make it fade into the distance
    float f = max(texture(iChannel0,(t-offset) / size).r - 0.03,.0); 

    // the reference frame is deformed with a couple of oscillators
    r += vec2(5.0, (sin( r.x + iTime) + sin( .5 *r.x - iTime )) + 4.);    

    // the final value
    f = min(
            1., // is no greater than 1
            (f + // we add the previous value

            (stroke(r.y, .3, true) * // and the new line
            stroke(r.x, size,true))) * // that we clip the borders

            fill(r.y,false) // and below the line
        );

    oPixel = vec4(vec3(f),1.);
}