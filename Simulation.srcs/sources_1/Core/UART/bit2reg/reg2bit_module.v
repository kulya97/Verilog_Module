module reg2bit_module #(
    parameter REG_WIDTH = 16
) (
    input                      clk,
    input                      rst_n,
    input                      wr_valid,
    input                      wr_ready,
    input      [REG_WIDTH-1:0] din,
    output                     rd_valid,
    output                     rd_ready,
    output reg [          7:0] dout

);


endmodule
