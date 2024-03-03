//File: comment_out_rst.sv
module comment_out_rst 
(
  input logic arst,
  input logic clk,
  input logic din,
  output logic dout
);

  logic din_dly1, din_dly2;
  always_ff @(posedge clk, posedge arst) begin
    if (arst) begin
      //din_dly1 <= '0;
      //din_dly2 <= '0;
      dout     <= '0;
    end else begin
      din_dly1 <= din;
      din_dly2 <= din_dly1;
      dout     <= din_dly2;
    end
  end
endmodule
