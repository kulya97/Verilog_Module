//File: adder_v1.sv
module adder_v1
#(
  parameter W = 4
)
(
  input logic [W - 1 : 0] a,
  input logic [W - 1 : 0] b,
  input logic cin,
  output logic [W - 1 : 0] sum,
  output logic cout
);

  logic [W - 1 : 0] cout_i;
  full_adder i_full_adder 
  (.a(a[0]), 
   .b(b[0]), 
   .cin(cin), 
   .s(sum[0]), 
   .cout(cout_i[0])
  );
  for (genvar i = 1; i < W; i++) begin 
    full_adder i_full_adder
    (
     .a(a[i]),
     .b(b[i]),
     .cin(cout_i[i - 1]),
     .s(sum[i]),
     .cout(cout_i[i])
    );
  end

  always_comb cout = cout_i[W - 1];

endmodule
