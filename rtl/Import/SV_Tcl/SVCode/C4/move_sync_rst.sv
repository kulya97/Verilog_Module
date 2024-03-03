//File: move_sync_rst.sv
module move_sync_rst 
(
  input logic clk,
  input logic rst,
  input logic d,
  output logic q
);

  always_ff @(posedge clk) begin
    if (rst) begin
      q <= '0;
    end else begin
      q <= d;
    end
  end
endmodule
