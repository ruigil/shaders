#define oPixel gl_FragColor
#define ref ((gl_FragCoord.xy - iResolution.xy *.5) / ( iResolution.x < iResolution.y ? iResolution.x : iResolution.y) * 2.) 

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., 0.01, f)); }
float tri(vec2 r) { return max( dot( vec2(abs(r.x),r.y), vec2(.866,.5)), - r.y ) - .433; }

// this is a 2Dimension rotation matrix.
// when we multiply a 2d point vec2 by this, it will rotate 'a' radians 
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }

void main() { 

    // because our sdf shapes are defined in a normalised reference frame -1,1
    // we transform them, by transform the reference frame
    // here we rotate it by 30 degrees
    vec2 r = ref * rot(radians(30.));

    float f = 
        fill(tri(r), 1.) *
        // we use the second triangle as a mask, that we translate 
        // and scale with different values in the x and y axis.  
        fill(tri((r + vec2(0.,.3)) * vec2(1.,3.)), 0.);
        
    oPixel = vec4(vec3(f), 1.);
}