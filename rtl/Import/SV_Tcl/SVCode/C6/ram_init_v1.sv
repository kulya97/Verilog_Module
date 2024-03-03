//File: ram_init_v1.sv
module ram_init_v1
(
  input logic clk,
  input logic we,
  input logic [3 : 0] addr,
  input logic [3 : 0] din,
  output logic [3 : 0] dout
);

  logic [3 : 0] mem [16] = '{0: 4'hA, 1: 4'hC, 3: 4'h1, default: '0};
  //logic [3 : 0] mem [16] = '{default: '1};

  always_ff @(posedge clk) begin
    if (we) begin
      mem[addr] <= din;
    end
    dout <= mem[addr];
  end
endmodule
