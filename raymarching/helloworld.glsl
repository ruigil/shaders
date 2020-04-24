#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

#include '../utils/2d-utils.glsl'
#include '../utils/noise.glsl'

#define FAR 30.


float sphere(vec3 p, float radius) {
    return length(p) - radius;
}

float plane(vec3 p) {
    return p.y;
}

float box(vec3 p, vec3 size) {
    vec3 d = abs(p) - size * .5;
    return min( max(d.x, max(d.y,d.z)), 0. ) + length(max(d , 0.));
}

float boxhole(vec3 p) {
    return max(box(p, vec3(.5)), -sphere(p,.33) );
}

float runsphere(vec3 p) {
    return min(min(sphere(p - vec3(sin(iTime+1.),.0,.0), .2), sphere(p - vec3(.0,sin(iTime+2.),.0), .2)), sphere(p - vec3(.0,.0,sin(iTime)), .2));
}

float map(vec3 p) {
    return min(min( boxhole(p) , runsphere(p)), -sphere(p,3.));
}

struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float alpha;
};

Material material(vec3 hit) {
    float e = .001;
    Material m = Material(vec3(0.3,.1,.0), vec3(.5,.2,.0), vec3(1.), 10.);

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

vec3 trace(vec3 ro, vec3 rd) {
    float t , d = 0.;

    for (int i=0; i< 100; i++) {
        d = map( ro + rd * t );
        if ((abs(d) < .001) || (t>FAR)) break; 
        t += d;
    }
    return ro + rd * t;
}

// sampling the distance field, to get differences in the 3 axis,  
// and then normalize, will give a normal vector
vec3 getNormal(in vec3 p) {
	const vec2 e = vec2(.001, 0);
	return normalize(vec3( map(p + e.xyy) - map(p - e.xyy), map(p + e.yxy) - map(p - e.yxy), map(p + e.yyx) - map(p - e.yyx)));
}

vec3 render(vec3 eye, vec3 hit) {

    vec3 a = vec3(.1);
    vec3 d = vec3(1.);
    vec3 s = vec3(.3);
    float alpha = 10.;
    vec3 normal = getNormal(hit.xyz);

    Material m = material(hit);

    
    // light position;
    vec3 lp = vec3(.0, .0, -3.0);
       // light intensity
    vec3 li = vec3(.5); 
    // light direction
    vec3 ld = normalize(lp - hit);
    // view direction
    vec3 vd = normalize(eye - hit);
    // light reflected
    vec3 re = normalize( reflect(-ld, normal ) );
    // ambient color + light intensity * ( diffuse color * diffuse light + specular color * specular light)
    return m.ambient + li * ( (m.diffuse * max(dot(ld,normal),0. )) + (m.specular * pow( max( dot(re,vd) ,0.) ,m.alpha) ) );

}

vec3 gamma(vec3 color, float p) { return pow(color,vec3(p)); }

mat3 rot3(vec3 angle) {
    vec3 ca = cos(angle);
    vec3 sa = sin(angle);
    return mat3(
        ca.x*ca.y, sa.x*sa.y, -sa.y, 
        ca.y*sa.y*sa.z-sa.x*ca.z, sa.x*sa.y*sa.z+ca.x*ca.z, ca.y*sa.z,
        ca.x*sa.y*ca.z+sa.x*sa.z, sa.x*sa.y*ca.z-ca.x*sa.z, ca.y*ca.z);
}

vec3 setCamera(vec2 screen, vec3 eye, vec3 lookAt, float fov) {
    vec3 up = vec3(0.,1.,0.);
    vec3 fw = normalize(lookAt - eye);
	vec3 rg = normalize( cross(fw, up) );
	up = cross(rg, fw);   
    vec3 ray = normalize(vec3(screen * tan(fov/2.), 1.)); 

    return ray * mat3(rg, up, fw); 
}

void main() {

    //mat3 rot = rot3(vec3(radians(20.),0.,0.));
    float ct = cos(iTime);
    float st = sin(iTime);
    vec3 eye =  vec3(.0, ct, st) * 1.5; 
    vec3 ray = setCamera(ref, eye, vec3(0.), radians(90.)  );

    vec3 color = render(eye, trace(eye, ray) );

    oPixel = vec4( gamma(color,1.2) ,1.);   
}