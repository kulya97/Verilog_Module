//File: systolic_fir_pkg.sv
package systolic_fir_pkg;

    localparam TAP    = 4;  // length of FIR
    localparam XIN_W  = 16; // width of x(n)
    localparam COE_W  = 16; // width of h(n)
    localparam ACC_W  = 48; // width of accumulator
    localparam YOUT_W = 25; // width of y(n)
    typedef logic signed [COE_W - 1 : 0] coe_t;
    const coe_t COE [TAP] = '{7, 14, -138, 129};

endpackage: systolic_fir_pkg
