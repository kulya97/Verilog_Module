//File: encoder_4to2_dataflow.sv
module encoder_4to2_dataflow
(
  input logic [3 : 0] a,
  output logic [1 : 0] y
);

  always_comb begin
    y[0] = a[1] || a[3];
    y[1] = a[2] || a[3];
  end
endmodule
