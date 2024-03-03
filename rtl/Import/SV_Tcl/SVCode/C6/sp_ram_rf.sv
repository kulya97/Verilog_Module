//File: sp_ram_rf.sv
module sp_ram_rf
#(
  parameter AW = 5,
  parameter DW = 4
)
(
  input logic clk,
  input logic we,
  input logic [AW - 1 : 0] addr,
  input logic [DW - 1 : 0] din,
  output logic [DW - 1 : 0] dout
);

  localparam DEPTH = 2 ** AW;

  logic [DW - 1 : 0] mem [DEPTH] = '{default : '0};
  logic we_d1;
  logic [AW - 1 : 0] addr_d1;
  logic [DW - 1 : 0] din_d1;
  logic [DW - 1 : 0] dout_temp;

  always_ff @(posedge clk) begin
    we_d1   <= we;
    addr_d1 <= addr;
    din_d1  <= din;
  end

  always_ff @(posedge clk) begin
    if (we_d1) begin
      mem[addr_d1] <= din_d1;
    end
    dout <= mem[addr_d1];
  end
endmodule
