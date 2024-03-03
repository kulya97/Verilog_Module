//File: sp_ram_3d.sv
module sp_ram_3d
#(
  parameter NUM_RAMS = 2,
  parameter AW       = 10,
  parameter DW       = 32,
  parameter RAM_STYLE_VAL = "ultra"
)
(
  input logic clk,
  input logic [NUM_RAMS - 1 : 0] we,
  input logic [AW - 1 : 0] addr [NUM_RAMS],
  input logic [DW - 1 : 0] din  [NUM_RAMS],
  output logic [DW - 1 : 0] dout [NUM_RAMS]
);

  localparam DEPTH = 2 ** AW;

  (* RAM_STYLE = RAM_STYLE_VAL *)
  logic [DW - 1 : 0] mem [NUM_RAMS][DEPTH] = '{NUM_RAMS {'{default : '1}}};

  logic [NUM_RAMS - 1 : 0] we_d1;
  logic [AW - 1 : 0] addr_d1 [NUM_RAMS];
  logic [DW - 1 : 0] din_d1  [NUM_RAMS];

  always_ff @(posedge clk) begin
    we_d1   <= we;
    addr_d1 <= addr;
    din_d1  <= din;
  end

  for (genvar i = 0; i < NUM_RAMS; i++) begin
    always_ff @(posedge clk) begin
      if (we_d1[i]) begin
        mem[i][addr_d1[i]] <= din_d1[i];
      end
      dout[i] <= mem[i][addr_d1[i]];
    end
  end
endmodule
