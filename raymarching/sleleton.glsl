#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/3d-utils.glsl'
#include '../utils/noise.glsl'

// the green
float greens(vec3 p) {
    return sphere(p - vec3(0.7,0.,.0), .3);
}

// the red
float reds(vec3 p) {
    return sphere(p - vec3(0.,0.,.0), .3);
}

// the blue
float blues(vec3 p) {
    return sphere(p - vec3(-0.7,0.,.0), .3);
}

float floorplane(vec3 p) {
    return plane(p + vec3(.0,.5,.0));
}

// the scene with a big bounding sphere 
float scene(vec3 p) {
    return min(min(floorplane(p),min(min(greens(p),reds(p)),blues(p))),-sphere(p,5.) );
}

// trace a ray into the scene, return the hit point, and the distance
vec4 trace(Ray ray) {
    float t , d = 0.;

    // initialize the point that is going to march along the ray
    vec3 p = ray.ori;
    for (int i=0; i< 100; i++) {
        // calculate the actual distance
        d = scene( p );
        // if we hit something break, the loop
        if (abs(d) < .001) break;
        // march along the ray 
         p = ray.ori + ray.dir * (t += d);
    }
    
    // return the hit point and total distance
    return vec4(p,t);
}

// sampling the distance field, to get differences in the 3 axis,  
// and then normalize, will give a normal vector
vec3 getNormal(in vec3 p) {
	const vec2 e = vec2(.001, 0);
	return normalize(vec3( scene(p + e.xyy) - scene(p - e.xyy), scene(p + e.yxy) - scene(p - e.yxy), scene(p + e.yyx) - scene(p - e.yyx)));
}

vec3 newray() {
    float a = hash(iTime) * 6.283;
    float z = (hash(iTime*3.)*2.) - 1.;
    float r = sqrt(1. - z*z);
    return vec3(r*cos(a), r*sin(a), z);
}

// defining materials
Material material(Ray ray, vec4 hit) {
    float e = .001;
    vec3 normal = getNormal(hit.xyz);
    Material m = Material(vec3(0.), normal, false, normal);

    m.albedo = mix(vec3(1.,1.,.0),vec3(0.4,0.3,1.), hit.y);

    if (floorplane(hit.xyz) < e) {
        hit *= 5.;
        float x = mod(floor(hit.y)+floor(hit.x)+floor(hit.z), 2.);
        m.albedo = vec3(1.) * floor(x);
        m.scatter = false;
    }

    if (reds(hit.xyz) < e) {
        m.albedo = vec3(1.,.2,.2) ;
        m.scatter = true;
        m.scattered = normalize(reflect(ray.dir,normal));
    }

    if (greens(hit.xyz) < e) {
        m.albedo = vec3(0.2,1.0,.2);
        m.scatter = false;
    }

    if (blues(hit.xyz) < e) {
        m.albedo = vec3(0.2,.2,1.0);
        m.scatter = false;
    }

    return m;

}

// using materials to apply a ligh model
vec3 shade(Ray ray, int depth) {
    vec3 color = vec3(1.0);


    // light position;
    vec3 lp = vec3(1.0, 1.0, -2.0);
       // light intensity
    vec3 li = vec3(.5); 


    for (int i=0; i<depth; i++) {

        vec4 hit = trace(ray);
        // material
        Material m = material(ray, hit);

        // light direction
        //vec3 ld = normalize(lp - hit.xyz);
        
        // diffuse component is dot product between light direction and normal
        //float diff = max( dot( ld, m.normal), 0. );
        // specular component is dot product bewtween light reflected and view direction
        //float spec = max( dot( normalize( reflect(-ld, m.normal ) ), normalize(ray.ori - hit.xyz) ), 0.);

        // ambient color + light intensity * ( diffuse color * diffuse light + specular color * specular light)
        // color += m.ambient + li * ( (m.diffuse * diff) + (m.specular * pow( spec ,m.alpha) ) );

        color *= m.albedo;
        if (!m.scatter) break;
        ray = Ray(ray.ori + ray.dir * (hit.w*.99), m.scattered);
    }

    return color; 
}

vec3 antialias(vec2 r) {
    float ct = cos(iTime);
    float st = sin(iTime);

    vec3 eye =  vec3(ct, .5,-1.) * 2.;
    vec2 e = vec2(1./iResolution);
    vec3 color = vec3(0.);
    float fov = radians(70.);
 
    Ray ray = Ray(eye, setCamera(ref, eye, vec3(0.), fov  ));
    color += shade(ray,2);

    //ray = Ray(eye , setCamera(ref - e.xy, eye, vec3(0.), fov  ));
    //color += shade(ray,1);

    //ray = Ray(eye , setCamera(ref + e.xy, eye, vec3(0.), fov  ));
    //color += shade(ray,1);

    return color;
}

void main() {

    // we trace the ray, and shade the hit point to the eye
    vec3 color = antialias(ref); 

    // gamma color correction
    oPixel = vec4( gamma(color,1.2) ,1.);   
}