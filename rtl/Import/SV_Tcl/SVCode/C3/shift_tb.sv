//File: shift_tb.sv
timeunit 1ns;
timeprecision 1ps;

module shift_tb;
  logic [3 : 0] s0, r0;
  logic signed [3 : 0] s1, r1, r2;
  logic [7 : 0] s2;
  logic [7 : 0] res1, res2, res4, res6, res8, resr2;
  initial begin
    s0 = 4'b0001;
    r0 = (s0 << 2);
    s1 = 4'b1000;
    r1 = (s1 >>> 2);
    r2 = (s1 >> 2);
    s2 = 8'b0100_1000;
    res1 = { << {s2}};
    res2 = { << 2 {s2}};
    res4 = { << 4 {s2}};
    res6 = { << 6 {s2}};
    res8 = { << 8 {s2}};
    resr2 = { >> 2 {s2}};
    $display("%b << 2: r0 = %b", s0, r0);
    $display("%b >>> 2: r1 = %b", s1, r1);
    $display("%b >> 2: r2 = %b", s1, r2);
  end
endmodule
