//File: fifo_ctrl.sv
module fifo_ctrl #( parameter AW = 4)
(
  input logic               clk,
  input logic               rst,
  input logic               wen,
  input logic               ren,
  output logic              mem_wen,
  output logic              mem_ren,
  output logic [AW - 1 : 0] mem_waddr,
  output logic [AW - 1 : 0] mem_raddr,
  output logic              full,
  output logic              empty,
  output logic              dout_valid,
  output logic [AW     : 0] room_avail,
  output logic [AW     : 0] data_avail
);

  localparam FIFO_DEPTH = 1 << AW;

  logic mem_wen_i, mem_ren_i, dout_valid_i;
  logic full_i, empty_i;
  logic [AW : 0] wptr, rptr, wptr_nxt, rptr_nxt;
  logic [AW : 0] data_avail_i, room_avail_i;

  always_ff @(posedge clk) begin
    if (rst) {wptr, rptr} <= '0;
    else     {wptr, rptr} <= {wptr_nxt, rptr_nxt};
  end

  always_comb begin
    mem_wen_i    = wen & ~full;
    mem_ren_i    = ren & ~empty;
    wptr_nxt     = wptr + mem_wen_i;
    rptr_nxt     = rptr + mem_ren_i;
    full_i       = (wptr_nxt == {~rptr[AW], rptr[AW - 1 : 0]});
    empty_i      = (rptr_nxt == wptr);
    data_avail_i = wptr_nxt - rptr_nxt;
    room_avail_i = FIFO_DEPTH - data_avail_i;
  end

  always_ff @(posedge clk) begin
    mem_wen      <= mem_wen_i;
    mem_ren      <= mem_ren_i;
    mem_waddr    <= wptr[AW - 1 : 0];
    mem_raddr    <= rptr[AW - 1 : 0];
    dout_valid_i <= mem_ren;
    dout_valid   <= dout_valid_i;
    data_avail   <= data_avail_i;
    room_avail   <= room_avail_i;
  end

  always_ff @(posedge clk) begin
    if (rst) {full, empty} <= 2'b01;
    else     {full, empty} <= {full_i, empty_i};
  end
endmodule



