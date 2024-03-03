//File: counter_v1.sv
module counter_v1
#(
  parameter W = 4,
  parameter CNT_MAX = 12
)
(
  input logic clk,
  input logic rst, ce,
  output logic [W - 1 : 0] cnt
);
 
  always_ff @(posedge clk) begin
    if (rst) 
      cnt <= '0;
    else if (ce) 
      if (cnt == CNT_MAX)
        cnt <= '0;
      else
        cnt <= cnt + 1;
  end
endmodule
