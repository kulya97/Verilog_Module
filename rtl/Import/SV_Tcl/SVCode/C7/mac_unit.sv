//File: mac_unit.sv
module cmac_unit
#(
  parameter AW     = 27,
  parameter BW     = 18,
  parameter MW     = AW + BW,
  parameter AREG   = 1,
  parameter ADDSUB = 1
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ain, 
  input logic signed [BW - 1 : 0] bin, 
  input logic signed [MW - 1 : 0] cin, 
  output logic signed [MW    : 0] pout
);

  logic signed [AW - 1 : 0] amult;
  logic signed [BW - 1 : 0] bmult;
  logic signed [MW - 1 : 0] prod;
  if (AREG == 1) begin
    always_ff @(posedge clk) begin
      amult <= ain;
      bmult <= bin;
    end
  end
  else begin
    always_ff @(posedge clk) begin
      logic signed [AW - 1 : 0] ain_d1;
      logic signed [BW - 1 : 0] bin_d1;
      ain_d1 <= ain;
      amult  <= ain_d1;
      bin_d1 <= bin;
      bmult  <= bin_d1;
    end
  end

  always_ff @(posedge clk) begin
    prod <= amult * bmult;
  end

  if (ADDSUB == 1) begin
    always_ff @(posedge clk) begin
      pout <= cin - prod;
    end
  end
  else begin
    always_ff @(posedge clk) begin
      pout <= cin + prod;
    end
  end
endmodule
      

