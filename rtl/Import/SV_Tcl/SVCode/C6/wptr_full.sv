//File: wptr_full.sv
module wptr_full #( parameter AW = 4 )
(
  input logic               wclk,
  input logic               wrst,
  input logic               wen,
  input logic  [AW     : 0] wq2_rptr,
  output logic [AW - 1 : 0] mem_waddr,
  output logic              mem_wen,
  output logic [AW     : 0] wptr,
  output logic              wfull
);

  logic [AW : 0] wbin, wbin_nxt, wgray_nxt;
  logic mem_wen_i;
  logic wfull_val;
  logic [AW : 0] wptr_i;

  always_ff @(posedge wclk) begin
    if (wrst) {wbin, wptr_i, wptr} <= '0;
    else      {wbin, wptr_i, wptr} <= {wbin_nxt, wgray_nxt, wptr_i};
  end

  always_comb begin
    mem_wen_i = wen & ~wfull;
    wbin_nxt  = wbin + mem_wen_i;
    wgray_nxt = (wbin_nxt >> 1) ^ wbin_nxt;
    wfull_val = (wgray_nxt == {~wq2_rptr[AW : AW - 1], wq2_rptr[AW - 2 : 0]});
  end

  always_ff @(posedge wclk) begin
    if (wrst) wfull <= 1'b0;
    else      wfull <= wfull_val;
  end

  always_ff @(posedge wclk) begin
    mem_waddr <= wbin[AW - 1 : 0];
    mem_wen   <= mem_wen_i;
  end
endmodule


