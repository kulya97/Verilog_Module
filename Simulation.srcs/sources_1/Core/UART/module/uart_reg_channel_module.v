module uart_reg_channel_module #(
    parameter WIDTH = 32
) (
    input              clk,
    input              rst_n,
    input  [WIDTH-1:0] din,
    input              rden,
    output [WIDTH-1:0] dout,
    output             wren
);
endmodule
