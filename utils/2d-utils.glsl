
// defines a sdf for a circle
float circle(vec2 r, float radius) { return length(r) - radius; }

// defines a equilateral triangle sdf
float tri(vec2 r) { return max( dot( vec2(abs(r.x),r.y), vec2(.866,.5)), - r.y ) - .433; }

// sdf for a rectangle, with size
float rect(vec2 r, vec2 size) { return max(abs(r.x) - size.x * .5, abs(r.y) - size.y * .5); }

// sdf that defines an hexagon shape
float hex(vec2 r, float radius) { return max(abs(r.y), dot(abs(r),vec2(0.866,.5)) ) - radius; }

// generic 'n' side polygon, contained in the circle of radius
float poly(vec2 r, float radius, float n) {  return length(r) * cos(mod(atan(r.y, r.x) - 1.57, 6.28 / n) - (3.14 / n)) - radius; }

// define a angular pattern of rays around the reference frame. 
float rays(vec2 r, float n) { return mod(atan(r.y,r.x), 6.283 / n ) - (3.14 / n); }

// 2d rotation matrix
mat2 rot(float a) { float c = cos(a); float s = sin(a); return mat2(c,-s,s,c); }

// returns the reference frame in modular polar form, with a start angle
vec2 modpolar(vec2 r, float n, float start) { float angle = atan(r.y,r.x) - start; return r * rot( mod(angle, 6.283 / n) - angle); }

// a 'fold' is a kind of generic abs(). 
// it reflects half of the plane in the other half
// the variable 'a' represents the angle of an axis going through the origin
// so in normalized coordinates uv [-1,1] 
// fold(uv,radians(0.)) == abs(uv.y) and fold(uv,radians(90.)) == abs(uv.x) 
vec2 fold(vec2 r, float a) { a -= 1.57; vec2 axis = vec2(cos(a),sin(a)); return r-(2.*min(dot(r,axis),.0)*axis); }

// flips the sign of the variable, remove the zero condition that is interpreted as 1.
float signz(float v) { return v == 0. ? 1. : sign(v); }

// taken 1 or 0 returns 1 if both are different
float xor(float f1, float f2) { return abs(f1-f2); }

// smoothstep antialias with fwidth
float ssaa(float v) { return smoothstep(-1. ,1. ,v / fwidth(v) ); }

// stroke an sdf 'd', with a width 'w', and a fill 'f' 
float stroke(float d, float w, bool f) {  return abs(ssaa(abs(d)-w*.5) - float(f)); }

// fills an sdf 'd', and a fill 'f'. false for the fill means inverse 
float fill(float d, bool f) { return abs(ssaa(d) - float(f)); }

// linear oscilator, gives a triangle wave with v period 1. 
float losc(float v) { return 2.* (abs(floor(mod(v*2.,2.)) - fract(v*2.)) -.5 ); }