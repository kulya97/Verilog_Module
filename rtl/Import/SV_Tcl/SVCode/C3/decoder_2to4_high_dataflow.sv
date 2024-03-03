//File: decoder_2to4_high_dataflow.sv
module decoder_2to4_high_dataflow
(
  input logic [1 : 0] a,
  input logic en,
  output logic [3 : 0] y
);

  always_comb begin
    y[0] = en & (!a[1]) & (!a[0]);
    y[1] = en & (!a[1]) & a[0];
    y[2] = en & a[1]    & (!a[0]);
    y[3] = en & a[1]    & a[0];
  end
endmodule
