//File: barrel_shift_v2.sv
module barrel_shift_v2
#(
  parameter DW = 8, // data width
  parameter SW = $clog2(DW)  // shift width
)
(
  input logic [DW - 1 : 0] a,
  input logic [SW - 1 : 0] n,
  output logic [DW - 1 : 0] y
);
  logic [SW : 0] pack;

  always_comb begin
    pack = DW - n;
    y = { << pack {a}};
  end
endmodule

