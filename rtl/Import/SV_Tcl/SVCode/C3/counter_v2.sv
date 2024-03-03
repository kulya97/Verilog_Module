//File: counter_v2.sv
module counter_v2
#(
  parameter W = 4
)
(
  input logic clk,
  input logic rst, ce, load,
  input logic [W - 1 : 0] load_val,
  output logic [W - 1 : 0] cnt
);
 
  always_ff @(posedge clk) begin
    if (rst) 
      cnt <= '0;
    else if (ce) 
      if (load)
        cnt <= load_val;
      else
        cnt <= cnt + 1;
  end
endmodule
