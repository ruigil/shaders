#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy / iResolution.xy) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

// Album cover "Unknow Pleasures" from Joy Division 
// https://blogs.scientificamerican.com/sa-visual/pop-culture-pulsar-origin-story-of-joy-division-s-unknown-pleasures-album-cover-video/

#iChannel0 "self"

void main() {

    vec2 r = ref;
    // the texture reference frame is between [0,1] 
    vec2 t = tex ;

    // we apply an offset to the ghost line from the previous
    // frame to make it go up
    float v = max(texture(iChannel0,t-vec2(.0,.01)).r ,.0);

    r += vec2(.0,.75);
    // the pulse is  perlin noise, modulated by a cosine
    float pulse =  .5 * noise( vec2(r.x*20.,iTime*5.)) * max(0.,cos(3.*r.x));
        
    // draw the new horizontal line
    v = min(1., v + stroke(r.y  - pulse,  .01, true));
        
    // clip bellow the line 
    v *= fill(r.y  - pulse , false); 

    // clip above 
    // does not work too well, because it is clipping with the noise  
    // for the current time, and it should calculate a new
    // pulse based on the time offset of the last ghost line
    v *= fill(r.y - 1.5 - pulse , true); 

    // clip borders
    v *= stroke(r.x,1.5, true);

    oPixel = vec4(vec3(v),1.);
}