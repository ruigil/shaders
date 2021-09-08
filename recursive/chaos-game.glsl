#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy/iResolution.xy)

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

#iChannel0 "self"

void main() {

    // this is a demonstration of drawing a sierpinsky triangle, with
    // a random algorithm
    
    // the algorithm consist in choosing a random vertice of the triangle
    // and then walk half the distance between the last point and the 
    // new vertice to get the new point, and iterate.

    // this shader uses the texture feedback to accumulate a drawing
    // but also, uses a texture position as a memory to keep the value
    // of the last point between frames

    // reference frame
    vec2 r = ref;
    // number of vertices
    float v = 3.;
    // the address in the texture that is used for memory.
    vec2 mem = vec2(.5/iResolution.xy);
    // the result
    vec4 result = vec4(0.);

    // so if the texture address is the one that we reserved for memory, 
    // we calculate a new position and store it in the result
    if (tex == mem)   {

        // get the last point from memory
        vec2 lp = texture(iChannel0,mem).rg;
        
        // get a random number btween 0 and the number of vertices-1
        float rd = floor(hash(vec2(iTime+2.)) * v); 
        
        // use it to get a vector between tha last point and the new vertice
        vec2 nv = vec2(cos(rd*(6.283/v)),sin(rd*(6.283/v))) - lp.xy;
        
        // walk half the distance to get the new point
        vec2 np = lp.xy + (normalize(nv) * (length(nv)*.5));
        
        // store the new point in the memory
        result = vec4(np ,0.,.0);

    // .. or else we draw a new point
    } else {
        // get the point from the memory
        vec2 p = texture(iChannel0,mem).rg;
        
        // draw a circle at the point position
        // and accumulate with the last texture frame
        float f  = max(
                    fill(circle(r - p, .005), true),
                    texture(iChannel0, tex).r
                );

        result = vec4(vec3(f),1.);
    }

    oPixel = result;
}