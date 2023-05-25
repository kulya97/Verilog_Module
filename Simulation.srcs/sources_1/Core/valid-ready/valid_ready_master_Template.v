module valid_ready_master_Template (  //sender
    input            clk,
    input            rst_n,
    output reg       O_valid,
    input            I_ready,
    output     [7:0] O_dout
);
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) O_valid <= 1'b0;
    else if (1) O_valid <= 1'b1;
    else O_valid <= 1'b0;
  end
  reg [7:0] data_cnt;
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) data_cnt <= 'd0;
    else if (O_valid && I_ready) data_cnt <= data_cnt + 1'd1;
    else data_cnt <= data_cnt;
  end

endmodule
