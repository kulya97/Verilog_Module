//File: moore_detector_v3.sv
module moore_detector_v3
#(
  parameter FSM_ENCODING_VAL = "one_hot"
)
(
  input logic clk,
  input logic rst,
  input logic sin,
  output logic done
);

  typedef enum logic [1 : 0] {idle, got1, got10, got101} state_t;
  (* fsm_encoding = FSM_ENCODING_VAL *) state_t cs, ns;

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
        if (sin == 1'b1) ns = got101;
        else ns = idle;
      got101 :
        if (sin == 1'b1) ns = got1;
        else ns = got10;
      default : 
        ns = idle;
    endcase
  end

  always_ff @(posedge clk) begin
    if (cs == got101) done <= '1;
    else done <= '0;
  end

endmodule
