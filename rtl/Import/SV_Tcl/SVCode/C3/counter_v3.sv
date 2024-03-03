//File: counter_v3.sv
module counter_v3
#(
  parameter W = 16
)
(
  input logic clk,
  input logic rst, ce, load, up_down,
  input logic [W - 1 : 0] load_val,
  output logic [W - 1 : 0] cnt
);
 
  always_ff @(posedge clk) begin
    if (rst) 
      cnt <= '0;
    else if (ce) 
      if (load)
        cnt <= load_val;
      else if (up_down)
        cnt <= cnt + 1;
      else
        cnt <= cnt - 1;

  end
endmodule
