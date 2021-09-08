#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 
#define tex (gl_FragCoord.xy / iResolution.xy) 

#include '../utils/noise.glsl'

#iChannel0 "water-buffer.glsl"

void main() {

    // this effect is an old one, but very rewarding to code
    // for a detailed explanation use this link
    // https://web.archive.org/web/20160116150939/http://freespace.virgin.net/hugo.elias/graphics/x_water.htm

    // the water-buffer shader is the actual water simulation
    // this one is just to render the simulation with some light
    // and texture

    // Try playing with your mouse !

    // reference frame   
    vec2 r = ref;
    // epsilon for differences
    vec3 e = vec3(1./iResolution.xy, 0.);

    // get the current values for the heighmap of the water simulation
    // get the also the differences to normal and water distortion
    float t = texture(iChannel0,tex).x;
    float tx = texture(iChannel0,tex + e.xz).x; // north
    float ty = texture(iChannel0,tex + e.zy).x; // east
    vec2 offset = vec2(t-tx,t-ty);

    // get a normal with the differences
    vec3 normal = normalize(vec3(offset, 1. ));
  
    // use the normal to calculate a phong  light model
    // the hit point is the actual coordinate on the plane at z = 0
    vec3 pos = vec3(r,.0);
    // noisy light position;
    float n = 3.14*noise(vec2(iTime*.1)); 
    // light direction light pos - position
    vec3 ld = normalize(vec3(cos(n),sin(n*2.),.5) - pos); 
    // view direction eye - pos
    vec3 vd = normalize(vec3(0.,0.,1.) - pos); 

    // the light reflected for specular component
    vec3 re = normalize( reflect(-ld, normal ) );
 
    // we apply the offset of the heighmap to  
    // the texture to simulate a water distortion 
    float nn = fbm( r + offset + sin(r.x*4.) + sin(r.y*4.));

    // color is ambient + light intensity * ( diffuse * light diffuse + specular * light specular )
    vec3 color = nn*.05 + vec3(.5) * ( nn * max(dot(ld,normal),0. ) + pow( max( dot(re,vd) ,0.) ,32.) );

    // gamma correction
    oPixel = vec4(pow(color,vec3(1./2.2)), 1.); 
 } 