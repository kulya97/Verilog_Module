//File: circular_buffer.sv
//AW : address width
//DELAY_CYCLE: max value is 2 ** AW - 1
module circular_buffer
#(
  parameter AW = 2,
  parameter DELAY_CYCLE = 3,
  parameter DW = 4
)
(
  input logic clk,
  input logic rst,
  input logic ce,
  input logic [DW - 1 : 0] din,
  output logic [DW - 1 : 0] dout
);

  logic [AW - 1 : 0] addr;

  counter #(.WIDTH(AW), .CMAX(DELAY_CYCLE-3))
  i_counter (.*, .cnt(addr));

  sp_ram_rf #(.AW(AW), .DW(DW))
  i_sp_ram_rf (.we('1), .addr(addr), .*);

endmodule
   



