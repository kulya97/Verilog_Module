//File: static_sreg_poor.sv

  logic a_dly1, a_daly2, a_daly3;

  always_ff @(posedge clk) begin
    a_dly1 <= a;
    a_dly2 <= a_dly1;
    a_dly3 <= a_dly2;
    q      <= a_dly3;
  end
