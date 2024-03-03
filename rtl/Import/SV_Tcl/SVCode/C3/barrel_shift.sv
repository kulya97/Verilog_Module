//File: barrel_shift.sv
module barrel_shift
#(
  parameter DW = 8, // data width
  parameter SW = 3  // shift width
)
(
  input logic [DW - 1 : 0] a,
  input logic [SW - 1 : 0] n,
  output logic [DW - 1 : 0] y
);

  logic [2 * DW - 2 : 0] apad;
  logic [2 * DW - 2 : 0] shift_out;

  always_comb begin
    apad = {{(DW - 1) {1'b0}}, a};
    shift_out = apad << n;
    y = shift_out[DW - 1 : 0] | {1'b0, shift_out[2 * DW - 2 : DW]};
  end
endmodule


  
