#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/shaping-functions.glsl'


void main() {


    // shaping functions are useful functions 
    // usually on the domain [0,1]
    // that allow us to shape behaviour or form
    // in a controlled way.

    // they are a kind of toolbox, you use to get 
    // the results you want

    // the functions are in the lib included above
    // this shader only graphs them

    // these functions are from Inigo Quilez
    // http://www.iquilezles.org/www/articles/functions/functions.htm


    vec2 r = (ref*2.5);
    
    r.y -= .5;
   
    // an id for the grid cells
    float id = floor(r.x + 2.) + 4. * floor(r.y + 2.);
   
    // the cells for the function graphs
    vec2 g = fract(r)-.2;

    // initialize the axis
    vec3 color = vec3((stroke(g.x, .01, true) + stroke(g.y, .01, true)) *.4);

    // make it fit the cell
    g *= 1.5;

    // the functions...
    // please see the link above for an explanation
    if (id == 0.) {
        color.xz += stroke(g.y-almostIdentity(g.x,.1,.1), .03, true);
    }

    if (id == 1.) {
        color.xy += stroke(g.y-almostIdentity(g.x), .03, true);
    }

    if (id == 2.) {
        color.yz += stroke(g.y-almostIdentity(g.x,.01), .03, true);
    }

    if (id == 3.) {
        color.x += stroke(g.y-expImpulse(g.x,5.), .03, true);
        color.y += stroke(g.y-expImpulse(g.x,3.), .03, true);
        color.z += stroke(g.y-expImpulse(g.x,1.5), .03, true);
    }

    if (id == 4.) {
        color.x += stroke(g.y-expSustainedImpulse(g.x, 1., 5.), .03, true);
        color.y += stroke(g.y-expSustainedImpulse(g.x,.5, 3.), .03, true);
        color.z += stroke(g.y-expSustainedImpulse(g.x,.8, 1.5), .03, true);
    }

    if (id == 5.) { // ???
        float x = clamp(g.x,.0,1.);
        color.x += stroke(g.y-quaImpulse(x, 5.2), .03, true);
        color.y += stroke(g.y-quaImpulse(x, 3.5), .03, true);
        color.z += stroke(g.y-quaImpulse(x, 2.), .03, true);
    }

    if (id == 6.) {
        color.xyz += stroke(g.y-cubicPulse(.0,.4, g.x-.5), .03, true);
    }

    if (id == 7.) {
        float x = clamp(g.x,.0,1.);
        color.x += stroke(g.y-expStep(x,6.,4.), .03, true);
        color.y += stroke(g.y-expStep(x,16.,4.), .03, true);
        color.z += stroke(g.y-expStep(x,69.,4.), .03, true);
    }

    if (id == 8.) {
        float x = clamp(g.x,.0,1.);
        color.x += stroke(g.y-gain(x,2.), .03, true);
        color.y += stroke(g.y-gain(x,4.), .03, true);
        color.z += stroke(g.y-gain(x,8.), .03, true);
    }

    if (id == 9.) {
        color.x += stroke(g.y-parabola(g.x,1.), .05, true);
        color.y += stroke(g.y-parabola(g.x,2.), .05, true);
        color.z += stroke(g.y-parabola(g.x,4.), .05, true);
    }

    if (id == 10.) {
        float x = clamp(g.x,.0,1.);
        color.x += stroke(g.y-pcurve(x,1.,.3), .03, true);
        color.y += stroke(g.y-pcurve(x,1.,2.), .03, true);
        color.z += stroke(g.y-pcurve(x,.3,3.), .03, true);
    }

    if (id == 11.) {
        float x = clamp(g.x,.0,1.);
        color.x += stroke(g.y-sinc(x,8.), .08, true);
        color.y += stroke(g.y-sinc(x,5.), .05, true);
        color.z += stroke(g.y-sinc(x,4.), .1, true);
    }

    // visualize the grid
    color *= stroke(rect(fract(r)-.5,vec2(1.)), .15 , .01, false);
    color += stroke(rect(fract(r)-.5,vec2(1.)),.01,true);
    color *= fill(rect(r+vec2(.0,.5),vec2(4.025,3.025)),true);

    oPixel = vec4(color,1.);
}  