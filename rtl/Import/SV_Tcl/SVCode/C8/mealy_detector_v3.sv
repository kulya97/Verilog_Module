//File: mealy_detector_v3.sv
module mealy_detector_v3
(
  input logic clk,
  input logic rst,
  input logic sin,
  output logic done
);

  typedef enum logic [1 : 0] {idle, got1, got10} state_t;
  state_t cs, ns;

  always_ff @(posedge clk) begin
    if (rst) cs <= idle;
    else cs <= ns;
  end

  always_comb begin
    ns = idle;
    case (cs) 
      idle : 
        if (sin == 1'b1) ns = got1;
        else ns = idle;
      got1 :
        if (sin == 1'b1) ns = got1;
        else ns = got10;
      got10 : 
        if (sin == 1'b1) ns = got1;
        else ns = idle;
      default : 
        ns = idle;
    endcase
  end

  always_comb begin
    done = '0;
    case (cs)
      idle : done = '0;
      got1 : done = '0;
      got10 :
        if (sin == 1'b1) done = '1;
        else done = 1'b0;
      default : done = '0;
    endcase
  end
          
endmodule
