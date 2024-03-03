//File: rst_bridge.sv
module rst_bridge
#(
  parameter N = 4
)
(
  input logic clk,
  input logic aset,
  output logic srst
);

  (* ASYNC_REG = "TRUE" *) logic [N - 1 : 0] bridge = '0;
  (* ASYNC_REG = "TRUE" *) logic [1     : 0] bridge_dly = '0;

  always_comb begin
    srst = bridge_dly[1];
  end

  always_ff @(posedge clk, posedge aset) begin
    if (aset) begin
      bridge <= '1;
    end else begin
      bridge <= {bridge[N - 2 : 0], 1'b0};
    end
  end

  always_ff @(posedge clk) begin
    bridge_dly[0] <= bridge[N - 1];
    bridge_dly[1] <= bridge_dly[0];
  end

endmodule

