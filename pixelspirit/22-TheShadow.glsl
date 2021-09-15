#version 300 es
precision highp float;

uniform vec2 u_resolution;

#define ref ((gl_FragCoord.xy - u_resolution.xy *.5) / ( u_resolution.x < u_resolution.y ? u_resolution.x : u_resolution.y)) 
#define EPS (1./ (u_resolution.x < u_resolution.y ? u_resolution.x : u_resolution.y ))

// From Pixel Spirit Deck
// https://pixelspiritdeck.com/

float fill(float f, float i) { return  abs(i - smoothstep(0., EPS, f)); }
float stroke(float f, float w, float i) { return abs(i - smoothstep(0., EPS, abs(f) - (w *.5) )); }
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }
float rect(vec2 r, vec2 size) { return max(abs(r.x) - size.x, abs(r.y) - size.y); }

out vec4 pixel;
void main() { 

    vec2 r = ref * 2. * rot(radians(45.));

    float f = 
        stroke(rect(r, vec2(.5)), .02, 1.) +
        fill(rect(r, vec2(.5)), .0) *
        fill(rect((r - vec2(.1,-.1)), vec2(.5)), 1.);

    pixel = vec4(vec3(f), 1.);
}