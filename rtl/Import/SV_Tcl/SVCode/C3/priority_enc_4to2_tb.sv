timeunit 1ns;
timeprecision 1ps;

class myrand;
  randc bit [3 : 0] a;
endclass

module priority_enc_4to2_tb;

  logic [3 : 0] a;
  logic [1 : 0] y;
  logic valid_in;

   priority_enc_4to2_v2 #(.M(4)) i_encoder_m2n_v2 (.*);

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


