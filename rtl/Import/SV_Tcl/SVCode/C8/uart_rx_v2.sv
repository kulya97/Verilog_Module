//File: uart_rx_v2.sv
module uart_rx_v2
#(
  parameter CYCLES_PER_BIT = 87 //#N of clock cycles of each bit
)
(
  input logic clk,
  input logic rx_si,
  output logic rx_dv,
  output logic [7 : 0] rx_byte
);

  localparam int HIGH = CYCLES_PER_BIT - 1;
  localparam int HALF_HIGH = $ceil(CYCLES_PER_BIT / 2 - 1);
  localparam logic [HIGH : 0] ONE = { {(CYCLES_PER_BIT - 1){1'b0}}, 1'b1};
  logic rx_si_d1 = 1'b1;
  logic rx_si_d2 = 1'b1;
  logic [HIGH : 0] rx_cnt;
  logic [2 : 0] rx_bit_id;
  logic [7 : 0] rx_byte_int;

  typedef enum logic [2 : 0] {rx_idle, rx_start_bit, rx_data_bit, rx_stop_bit, rx_cleanup} state_t;
  state_t cs, ns;

  //Double-register the incoming data
  always_ff @(posedge clk) begin
    rx_si_d1 <= rx_si;
    rx_si_d2 <= rx_si_d1;
  end

  always_ff @(posedge clk) begin
    cs <= ns;
  end

  always_comb begin
    case (cs)
      rx_idle :
        begin
          if (rx_si_d2 == 1'b0) ns = rx_start_bit;
          else ns = rx_idle;
        end
      rx_start_bit : 
        begin
          if (rx_cnt[HALF_HIGH]) begin 
            if (rx_si_d2 == 1'b0) ns = rx_data_bit;
            else ns = rx_idle;
          end
          else begin
            ns = rx_start_bit;
          end
        end
      rx_data_bit :
        begin
          if (rx_cnt[HIGH]) begin 
            if (rx_bit_id == 3'b111) ns = rx_stop_bit;
            else ns = rx_data_bit;
          end
          else begin
            ns = rx_data_bit;
          end
        end
      rx_stop_bit :
        begin
          if (rx_cnt[HIGH]) ns = rx_cleanup;
          else ns = rx_stop_bit;
        end
      rx_cleanup: ns = rx_idle;
      default : ns = rx_idle;  
    endcase
  end

  always_ff @(posedge clk) begin
    case (cs) 
      rx_idle : 
        begin
          rx_cnt <= { {(CYCLES_PER_BIT - 1){1'b0}}, 1'b1};
          rx_bit_id <= '0;
          rx_dv <= '0;
        end
      rx_start_bit :
        begin
          if (rx_cnt[HALF_HIGH]) 
            rx_cnt <= ONE;
          else 
            rx_cnt <= rx_cnt << 1;
        end
      rx_data_bit :
        begin
          if (rx_cnt[HIGH]) begin
            rx_cnt <= ONE;
            if (rx_bit_id == 3'b111) begin
              rx_bit_id <= '0;
            end
            else begin
              rx_bit_id <= rx_bit_id + 1'b1;
            end
            rx_byte_int[rx_bit_id] <= rx_si_d2;
          end
          else begin
            rx_cnt <= rx_cnt << 1;
          end
        end
      rx_stop_bit :
        begin
          if (rx_cnt[HIGH]) begin
            rx_cnt <= ONE;
            rx_dv <= 1'b1;
          end
          else begin
            rx_cnt <= rx_cnt << 1;
          end
        end
      rx_cleanup : rx_dv <= 1'b0;
      default : 
        begin
          rx_cnt <= ONE;
          rx_bit_id <= '0;
          rx_dv  <= 1'b0;
        end
    endcase
  end

  always_ff @(posedge clk) begin
    if (rx_dv) rx_byte <= rx_byte_int;
  end
endmodule

      
       
          

          

          

          
          


