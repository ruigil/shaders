#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/3d-utils.glsl'

// a grid in a log-spherical mapping transform of the coordinates.
// from : https://www.osar.fr/notes/logspherical/
float grid(vec3 p) {
    float l = length(p);
    float scale = 6./3.1415;
    p = vec3(log(l), acos(p.z/length(p)), atan(p.y,p.x));
    p *= scale;
    p = fract(p+.5)-.5;
      
    vec3 size = vec3(1.);
    return (l/scale)*max(box(p, size ), max(max(-box(p.yyz, size ),-box(p.xxy, size ) ), -box(p.xxz, size ) )-.05 );
}

// the scene with a bounding sphere 
float scene(vec3 p) {
    return min(grid(p) ,-sphere(p,3.) );
}

// trace a ray into the scene, return the hit point
vec3 trace(vec3 ro, vec3 rd) {
    float t , d = 0.;
    
    // initialize the point along the ray
    vec3 p = ro;
    for (int i=0; i< 70; i++) {
        // get the scene distance
        d = scene( p );
        // if we hit anything break the loop
        if (abs(d) < .001) break; 
        // march along the ray the distance found
        p = ro + rd * (t += d);
    }

    // return the hit point
    return p;
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
    vec3 normal = getNormal(hit);

    Material m = Material(vec3(0.1), vec3(.2), vec3(0.), 1., normal);

    if (grid(hit) < e) {
        m.diffuse = vec3(1.);
        m.ambient = m.diffuse * .5; 
        m.specular = vec3(1.0);
        m.alpha = 3.0;  
    }

    return m;

}

// using materials to apply a ligh model
vec3 shade(vec3 eye, vec3 hit) {

    Material m = material(hit);

    // light position;
    vec3 lp = vec3(.0, .0, -2.0);
       // light intensity
    vec3 li = vec3(.5); 
    // light direction
    vec3 ld = normalize(lp - hit);
    
    // diffuse component is dot product between light direction and normal
    float diff = max( dot( ld, m.normal), 0. );
    // specular component is dot product bewtween light reflected and view direction
    float spec = max( dot( normalize( reflect(-ld, m.normal ) ), normalize(eye - hit) ), 0.);

    // ambient color + light intensity * ( diffuse color * diffuse light + specular color * specular light)
    return m.ambient + li * ( (m.diffuse * diff) + (m.specular * pow( spec ,m.alpha) ) );

}

void main() {

    float ct = cos(iTime*.1);
    float st = sin(iTime*.1);

    vec3 eye =  vec3(ct, 0.5, st) * 1.5; 
    vec3 ray = setCamera(ref, eye, vec3(0.), radians(90.)  );

    vec3 color = shade(eye, trace(eye, ray) );

    oPixel = vec4( gamma(color,1.2) ,1.);   
}