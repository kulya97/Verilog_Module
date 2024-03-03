//File: counter.sv
(* USE_DSP = "yes" *)
module counter 
#(
  parameter  W       = 48,
  parameter  STEP    = 2,
  parameter  CNT_MAX = 16
)
(
  input logic clk,
  input logic rst,
  output logic [W - 1 : 0] cnt
);
  localparam logic [W - 1 : 0] CNT_MAXI = unsigned'(CNT_MAX);
  localparam logic [W - 1 : 0] STEPI = unsigned'(STEP);

  always_ff @(posedge clk) begin
    if (rst) begin
      cnt <= '0;
    end
    else if (cnt == CNT_MAXI) begin
      cnt <= '0;
    end
    else begin
      cnt <= cnt + STEPI;
    end
  end
endmodule

