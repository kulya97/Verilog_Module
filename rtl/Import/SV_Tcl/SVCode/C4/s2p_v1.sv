//File: s2p_v1.sv
module s2p_v1
#(
  parameter W = 4
)
(
  input logic clk,
  input logic rst,
  input logic combine,
  input logic sin,
  output logic [W - 1 : 0] pout
);

  logic [W - 1 : 0] sreg = '0;

  always_ff @(posedge clk) begin
    if (rst) 
      sreg <= '0;
    else
      sreg <= {sreg[W - 2 : 0], sin};
  end

  always_ff @(posedge clk) begin
    if (combine)
      pout <= sreg;
  end

endmodule
