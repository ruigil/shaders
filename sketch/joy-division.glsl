#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

// Album cover "Unknow Pleasures" from Joy Division 
// https://blogs.scientificamerican.com/sa-visual/pop-culture-pulsar-origin-story-of-joy-division-s-unknown-pleasures-album-cover-video/

void main() {

    vec2 r = ref;

    // acumulator value
    float v = 0.;

    // number of lines - 50
    for(float f = -.5; f < .5; f += .02) {
        // the pulse is  perlin noise, modulated by a cosine
        float pulse =  .5 * noise(iTime + 100. * f - r.xx*8.) * max(0.,cos(3.*r.x));
        
        // draw the horizontal line
        v += fill(r.y + f - pulse,  .02, true);
        
        // clip bellow the line 
        v *= fill(r.y + f - pulse , false); 
    }    

    // clip borders
    v *= fill(abs(r.x)-.8, true);

    oPixel = vec4(vec3(v),1.);
}