//File: separate_logic_rst_poor.sv
module separate_logic_rst_poor
(
  input logic clk,
  input logic srst,
  input logic hrst,
  input logic d,
  output logic q
); 

  always_ff @(posedge clk, posedge srst, posedge hrst) begin
    if (srst || hrst) begin
      q <= '0;
    end else begin
      q <= d;
    end
  end
endmodule
