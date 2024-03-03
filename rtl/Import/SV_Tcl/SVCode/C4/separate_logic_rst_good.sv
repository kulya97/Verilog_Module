//File: separate_logic_rst_good.sv
module separate_logic_rst_poor
(
  input logic clk,
  input logic srst,
  input logic hrst,
  input logic d,
  output logic q
); 

  logic rst;

  always_comb begin
    rst = srst || hrst;
  end

  always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
      q <= '0;
    end else begin
      q <= d;
    end
  end
endmodule
