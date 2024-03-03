//File: p2s_v1.sv
module p2s_v1
#(
  parameter W = 4
)
(
  input logic clk,
  input logic rst,
  input logic load,
  input logic [W - 1 : 0] pin,
  output logic sout
);

  logic [W - 1 : 0] pin_shift;

  always_ff @(posedge clk) begin
    if (rst)
      pin_shift <= '0;
    else if (load)
      pin_shift <= pin;
    else
      pin_shift <= pin_shift << 1;
  end

  assign sout = pin_shift[W - 1];

endmodule
