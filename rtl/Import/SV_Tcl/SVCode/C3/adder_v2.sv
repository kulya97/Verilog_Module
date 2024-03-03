//File: adder_v2.sv
module adder_v2
#(
  parameter IS_SIGNED = 1,
  parameter W         = 8
)
(
  input logic [W - 1 : 0] a,
  input logic [W - 1 : 0] b,
  output logic [W : 0] sum
);

  logic [W : 0] a_ex, b_ex;
  
  if (IS_SIGNED == 0) begin 
    always_comb begin
      a_ex = {1'b0, a};
      b_ex = {1'b0, b};
    end
  end
  else begin
    always_comb begin
      a_ex = {a[W - 1], a};
      b_ex = {b[W - 1], b};
    end
  end

  always_comb sum = a_ex + b_ex;
endmodule
  
    

