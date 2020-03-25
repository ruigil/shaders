
const int modeIn = 0;
const int modeOut = 1;
const int modeInOut = 2;

// an easing function that uses exponential 
// input 't' must be in domain [0,1]
// input 'p' is the power, quadratic, cubic, etc..
// input 'mode' accept 3 modes of operation, defined const above
// return value is between [0,1]
float easePow(float t,float p, int mode) {
    float m = mode == modeInOut ? floor(mod(t*2.,2.)) : float(mode);
    float f = mode == modeInOut ? 2. : 1.;

    return abs( m - pow( abs(m - t) * f, p) / f );
}
