//File: average_v2.sv
module average_v2
#(
  parameter IS_CEIL = 1,
  parameter W       = 8
)
(
  input logic signed [W - 1 : 0] a0, a1,
  output logic signed [W - 1 : 0] avg
);

  if (IS_CEIL == 1) begin
    always_comb begin
      avg = (a0 | a1) - ((a0 ^ a1) >>> 1);
    end
  end
  else begin
    always_comb begin
      avg = (a0 & a1) + ((a0 ^ a1) >>> 1);
    end
  end
endmodule
