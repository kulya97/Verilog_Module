//File: cpreadder_mac_unit.sv
module cpreadder_mac_unit
#(
  parameter AW     = 18,
  parameter BW     = 18,
  parameter MW     = AW + 1 + BW,
  parameter AREG   = 2,
  parameter BREG   = 3,
  parameter ADDSUB = 0
)
(
  input logic clk,
  input logic signed [AW - 1 : 0] ain,
  input logic signed [AW - 1 : 0] din,
  input logic signed [BW - 1 : 0] bin,
  input logic signed [MW - 1 : 0] cin,
  output logic signed [MW    : 0] pout
);

  logic signed [AW - 1 : 0] add_op1; 
  logic signed [AW - 1 : 0] add_op2; 
  logic signed [AW     : 0] addreg; 
  logic signed [BW - 1 : 0] bmult;
  logic signed [MW - 1 : 0] mreg;
  if (AREG == 1) begin
    always_ff @(posedge clk) begin
      add_op1 <= ain;
      add_op2 <= din;
    end
  end
  else begin
    always_ff @(posedge clk) begin
      logic signed [AW - 1 : 0] ain_d1;
      logic signed [AW - 1 : 0] din_d1;
      ain_d1  <= ain;
      add_op1 <= ain_d1;
      din_d1  <= din;
      add_op2 <= din_d1;
    end
  end

  if (BREG == 2) begin
    always_ff @(posedge clk) begin
      logic signed [BW - 1 : 0] bin_d1;
      bin_d1 <= bin;
      bmult  <= bin_d1;
    end
  end
  else begin
    always_ff @(posedge clk) begin
      logic signed [BW - 1 : 0] bin_d1;
      logic signed [BW - 1 : 0] bin_d2;
      bin_d1 <= bin;
      bin_d2 <= bin_d1;
      bmult  <= bin_d2;
    end
  end

  always_ff @(posedge clk) begin
    addreg <= ADDSUB ? (add_op1 - add_op2) : (add_op1 + add_op2);
    mreg   <= addreg * bmult;
    pout   <= mreg + cin;
  end
endmodule


