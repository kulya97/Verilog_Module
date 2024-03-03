//File: sdp_ram_3d.sv
module sdp_ram_3d
#(
  parameter NUM_RAMS = 2,
  parameter AW       = 11,
  parameter DW       = 16
)
(
  input logic clka,
  input logic [NUM_RAMS - 1 : 0] wea,
  input logic [AW - 1 : 0] addra [NUM_RAMS - 1 : 0],
  input logic [DW - 1 : 0] dina  [NUM_RAMS - 1 : 0],
  input logic clkb,
  input logic [NUM_RAMS - 1 : 0] rstb,
  input logic [NUM_RAMS - 1 : 0] reb,
  input logic [AW - 1 : 0] addrb [NUM_RAMS - 1 : 0],
  output logic [DW - 1 : 0] doutb [NUM_RAMS - 1 : 0]
);

  localparam DEPTH = 2 ** AW;
  logic [DW - 1 : 0] mem [NUM_RAMS][DEPTH] = '{NUM_RAMS {'{default : '0}}};

  logic [NUM_RAMS - 1 : 0] wea_d1;
  logic [AW - 1 : 0] addra_d1 [NUM_RAMS - 1 : 0];
  logic [DW - 1 : 0] dina_d1  [NUM_RAMS - 1 : 0];
  logic [NUM_RAMS - 1 : 0] reb_d1;
  logic [NUM_RAMS - 1 : 0] rstb_d1;
  logic [AW - 1 : 0] addrb_d1 [NUM_RAMS - 1 : 0];
  logic [DW - 1 : 0] doutb_i  [NUM_RAMS - 1 : 0];

  always_ff @(posedge clka) begin
    wea_d1   <= wea;
    addra_d1 <= addra;
    dina_d1  <= dina;
  end

  always_ff @(posedge clkb) begin
    rstb_d1  <= rstb;
    reb_d1   <= reb;
    addrb_d1 <= addrb;
  end

  for (genvar i = 0; i < NUM_RAMS; i++) begin
    always_ff @(posedge clka) begin
      if (wea_d1[i]) begin
        mem[i][addra_d1[i]] <= dina_d1[i];
      end
    end
  end

  for (genvar k = 0; k < NUM_RAMS; k++) begin
    always_ff @(posedge clkb) begin
      if (reb_d1[k]) begin
        doutb_i[k] <= mem[k][addrb_d1[k]];
      end
    end

    always_ff @(posedge clkb) begin
      if (rstb_d1[k]) 
        doutb[k] <= '0;
      else
        doutb[k] <= doutb_i[k];
    end
  end

endmodule


