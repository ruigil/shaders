#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'

// this functions 'folds' space with the symmetries of the Koch Snowflake
// https://en.wikipedia.org/wiki/Koch_snowflake
// it returns a coordinate system kr, where you can draw whatever you like
// 'n' is the number of iterations
vec2 refKochSnowflake(vec2 uv, int n) {
    uv = fold(vec2(abs(uv.x),uv.y),radians(-150.));
    for (int i=0; i<n; i++) 
        uv = fold(vec2(abs(uv.x),uv.y)*1.,radians(-120.));
    return uv;
}


float cap(vec2 r, vec2 size) { return min(rect(r,size),circle(r-vec2(0.,size.y*.5),size.x*.5)); }

const float thickness = .1;
const float length = 1.;

float reprect(vec2 r) {
    vec2 br = vec2(r.x,r.y)*rot(radians(90.));
    return fill(rect(br,vec2(thickness,length) ),true);
}

float branches(vec2 r, int level) {
    //r +=vec2(0.,.25);

    float f = 0.;//fill( cap( r, vec2( thickness, length) ), true);

    //r *= rot(radians(90.));
    //r -= vec2(.0,.5);
    for(int i=1; i<2; i++) {
        r -= vec2(.0,.5);
        r= vec2(r.x,fract(r.y+.5)-.5)*rot(radians(-30.)) ;
        f = max(f,fill( rect(r,vec2(thickness,length)),true));
        f = max(f, reprect(r)  );
        vec2 br = vec2(r.x,r.y);//*rot(radians(90.)); 
        
        //float d1 = fill(rect(br,vec2(2.,1.)),true);
        //br.x = fract(br.x+.5)-.5;
        br *= rot(radians(60.));
        //br += -vec2(.0,.25);

        r = br;
    }

    //br *= rot(radians(90.));
/*
    vec2 br1 = vec2(br.x,br.y ); 
    br1 *= rot(radians(60.));
    float d = 1.;//fill(rect(br1-vec2(.0,.5),vec2(1.5,.5)),true);
    br1 += -vec2(.0,.25);
    //br1.y = fract(br1.y*8.)-.5;

    f = xor(f, fill( rect(br1,vec2(thickness,length*.3)*d  ), true));
*/
/*
    for (float d = 1.; d < 5.; d++) {
        float l = length *.5 / d;

        vec2 br = (r - vec2(.0, d * length*.5/5. ) ) * rot(radians(60.));

        f = xor(f, fill( cap( br, vec2(thickness*.7 , l ) ),true) );
        
        for (float sd = 1.; sd < 6.; sd++) { 
            vec2 bbr = ( vec2(abs(br.x),br.y) - vec2(.0, sd *(l/6.)) ) * rot(radians(60.));
            f = xor(f, fill( cap( bbr ,vec2( thickness*.4 , l / sd) ), true) ); 
        }
    }
*/

    return f;
}

vec2 stripes(vec2 r, float level) {
    
    vec2 rt = r;
    for (float f=0.; f< level; f++) {
        rt = vec2(abs(rt.x), rt.y ) * rot(radians(-60.));
        rt = vec2(rt.x,fract(rt.y + .5)-.5);
        rt *= rot(radians(90.));
    }

    return rt;
}

void main() {
    
    vec2 r = ref*4.;

    // the domain of easing function is [0,1]
    float t = fract(iTime/4.);

    //r = vec2(r.x, abs(r.y));
    vec2 sr = r;//fold(r, radians(180.)) ;
    sr = vec2(sr.x,abs(sr.y));
    sr = fold(sr, radians(120.)) ;
    sr = fold(sr, radians(-120.));
    //sr = vec2(abs(sr.x),sr.y);  
  
    //float f = branches(vec2(sr.x,sr.y),1);
    float f = fill(rect(sr+vec2(0.,4.),vec2(.3,12.)), true);
    float g = 0.;//stroke(rect(r0,vec2(15.,3.)),.05,true);
    float b = 0.;//stroke(rect(r1,vec2(15.,1.)),.05,true);

    //f = stroke(hex(sr-vec2(.0,.6),.3),.1,true);
    vec2 r0 = vec2(abs(r.x),sr.y)*rot(radians(-60.));
    r0 = vec2(r0.x,fract(r0.y)-.5);
    f = max(f,fill(rect(r0,vec2(6.,.25)),true));
    
    vec2 r1 = r0 * rot(radians(90.));    
    r1 = vec2(abs(r1.x),r1.y)*rot(radians(-60.));
    r1 = vec2(r1.x,fract(r1.y)-.5);    
    f = max(f,fill(rect(r1,vec2(7.,.25)),true));
    
    //g += stroke(rect(sr-vec2(.0,.6),vec2(.1)),.05,true);
    //g += stroke( dot(r,vec2(cos(radians(-30.)),sin(radians(-30.)))), .01, true); 
    //g += stroke( dot(r,vec2(cos(radians(-150.)),sin(radians(-150.)))), .01, true); 
    //g += stroke( dot(r,vec2(cos(radians(-90.)),sin(radians(-90.)))), .01, true); 

    //b = fill(rect(r1,vec2(11.,.3)),true);
    g = stroke(tri(-r/5.),.01,true);
    //b *= fill(tri(-r/5.),true);

    oPixel = vec4(vec3(f,g,f),1.);
}


