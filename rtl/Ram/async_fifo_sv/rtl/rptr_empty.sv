//File: rptr_empty.sv
module rptr_empty #( parameter AW = 4 )
(
  input logic               rclk,
  input logic               rrst,
  input logic               ren,
  input logic  [AW     : 0] rq2_wptr,
  output logic [AW     : 0] rptr,
  output logic [AW - 1 : 0] mem_raddr,
  output logic              rempty,
  output logic              mem_ren,
  output logic              dout_valid
);

  logic [AW : 0] rbin, rbin_nxt, rgray_nxt;
  logic [AW : 0] rptr_i;
  logic mem_ren_i;
  logic rempty_val;
  logic dout_valid_i;

  always_ff @(posedge rclk) begin
    if (rrst) {rbin, rptr_i, rptr} <= '0;
    else      {rbin, rptr_i, rptr} <= {rbin_nxt, rgray_nxt, rptr_i};
  end

  always_comb begin
    mem_ren_i  = ren & ~rempty;
    rbin_nxt   = rbin + mem_ren_i;
    rgray_nxt  = (rbin_nxt >> 1) ^ rbin_nxt;
    rempty_val = (rgray_nxt == rq2_wptr);
  end

  always_ff @(posedge rclk) begin
    mem_ren      <= mem_ren_i;
    mem_raddr    <= rbin[AW - 1 : 0];
    dout_valid_i <= mem_ren;
    dout_valid   <= dout_valid_i;
  end

  always_ff @(posedge rclk) begin
    if (rrst) rempty <= 1'b1;
    else      rempty <= rempty_val;
  end
endmodule

  
