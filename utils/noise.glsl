// random number with a 2d seed
float hash(vec2 p) { return fract(sin(dot(p,vec2(12.9898,78.2333)))*43758.5453123); }

// perlin noise with a 2d seed
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( hash( i + vec2(0.0,0.0) ), hash( i + vec2(1.0,0.0) ), u.x),
                mix( hash( i + vec2(0.0,1.0) ), hash( i + vec2(1.0,1.0) ), u.x), u.y);
}

// fractal noise with a 2d seed
float fbm ( vec2 p ) {
    const mat2 m = mat2(0.8,0.6,-0.6,0.8);
    float f = 0.0;
    f += 0.5000*noise ( p ); p*=m*2.02;
    f += 0.2500*noise ( p ); p*=m*2.04;
    f += 0.1250*noise ( p ); p*=m*2.03;
    f += 0.0650*noise ( p ); p*=m*2.01;

    // normalize f;
    f /= 0.9375;
    return f;
}
