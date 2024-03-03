module rgb24to48 (
    input        I_2x_pixel_clk,
    input        rst_n,
    input        I_pixel_clk,
    input [23:0] I_pixel_data,
    input        I_24rgb_hsync,
    input        I_24rgb_vsync,
    input        I_24rgb_de,

    output reg [47:0] O_pixel_data,
    output reg        O_48rgb_hsync,
    output reg        O_48rgb_vsync,
    output reg        O_48rgb_de
);

  reg R_mark = 1'b0;
  /*********************************************/
  always @(posedge I_2x_pixel_clk or negedge rst_n) begin
    if (!rst_n) O_pixel_data <= 48'd0;
    else if (I_24rgb_de && (!R_mark)) begin
      O_pixel_data[23:0] <= I_pixel_data;
      R_mark             <= 1'b1;
    end else if (I_24rgb_de && R_mark) begin
      O_pixel_data[47:24] <= I_pixel_data;
      R_mark              <= 1'b0;
    end else if (!I_24rgb_de) begin
      O_pixel_data[47:0] <= 48'd0;
      R_mark             <= 1'b0;
    end
  end
  /*********************************************/
  always @(posedge I_pixel_clk or negedge rst_n)
    if (!rst_n) O_48rgb_hsync <= 1'b0;
    else O_48rgb_hsync <= I_24rgb_hsync;
  /*********************************************/
  always @(posedge I_pixel_clk or negedge rst_n)
    if (!rst_n) O_48rgb_vsync <= 1'b0;
    else O_48rgb_vsync <= I_24rgb_vsync;
  /*********************************************/
  always @(posedge I_pixel_clk or negedge rst_n)
    if (!rst_n) O_48rgb_de <= 1'b0;
    else O_48rgb_de <= I_24rgb_de;

endmodule
