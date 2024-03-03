//File: rom_init.sv
module rom_init
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

  localparam DEPTH = 2 ** AW;
  logic [DW - 1 : 0] rom [DEPTH];

  initial begin
    rom[0]  = 16'h200A;
    rom[1]  = 16'h0300;
    rom[2]  = 16'h8101;
    rom[3]  = 16'h4000;
    rom[4]  = 16'h8601;
    rom[5]  = 16'h233A;
    rom[6]  = 16'h0300;
    rom[7]  = 16'h8602;
    rom[8]  = 16'h2222;
    rom[9]  = 16'h4001;
    rom[10] = 16'h0342;
    rom[11] = 16'h232B;
    rom[12] = 16'h0900;
    rom[13] = 16'h0302;
    rom[14] = 16'h0102;
    rom[15] = 16'h4002;
  end 

  always_ff @(posedge clk) begin
    if (en)
      dout <= rom[addr];
  end
endmodule

