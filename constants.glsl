#define UV (gl_FragCoord.xy/u_resolution.xy)
#define PIXEL_SIZE (1./u_resolution)
#define EPS (1./ (u_resolution.x < u_resolution.y ? u_resolution.x : u_resolution.y ))

#define PI 3.1415926536
#define TAU 6.2831853072
