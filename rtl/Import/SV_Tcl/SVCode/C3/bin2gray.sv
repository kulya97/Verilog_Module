//File: bin2gray.sv
module bin2gray
#(
  parameter W = 3
)
(
  input logic [W - 1 : 0] bin_val,
  output logic [W - 1 : 0] gray_val
);

  always_comb begin
    for (int i = 0; i < W - 1; i++) begin
      gray_val[i] = bin_val[i] ^ bin_val[i + 1];
    end
    gray_val[W - 1] = bin_val[W - 1];
  end
endmodule
