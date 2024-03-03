//File: rom_dual_port.sv
module rom_dual_port
#(
  parameter AW = 4,
  parameter DW = 16,
  parameter ROM_STYLE_VAL = "block"
)
(
  input logic clka,
  input logic ena,
  input logic [AW - 1 : 0] addra,
  output logic [DW - 1 : 0] douta,
  input logic clkb,
  input logic enb,
  input logic [AW - 1 : 0] addrb,
  output logic [DW - 1 : 0] doutb
);

  localparam DEPTH = 2 ** AW;

 // (* ROM_STYLE = ROM_STYLE_VAL *)
  logic [DW - 1 : 0] rom [DEPTH];

  initial begin
    $readmemh("myrom.dat", rom);
  end

  always_ff @(posedge clka) begin
    if (ena) 
      douta <= rom[addra];
  end

  always_ff @(posedge clkb) begin
    if (enb) 
      doutb <= rom[addrb];
  end
endmodule

  

