//File: ram_init_v2.sv
module ram_init_v2
(
  input logic clk,
  input logic we,
  input logic [3 : 0] addr,
  input logic [3 : 0] din,
  output logic [3 : 0] dout
);

  logic [3 : 0] mem [16];
  
  initial begin
    $readmemh("myram.dat", mem, 0, 15);
   // $readmemh("myram.dat", mem);
  end

  always_ff @(posedge clk) begin
    if (we) begin
      mem[addr] <= din;
    end
    dout <= mem[addr];
  end
endmodule
