//File: uart_tx_v2.sv
module uart_tx_v2
#(
  parameter CYCLES_PER_BIT = 87
)
(
  input logic clk,
  input logic tx_dv,
  input logic [7 : 0] tx_byte,
  output logic tx_active,
  output logic tx_so,
  output logic tx_done
);
  localparam HIGH = CYCLES_PER_BIT - 1;
  logic [HIGH : 0] tx_cnt;
  logic [2 : 0] tx_bit_id;
  logic [7 : 0] tx_data;

  typedef enum logic [2 : 0] {tx_idle, tx_start_bit, tx_data_bit, tx_stop_bit, tx_cleanup} state_t;
  state_t cs, ns;

  always_ff @(posedge clk) begin
    cs <= ns;
  end

  always_comb begin
    ns = tx_idle;
    case (cs) 
      tx_idle :
         if (tx_dv == 1'b1) ns = tx_start_bit;
         else ns = tx_idle;
      tx_start_bit :
        if (tx_cnt[HIGH]) ns = tx_data_bit;
        else ns = tx_start_bit;
      tx_data_bit :
        if (tx_cnt[HIGH] && tx_bit_id == 3'b111) ns = tx_stop_bit;
        else ns = tx_data_bit;
      tx_stop_bit :
        if (tx_cnt[HIGH]) ns = tx_cleanup;
        else ns = tx_stop_bit;
      tx_cleanup : ns = tx_idle;
      default : ns = tx_idle;
    endcase
  end

  always_ff @(posedge clk) begin
    case (cs) 
      tx_idle :
        begin 
          tx_so <= 1'b1;
          tx_done <= 1'b0;
          tx_cnt <= { {(HIGH){1'b0} }, 1'b1};
          tx_bit_id <= '0;
          if (tx_dv == 1'b1) begin
            tx_data <= tx_byte;
            tx_active <= 1'b1;
          end
        end
      tx_start_bit :
        begin
          tx_so <= 1'b0;
          if (tx_cnt[HIGH]) tx_cnt <= {tx_cnt[HIGH - 1 : 0], 1'b1};
          else tx_cnt <= tx_cnt << 1;
        end
      tx_data_bit :
        begin
          tx_so <= tx_data[tx_bit_id];
          if (tx_cnt[HIGH]) begin
            tx_cnt <= {tx_cnt[HIGH - 1 : 0], 1'b1};
            if (tx_bit_id == 3'b111) tx_bit_id <= '0;
            else tx_bit_id <= tx_bit_id + 1'b1;
          end
          else begin
            tx_cnt <= tx_cnt << 1;
          end
        end
      tx_stop_bit :
        begin
          tx_so <= 1'b1;
          if (tx_cnt[HIGH]) begin
            tx_cnt <= {tx_cnt[HIGH - 1 : 0], 1'b1};
            tx_done <= 1'b1;
            tx_active <= 1'b0;
          end
          else begin
            tx_cnt <= tx_cnt << 1;
          end
        end
      tx_cleanup : tx_done <= 1'b0;
      default : 
        begin
          tx_done <= 1'b0;
          tx_so   <= 1'b1;
        end
    endcase
  end
endmodule


      
          


         
        


