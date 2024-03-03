//File: mult_27x19.sv
module mult_27x19
(
  input logic clk,
  input logic signed [26 : 0] ain,
  input logic signed [18 : 0] bin,
  output logic signed [45 : 0] pout
);

  logic signed [26 : 0] ain_d1;
  logic signed [18 : 0] bin_d1;
  logic signed [44 : 0] mreg;
  logic signed [25 : 0] cin_d1, cin_d2;
  logic signed [44 : 0] pout_h;
  logic p0, p0_d1, p0_d2;

  always_ff @(posedge clk) begin
    if (!bin[0]) begin
      cin_d1 <= '0;
    end
    else begin
      cin_d1 <= signed'(ain[26 : 1]);
    end
  end

  always_ff @(posedge clk) begin
    ain_d1       <= ain;
    bin_d1       <= bin;
    cin_d2       <= cin_d1;
    mreg         <= ain_d1 * signed'(bin_d1[18 : 1]);
    pout_h       <= mreg + cin_d2;
  end

  always_ff @(posedge clk) begin
    p0      <= ain[0] & bin[0];
    p0_d1   <= p0;
    p0_d2   <= p0_d1;
  end
  
  always_comb pout = signed'({pout_h, p0_d2});
endmodule

  
  

