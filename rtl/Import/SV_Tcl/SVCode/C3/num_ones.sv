//File: num_ones.sv
module num_ones
#(
  parameter DIW = 4,
  parameter DOW = $clog2(DIW) + 1
)
(
  input logic [DIW - 1 : 0] din,
  output logic [DOW - 1 : 0] ones
);

  always_comb begin
    ones = '0;
    for (int i = 0; i < DIW; i++)
      ones = ones + din[i];
  end
endmodule
