//File: demux_1to4.sv
module demux_1to4
#(
  parameter W = 8
)
(
  input logic [1 : 0] sel,
  input logic [W - 1 : 0] din,
  output logic [W - 1 : 0] y0, y1, y2, y3
);

  always_comb begin
    if (sel == 3) y3 = din; else y3 = '0;
    if (sel == 2) y2 = din; else y2 = '0;
    if (sel == 1) y1 = din; else y1 = '0;
    if (sel == 0) y0 = din; else y0 = '0;
  end
endmodule
