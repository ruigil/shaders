#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

#iChannel0 "self"

void main() {

    vec2 r = ref;
    float n = noise(r.yx - iTime);

    float f = xor(
            // for a never ending feedback the ratio must be smaller
            // than the window, in this case the window = (r * .5) + .5
            // but with a bigger window the negative offsets will wrap and in this case
            // give a look of partial feedback
            texture(iChannel0,(r * .7) + .5).r, 
            fill(circle(r - vec2(n - .5) , .5), true)
        );

    oPixel = vec4(vec3(f),1.);
}