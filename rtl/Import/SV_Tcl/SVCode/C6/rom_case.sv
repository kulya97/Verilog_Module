//File: rom_case.sv
module rom_case
#(
  parameter AW = 4,
  parameter DW = 16
)
(
  input logic clk,
  input logic en,
  input logic [AW - 1 : 0] addr,
  output logic [DW - 1 : 0] dout
);
  
  always_ff @(posedge clk) begin
    if (en) begin
      case (addr)                           
        4'b0000: dout <= 16'h200A;
        4'b0001: dout <= 16'h0300;
        4'b0010: dout <= 16'h8101;
        4'b0011: dout <= 16'h4000;
        4'b0100: dout <= 16'h8601;
        4'b0101: dout <= 16'h233A;
        4'b0110: dout <= 16'h0300;
        4'b0111: dout <= 16'h8602;
        4'b1000: dout <= 16'h2222;
        4'b1001: dout <= 16'h4001;
        4'b1010: dout <= 16'h0342;
        4'b1011: dout <= 16'h232B;
        4'b1100: dout <= 16'h0900;
        4'b1101: dout <= 16'h0302;
        4'b1110: dout <= 16'h0102;
        4'b1111: dout <= 16'h4002;
      endcase         
    end
  end
endmodule
