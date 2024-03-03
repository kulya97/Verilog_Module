module three_ops_adder
#(
  parameter DIW = 32,
  parameter DOW = DIW + 2,
  parameter type DTYPE = logic signed
)
(
  input logic clk,
  input DTYPE [DIW - 1 : 0] ain,
  input DTYPE [DIW - 1 : 0] bin,
  input DTYPE [DIW - 1 : 0] cin,
  input DTYPE [DIW - 1 : 0] din,
  output DTYPE [DOW - 1 : 0] sum
);
  
  DTYPE [DIW - 1 : 0] ain_d1, ain_d2;
  DTYPE [DIW - 1 : 0] bin_d1, bin_d2;
  DTYPE [DIW - 1 : 0] cin_d1, din_d1;
  (* USE_DSP = "yes" *) 
  DTYPE [DIW     : 0] sum_cd;
  (* USE_DSP = "yes" *) 
  DTYPE [DOW - 1 : 0] sum_int;

  always_ff @(posedge clk) begin
    cin_d1 <= cin;
    din_d1 <= din;
    sum_cd <= cin_d1 + din_d1;
  end

  always_ff @(posedge clk) begin
    ain_d1  <= ain;
    ain_d2  <= ain_d1;
    bin_d1  <= bin;
    bin_d2  <= bin_d1;
    sum_int <= ain_d2 + bin_d2 + sum_cd;
  end

  assign sum = sum_int;
endmodule

