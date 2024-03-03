//File: priority_mux_v2.sv
module priority_mux_v2 
(
  input logic a, b, c, d,
  input logic [3 : 0] sel,
  output logic q
);
  always_comb begin
    if (sel[3]) 
      q = d;
    else if (sel[2]) 
      q = c;
    else if (sel[1]) 
      q = b;
    else if (sel[0]) 
      q = a;
    else
      q = '0;
  end
endmodule
