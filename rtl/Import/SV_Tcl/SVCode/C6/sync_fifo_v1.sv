//File: sync_fifo_v1.sv
module sync_fifo_v1
#(
  parameter FIFO_PTR = 15,   //address width for memory
  parameter FIFO_WIDTH = 18,//data width for memory
  parameter RAM_STYLE_VAL = "block"
)
(
  input logic                       clk,
  input logic                       rst,
  input logic                       wen,
  input logic [FIFO_WIDTH - 1  : 0] din,
  input logic                       ren,
  output logic                      full,
  output logic                      empty,
  output logic [FIFO_PTR       : 0] room_avail,
  output logic [FIFO_PTR       : 0] data_avail,
  output logic                      dout_valid,
  output logic [FIFO_WIDTH - 1 : 0] dout
);
  localparam FIFO_DEPTH = 1 << FIFO_PTR;
  localparam FIFO_DEPTH_MINUS1 = FIFO_DEPTH - 1;

  logic [FIFO_PTR   - 1 : 0] wr_ptr, wr_ptr_nxt;
  logic [FIFO_PTR   - 1 : 0] rd_ptr, rd_ptr_nxt;
  logic [FIFO_PTR       : 0] num_entries, num_entries_nxt;
  logic                      full_nxt, empty_nxt;
  logic [FIFO_PTR       : 0] room_avail_nxt;
  logic                      dout_valid_i;
  logic                      dout_valid_i_d1;
  logic                      mem_wen, mem_ren;
  logic                      mem_wen_i, mem_ren_i;
  logic [FIFO_PTR   - 1 : 0] mem_waddr, mem_raddr;
  logic [FIFO_WIDTH - 1 : 0] mem_din;

  //write-pointer control logic
  always_comb begin
    wr_ptr_nxt = wr_ptr;
    if (mem_wen_i) begin
      if (wr_ptr == FIFO_DEPTH_MINUS1)
        wr_ptr_nxt = '0;
      else
        wr_ptr_nxt = wr_ptr + 1'b1;
    end
  end

  //read-pointer control logic
  always_comb begin
    rd_ptr_nxt = rd_ptr;
    if (mem_ren_i) begin
      if (rd_ptr == FIFO_DEPTH_MINUS1)
        rd_ptr_nxt = '0;
      else
        rd_ptr_nxt = rd_ptr + 1'b1;
    end
  end

  //Calculate number of occupied entries in the FIFO
  always_comb begin
    num_entries_nxt = num_entries;
    if (wen && ren)
      num_entries_nxt = num_entries;
    else if (wen && num_entries_nxt < FIFO_DEPTH)
      num_entries_nxt = num_entries + 1'b1;
    else if (ren && num_entries_nxt > 0)
      num_entries_nxt = num_entries - 1'b1;
  end

  always_comb begin
    full_nxt       = (num_entries_nxt == FIFO_DEPTH);
    empty_nxt      = (num_entries_nxt == '0);
    data_avail     = num_entries;
    room_avail_nxt = FIFO_DEPTH - num_entries_nxt;
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      wr_ptr          <= '0;
      rd_ptr          <= '0;
      num_entries     <= '0;
      full            <= '0;
      empty           <= '1;
      room_avail      <= FIFO_DEPTH;
      dout_valid_i_d1 <= '0;
      dout_valid      <= '0;
    end
    else begin
      wr_ptr          <= wr_ptr_nxt;
      rd_ptr          <= rd_ptr_nxt;
      num_entries     <= num_entries_nxt;
      full            <= full_nxt;
      empty           <= empty_nxt;
      room_avail      <= room_avail_nxt;
      dout_valid_i_d1 <= mem_ren;
      dout_valid      <= dout_valid_i_d1;
    end
  end

  always_comb begin
    mem_wen_i = wen & ~full;
    mem_ren_i = ren & ~empty;
  end

  always_ff @(posedge clk) begin
    mem_wen   <= mem_wen_i;
    mem_din   <= din;
    mem_waddr <= wr_ptr;
    mem_ren   <= mem_ren_i;
    mem_raddr <= rd_ptr;
  end

  sdp_one_clk 
  #(
    .AW(FIFO_PTR), 
    .DW(FIFO_WIDTH), 
    .RAM_STYLE_VAL(RAM_STYLE_VAL)
  )
  i_sdp_one_clk 
  (
    .clk   (clk       ), 
    .wen   (mem_wen   ), 
    .waddr (mem_waddr ), 
    .din   (mem_din   ), 
    .ren   (mem_ren   ),
    .raddr (mem_raddr ),
    .dout  (dout      )
  );
endmodule



