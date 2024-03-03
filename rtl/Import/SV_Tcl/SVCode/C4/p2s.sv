module Parallel2Serial(Parin, clk, serout,reset, load, eoc);
 input[3:0] Parin;
 wire[3:0] Parin;
 input reset;
 wire reset;
 input clk;
 wire clk;
 output serout;
 output eoc;
 reg eoc;
 input load;
 wire load;
 reg serout;
 reg[3:0] bufferreg;
 
always@(posedge clk)
 begin
      //assign bufferreg =Parin;
      if(reset == 1)
           begin
               bufferreg = 0;
               serout =0; eoc =0;
           end
       else if(load) 
            bufferreg<=Parin;
            //load =0;
            //$display("the content of bufferreg is %D", bufferreg);end
      else 
           begin
              serout <= bufferreg[3];
              bufferreg <= (bufferreg<<1);
           end
 
      end
endmodule
