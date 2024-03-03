timeunit 1ns;
timeprecision 1ps;

class myrand;
  randc bit [3 : 0] a;
endclass

module encoder_4to2_tb;

  logic [3 : 0] a;
  logic [1 : 0] y;

  priority_enc_m2n_v1 #(.N(2)) i_encoder_m2n_v1 (.*);

  myrand myrand_i;

  initial begin
    myrand_i = new();
    a <= 0;
    for (int i = 0; i < 18; i++) begin
      #5
      //a <= myrand_i.a;
      a <= i;
      $display("Input = %0h", a);
      assert (myrand_i.randomize());
    end
    $stop;
  end
endmodule


