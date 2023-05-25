module sync_standard_fifo #(
    parameter WIDTH = 16,
    parameter DEPTH = 1024
) (
    input                  clk,
    input                  rst_n,
    input      [WIDTH-1:0] din,
    input                  wr_en,
    input                  rd_en,
    output reg [WIDTH-1:0] dout,
    output reg             full,
    output reg             empty
);
  localparam ADDR_WIDTH = clogb2(DEPTH);
  reg [ADDR_WIDTH-1:0] fifo_cnt;
  reg [     WIDTH-1:0] ram      [DEPTH-1:0];
  reg [ADDR_WIDTH-1:0] wr_addr;
  reg [ADDR_WIDTH-1:0] rd_addr;


  function integer clogb2;
    input [31:0] value;
    begin
      value = value - 1;
      for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) value = value >> 1;
    end
  endfunction


  //read
  reg [WIDTH-1:0] R_dout;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rd_addr <= {ADDR_WIDTH{1'b0}};
      R_dout  <= 'd0;
    end else if (rd_en && !empty) begin
      rd_addr <= rd_addr + 1'd1;
      R_dout  <= ram[rd_addr];
    end else begin
      rd_addr <= rd_addr;
      R_dout  <= R_dout;
    end
  end
  always @(posedge clk, negedge rst_n) begin
    if (!rst_n) dout <= 'D0;
    else dout <= R_dout;
  end
  //write
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) wr_addr <= {ADDR_WIDTH{1'b0}};
    else if (wr_en && !full) begin
      wr_addr      <= wr_addr + 1'd1;
      ram[wr_addr] <= din;
    end else wr_addr <= wr_addr;
  end
  //fifo_cnt
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) fifo_cnt <= {ADDR_WIDTH{1'b0}};
    else if (wr_en && !full && !rd_en) fifo_cnt <= fifo_cnt + 1'd1;
    else if (rd_en && !empty && !wr_en) fifo_cnt <= fifo_cnt - 1'd1;
    else fifo_cnt <= fifo_cnt;
  end
  //empty 
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) empty <= 1'b1;  //reset:1
    else empty <= (!wr_en && (fifo_cnt[ADDR_WIDTH-1:1] == 'b0)) && ((fifo_cnt[0] == 1'b0) || rd_en);
  end
  //full
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) full <= 1'b1;  //reset:1
    else full <= (!rd_en && (fifo_cnt[ADDR_WIDTH-1:1] == {(ADDR_WIDTH - 1) {1'b1}})) && ((fifo_cnt[0] == 1'b1) || wr_en);
  end
endmodule
