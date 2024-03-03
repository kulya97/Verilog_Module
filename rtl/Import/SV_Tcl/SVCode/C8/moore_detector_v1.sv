//File: moore_detector_v1.sv
module moore_detector_v1
(
  input logic clk,
  input logic rst,
  input logic sin,
  output logic done
);

  typedef enum logic [1 : 0] {idle, got1, got10, got101} state_t;
  state_t cs;

  always_ff @(posedge clk) begin
    if (rst) begin
      cs <= idle;
      done <= '0;
    end
    else begin
      case (cs) 
        idle : begin
          done <= '0;
          if (sin == 1'b1) cs <= got1;
          else cs <= idle;
        end
        got1 : begin
          done <= '0;
          if (sin == 1'b0) cs <= got10;
          else cs <= got1;
        end
        got10 : begin
          done <= '0;
          if (sin == 1'b1) cs <= got101;
          else cs <= idle;
        end
        got101 : begin
          done <= '1;
          if (sin == 1'b1) cs <= got1;
          else cs <= got10;
        end
        default : begin
          done <= '0;
          cs <= idle;
        end
      endcase
    end
  end
endmodule

        

