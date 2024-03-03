//File: counter4.sv
module counter4
(
  input logic clk,
  input logic rst,
  output logic [3 : 0] cnt
);

  
  logic [3 : 0] cnt_i = 4'b1010;
  
  always_comb begin
    cnt = cnt_i;
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      cnt_i <= '0;
    end else begin
      cnt_i <= cnt_i + 1;
    end
  end
endmodule
