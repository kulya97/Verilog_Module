module afifo #(
    parameter   DEEPWID = 3 ,
    parameter   DEEP    = 8 ,
    parameter   BITWID  = 8
) (
    input              wr_clk,
    input              wr_rst_n,
    input              wr,
    input [BITWID-1:0] wr_dat,

    input                   rd_clk,
    input                   rd_rst_n,
    input                   rd,
    output reg [BITWID-1:0] rd_dat,
    output reg              rd_dat_vld,

    input      [DEEPWID-1:0] cfg_almost_full,
    input      [DEEPWID-1:0] cfg_almost_empty,
    output reg               almost_full,
    output reg               almost_empty,
    output reg               full,
    output reg               empty,
    output     [  DEEPWID:0] wr_num,
    output     [  DEEPWID:0] rd_num
);

  //****************************************************************
  reg     [  DEEPWID:0] wr_ptr_exp;
  reg     [  DEEPWID:0] rd_ptr_exp;
  wire    [DEEPWID-1:0] wr_ptr;
  wire    [DEEPWID-1:0] rd_ptr;

  reg     [  DEEPWID:0] wr_ptr_exp_r;
  reg     [  DEEPWID:0] rd_ptr_exp_r;
  reg     [  DEEPWID:0] wr_ptr_exp_cross;
  reg     [  DEEPWID:0] rd_ptr_exp_cross;
  reg     [  DEEPWID:0] wr_ptr_exp_cross_r;
  reg     [  DEEPWID:0] rd_ptr_exp_cross_r;
  reg     [  DEEPWID:0] wr_ptr_exp_cross_trans;
  reg     [  DEEPWID:0] rd_ptr_exp_cross_trans;

  reg     [ BITWID-1:0] my_memory              [DEEP-1:0];
  integer               ii;

  //----------------------------------------------------------
  assign wr_ptr       = wr_ptr_exp[DEEPWID-1:0];
  assign rd_ptr       = rd_ptr_exp[DEEPWID-1:0];

  assign wr_num       = wr_ptr_exp - rd_ptr_exp_cross_trans;
  assign rd_num       = wr_ptr_exp_cross_trans - rd_ptr_exp;

  assign full         = (wr_num == DEEP) | ((wr_num == DEEP - 1) & wr);
  assign empty        = (rd_num == 0) | ((rd_num == 1) & rd);
  assign almost_full  = (wr_num >= cfg_almost_full) | ((wr_num == cfg_almost_full - 1) & wr);
  assign almost_empty = (rd_num <= cfg_almost_empty) | ((rd_num == cfg_almost_empty + 1) & rd);

  //----------------------------------------------------------
  always @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) wr_ptr_exp <= {(DEEPWID + 1) {1'b0}};
    else if (wr) wr_ptr_exp <= wr_ptr_exp + {{(DEEPWID + 1) {1'b0}}, 1'b1};
  end

  always @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) rd_ptr_exp <= {(DEEPWID + 1) {1'b0}};
    else if (rd) rd_ptr_exp <= rd_ptr_exp + {{(DEEPWID + 1) {1'b0}}, 1'b1};
  end

  //----------------------------------------------------------
  always @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) begin
      wr_ptr_exp_r       <= {(DEEPWID + 1) {1'b0}};
      rd_ptr_exp_cross   <= {(DEEPWID + 1) {1'b0}};
      rd_ptr_exp_cross_r <= {(DEEPWID + 1) {1'b0}};
    end else begin
      wr_ptr_exp_r       <= graycode(wr_ptr_exp);
      rd_ptr_exp_cross   <= rd_ptr_exp_r;
      rd_ptr_exp_cross_r <= rd_ptr_exp_cross;
    end
  end

  always @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) begin
      rd_ptr_exp_r       <= {(DEEPWID + 1) {1'b0}};
      wr_ptr_exp_cross   <= {(DEEPWID + 1) {1'b0}};
      wr_ptr_exp_cross_r <= {(DEEPWID + 1) {1'b0}};
    end else begin
      rd_ptr_exp_r       <= graycode(rd_ptr_exp);
      wr_ptr_exp_cross   <= wr_ptr_exp_r;
      wr_ptr_exp_cross_r <= wr_ptr_exp_cross;
    end
  end

  assign wr_ptr_exp_cross_trans = degraycode(wr_ptr_exp_cross_r);
  assign rd_ptr_exp_cross_trans = degraycode(rd_ptr_exp_cross_r);


  //----------------------------------------------------------
  always @(posedge wr_clk or negedge wr_rst_n) begin
    if (!wr_rst_n) for (ii = 0; ii < DEEP; ii = ii + 1) my_memory[ii] <= {(BITWID) {1'b0}};
    else begin
      for (ii = 0; ii < DEEP; ii = ii + 1) begin
        if (wr & (wr_ptr == ii)) my_memory[ii] <= wr_dat;
      end
    end
  end

  always @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) rd_dat <= {BITWID{1'b0}};
    else begin
      if (rd) begin
        for (ii = 0; ii < DEEP; ii = ii + 1) begin
          if (rd_ptr == ii) rd_dat <= my_memory[ii];
        end
      end
    end
  end

  always @(posedge rd_clk or negedge rd_rst_n) begin
    if (!rd_rst_n) rd_dat_vld <= 1'b0;
    else rd_dat_vld <= rd;
  end


  //----------------------------------------------------------
  function [DEEPWID:0] graycode;
    input [DEEPWID:0] val_in;
    reg     [DEEPWID+1:0] val_in_exp;
    integer               i;

    //....................
    begin
      val_in_exp = {1'b0, val_in};

      for (i = 0; i < DEEPWID + 1; i = i + 1) graycode[i] = val_in_exp[i] ^ val_in_exp[i+1];
    end
  endfunction


  function [DEEPWID:0] degraycode;
    input [DEEPWID:0] val_in;
    reg     [DEEPWID+1:0] tmp;
    integer               i;

    //....................
    begin
      tmp = {(DEEPWID + 2) {1'b0}};

      for (i = DEEPWID; i >= 0; i = i - 1) tmp[i] = val_in[i] ^ tmp[i+1];

      degraycode = tmp[DEEPWID:0];
    end
  endfunction

endmodule

