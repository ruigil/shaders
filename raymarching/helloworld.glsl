#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/3d-utils.glsl'

// the center box
float boxhole(vec3 p) {
    return max(box(p, vec3(.5)), -sphere(p,.33) );
}

// the three moving spheres
float runsphere(vec3 p) {
    return min(min(sphere(p - vec3(sin(iTime+1.),.0,.0), .2), sphere(p - vec3(.0,sin(iTime+2.),.0), .2)), sphere(p - vec3(.0,.0,sin(iTime)), .2));
}

// the scene with a big bounding sphere 
float scene(vec3 p) {
    return min(min( boxhole(p) , runsphere(p)), -sphere(p,4.));
}

// trace a ray into the scene, return the hit point
vec3 trace(vec3 ro, vec3 rd) {
    float t , d = 0.;

    for (int i=0; i< 100; i++) {
        d = scene( ro + rd * t );
        if (abs(d) < .001) break; 
        t += d;
    }
    return ro + rd * t;
}

// sampling the distance field, to get differences in the 3 axis,  
// and then normalize, will give a normal vector
vec3 getNormal(in vec3 p) {
	const vec2 e = vec2(.001, 0);
	return normalize(vec3( scene(p + e.xyy) - scene(p - e.xyy), scene(p + e.yxy) - scene(p - e.yxy), scene(p + e.yyx) - scene(p - e.yyx)));
}

// defining materials
Material material(vec3 hit) {
    float e = .001;
    Material m = Material(vec3(0.4,.1,.0), vec3(0.6,.4,.0), vec3(1.), 1.);

    if (boxhole(hit) < e) {
        float x = mod(floor(hit.y)+floor(hit.x)+floor(hit.z), 2.);
        m.diffuse = vec3(1.) * floor(x);
        m.ambient = m.diffuse * .5;        
    }

    if (runsphere(hit) < e) {
        m.diffuse = vec3(.1,.4,.6);
        m.ambient = m.diffuse * .5;
        m.alpha = 10.;
    }

    return m;

}

// using materials to apply a ligh model
vec3 shade(vec3 eye, vec3 hit) {

    vec3 normal = getNormal(hit.xyz);

    Material m = material(hit);

    // light position;
    vec3 lp = vec3(.0, .0, -2.0);
       // light intensity
    vec3 li = vec3(.5); 
    // light direction
    vec3 ld = normalize(lp - hit);
    
    // diffuse component is dot product between light direction and normal
    float diff = max( dot( ld, normal), 0. );
    // specular component is dot product bewtween light reflected and view direction
    float spec = max( dot( normalize( reflect(-ld, normal ) ), normalize(eye - hit) ), 0.);

    // ambient color + light intensity * ( diffuse color * diffuse light + specular color * specular light)
    return m.ambient + li * ( (m.diffuse * diff) + (m.specular * pow( spec ,m.alpha) ) );

}

void main() {

    float ct = cos(iTime);
    float st = sin(iTime);

    vec3 eye =  vec3(ct, 0., st) * 1.5; 
    vec3 ray = setCamera(ref, eye, vec3(0.), radians(90.)  );

    vec3 color = shade(eye, trace(eye, ray) );

    oPixel = vec4( gamma(color,1.2) ,1.);   
}