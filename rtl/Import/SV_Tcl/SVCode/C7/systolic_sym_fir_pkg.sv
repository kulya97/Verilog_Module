//File: systolic_sym_fir_pkg.sv
package systolic_sym_fir_pkg;
  
  localparam TAP    = 8;  // length of FIR
  localparam HTAP   = TAP / 2;  
  localparam XIN_W  = 16; // width of x(n)
  localparam COE_W  = 16; // width of h(n)
  localparam ACC_W  = 48; // width of accumulator
  localparam YOUT_W = 26; // width of y(n)
  localparam SRL_STYLE_VAL = "reg_srl_reg";
  typedef logic signed [COE_W - 1 : 0] coe_t;
  const coe_t COE [HTAP] = '{7, 14, -138, 129};

endpackage: systolic_sym_fir_pkg
