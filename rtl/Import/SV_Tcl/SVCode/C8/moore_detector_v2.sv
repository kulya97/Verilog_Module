//File: moore_detector_v2.sv
module moore_detector_v2
(
  input logic clk,
  input logic rst,
  input logic sin,
  output logic done
);

  typedef enum logic [1 : 0] {idle, got1, got10, got101} state_t;
  state_t cs, ns;

  always_ff @(posedge clk) begin
    if (rst) cs <= idle;
    else cs <= ns;
  end

  always_comb begin
    ns = idle;
    done = '0;
    case (cs) 
      idle : 
        begin
          if (sin == 1'b1) ns = got1;
          else ns = idle;
          done = '0;
        end
      got1 :
        begin
          if (sin == 1'b1) ns = got1;
          else ns = got10;
          done = '0;
        end
      got10 : 
        begin
          if (sin == 1'b1) ns = got101;
          else ns = idle;
          done = '0;
        end
      got101:
        begin
          if (sin == 1'b1) ns = got1;
          else ns = got10;
          done = '1;
        end
      default : 
        begin
          ns = idle;
          done = '0;
        end
    endcase
  end
endmodule
