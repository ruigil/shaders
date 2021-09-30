// these kernels are meant to be used in convolutions across a 2d grid
// some are meant to be used in image processing, other are useful in simulations
// like the laplace operator
#define K_EMBOSS float[9](-2., -1., 0., -1., 1., 1., 0., 1., 2.)
#define K_GAUSSIAN_BLUR float[9](0.0625, 0.125, 0.0625, 0.125, 0.25, 0.125, 0.0625, 0.125, 0.0625)
#define K_BOX_BLUR float[9](0.1111, 0.1111, 0.1111, 0.1111, 0.1111, 0.1111, 0.1111, 0.1111, 0.1111)
#define K_SHARPEN float[9](0., -1., 0., -1., 5., -1., 0., -1., 0.)
#define K_EDGE float[9](-1., -1., -1., -1., 8., -1., -1., -1., -1.)

// 9 point stencil laplace operator
#define K_LAPLACE9 float[9](.25, .5, .25, .5, -3., .5, .25, .5, .25)
// 5 point stencil laplace operator
#define K_LAPLACE5 float[9](.0, 1., .0, 1., -4., 1., 0., 1., 0.)
