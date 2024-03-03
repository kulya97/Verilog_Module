//File: remove_rst.sv
module remove_rst 
(
  input logic arst,
  input logic clk,
  input logic din,
  output logic dout
);

  logic din_dly1, din_dly2;
  always_ff @(posedge clk, posedge arst) begin
    if (arst) begin
      dout <= '0;
    end else begin
      dout <= din_dly2;
    end
  end

  always_ff @(posedge clk) begin
    din_dly1 <= din;
    din_dly2 <= din_dly1;
  end
endmodule
