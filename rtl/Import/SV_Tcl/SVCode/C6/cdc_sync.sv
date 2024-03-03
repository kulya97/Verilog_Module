//File: cdc_sync.sv
module cdc_sync #( parameter AW = 4)
(
  input logic           clk,
  input logic           rst,
  input logic  [AW : 0] din,
  output logic [AW : 0] dout
);

  (* ASYNC_REG = "TRUE" *) logic [AW : 0] din_d1;
  (* ASYNC_REG = "TRUE" *) logic [AW : 0] din_d2;

  always_ff @(posedge clk) begin
    if (rst) {din_d2, din_d1} <= '0;
    else     {din_d2, din_d1} <= {din_d1, din};
  end

  assign dout = din_d2;
endmodule
