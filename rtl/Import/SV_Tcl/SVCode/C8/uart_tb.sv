timeunit 1ns;
timeprecision 1ps;

module uart_tb;

  parameter NUM_DATA = 10;
  parameter shortreal PERIOD = 100;
  parameter shortreal BAUD_RATE = 115200;
  parameter CYCLES_PER_BIT = int'($ceil((10 ** 9) / BAUD_RATE / PERIOD));
  parameter NUM_START_BIT = 1;
  parameter NUM_DATA_BIT = 8;
  parameter NUM_STOP_BIT = 1;
  parameter UART_DATA_BIT = NUM_START_BIT + NUM_DATA_BIT + NUM_STOP_BIT;
  parameter UART_DATA_CYCLES = UART_DATA_BIT * CYCLES_PER_BIT;

  bit clk;
  logic tx_dv;
  logic [7 : 0] tx_byte;
  logic tx_active; 
  logic tx_so;
  logic tx_done;
  logic rx_dv;
  logic [7 : 0] rx_byte;

  uart_tx #(.CYCLES_PER_BIT(CYCLES_PER_BIT))
  i_uart_tx (.*);
  uart_rx #(.CYCLES_PER_BIT(CYCLES_PER_BIT))
  i_uart_rx (.clk(clk), .rx_si(tx_so), .rx_dv(rx_dv), .rx_byte(rx_byte));
//  uart_tx_v2 #(.CYCLES_PER_BIT(CYCLES_PER_BIT))
//  i_uart_tx_v2 (.*);

//  uart_rx_v2 #(.CYCLES_PER_BIT(CYCLES_PER_BIT))
//  i_uart_rx_v2 (.clk(clk), .rx_si(tx_so), .rx_dv(rx_dv), .rx_byte(rx_byte));

  default clocking cb @(posedge clk);
    default input #1step output #0;
    input rx_dv, rx_byte, tx_done, tx_active;
    output tx_dv, tx_byte;
  endclocking

  initial begin
    clk = '0;
    forever #(PERIOD / 2) clk = ~clk;
  end

  initial begin
    tx_dv <= '0;
    tx_byte <= '0;
    for (int i = 0; i < NUM_DATA; i++) begin
      ##1 cb.tx_dv <= '1;
          cb.tx_byte <= i + 5;
      ##1 cb.tx_dv <= '0;
      ##(UART_DATA_CYCLES) cb.tx_dv <= '0;
    end
    ##4 $stop;
  end
endmodule

    


