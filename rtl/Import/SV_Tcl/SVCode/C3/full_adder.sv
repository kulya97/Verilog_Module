//File: full_adder.sv
module full_adder 
(
  input logic a, b, cin,
  output logic s, cout
);
  
  logic temp;
  always_comb begin
    temp = a ^ b;
    s = temp ^ cin;
    cout = (a & b) | (temp & cin);
  end
endmodule


