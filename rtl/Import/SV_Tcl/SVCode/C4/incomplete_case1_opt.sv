//File: incomplete_case1_opt.sv
module incomplete_case1_opt
(
  input logic clk,
  input logic [1 : 0] s,
  input logic [3 : 0] a,
  output logic q0,
  output logic q1
);
  always_ff @(posedge clk) begin
    case (s) 
      2'b00: q0 <= a[0];
      2'b01: q0 <= a[1];
      2'b10: 
        begin
          q0 <= a[2]; 
          q1 <= a[2];
        end
      2'b11: q0 <= a[3];
      default: q0 <= a[0];
    endcase
  end
endmodule

