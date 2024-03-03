//File: bytewrite_ram_nc.sv
module bytewrite_ram_nc
#(
  parameter AW = 10,
  parameter NB = 4,
  parameter RAM_STYLE_VAL = "block"
)
(
  input logic clk,
  input logic [NB - 1 : 0] we,
  input logic [AW - 1 : 0] addr,
  input logic [NB * 8 - 1 : 0] din,
  output logic [NB * 8 - 1 : 0] dout
);

  localparam DEPTH = 2 ** AW;

  logic [NB - 1     : 0] we_d1;
  logic [AW - 1     : 0] addr_d1;
  logic [NB * 8 - 1 : 0] din_d1;

  (* RAM_STYLE = RAM_STYLE_VAL *)
  logic [NB * 8 - 1 : 0] mem [DEPTH] = '{default : '0};

  always_ff @(posedge clk) begin
    we_d1   <= we;
    addr_d1 <= addr;
    din_d1  <= din;
  end

  for (genvar i = 0; i < NB; i++) begin
    always_ff @(posedge clk) begin
      if (we_d1[i]) begin
        mem[addr_d1][i * 8 +: 8] <= din_d1[i * 8 +: 8];
      end
    end
  end

  always_ff @(posedge clk) begin
    if (~|we_d1) begin
      dout <= mem[addr_d1];
    end
  end

endmodule

