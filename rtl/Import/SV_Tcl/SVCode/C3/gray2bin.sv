//File: gray2bin.sv
module gray2bin
#(
  parameter W = 3
)
(
  input logic [W - 1 : 0] gray_val,
  output logic [W - 1 : 0] bin_val
);

  always_comb begin
    bin_val[W - 1] = gray_val[W - 1];
    for (int i = W - 2; i >= 0; i--) begin
      bin_val[i] = bin_val[i + 1] ^ gray_val[i];
    end
  end
endmodule
