//File: sp_ram.sv
module sp_ram
#(
  parameter AW             = 10,
  parameter DW             = 18,
  parameter WRITE_MODE     = "write_first",
  parameter RAM_STYLE_VAL  = "block",
  parameter LATENCY        = 1
)
(
  input logic clk,
  input logic we,
  input logic [AW - 1 : 0] addr,
  input logic [DW - 1 : 0] din,
  output logic [DW - 1 : 0] dout
);

  localparam DEPTH = 2 ** AW;

  (* RAM_STYLE = RAM_STYLE_VAL *)
  logic [DW - 1 : 0] mem [DEPTH] = '{default : '0};
  logic we_d1;
  logic [AW - 1 : 0] addr_d1;
  logic [DW - 1 : 0] din_d1;
  logic [DW - 1 : 0] dout_temp;

  always_ff @(posedge clk) begin
    we_d1   <= we;
    addr_d1 <= addr;
    din_d1  <= din;
  end

  always_ff @(posedge clk) begin
    if (we_d1)
      mem[addr_d1] <= din_d1;
  end

  case (WRITE_MODE)
    "read_first": 
    begin
      case (LATENCY)
        1: begin
             always_comb begin
               dout = mem[addr_d1];
             end
           end
        2: begin
             always_ff @(posedge clk) begin
               dout <= mem[addr_d1];
             end
           end
        3: begin
             always_ff @(posedge clk) begin
               dout_temp <= mem[addr_d1];
               dout <= dout_temp;
             end
           end
      endcase
    end

    "write_first":
    begin
      case (LATENCY)
        1: begin
             always_comb begin
               if (we_d1)
                 dout = din_d1;
               else
                 dout = mem[addr_d1];
             end
           end
        2: begin
             always_ff @(posedge clk) begin
               if (we_d1)
                 dout <= din_d1;
               else
                 dout <= mem[addr_d1];
             end
           end
        3: begin
             always_ff @(posedge clk) begin
               if (we_d1) begin
                 dout_temp <= din_d1;
                 dout      <= dout_temp;
               end
               else begin
                 dout_temp <= mem[addr_d1];
                 dout      <= dout_temp;
               end
             end
           end
      endcase
    end

    "no_change":
    begin
      case (LATENCY)
        1: begin
             always_latch begin
               if (we_d1 == '0)
                 dout = mem[addr_d1];
             end
           end
        2: begin
             always_ff @(posedge clk) begin
               if (we_d1 == '0)
                 dout <= mem[addr_d1];
             end
           end
        3: begin
             always_ff @(posedge clk) begin
               if (we_d1 == '0) begin
                 dout_temp <= mem[addr_d1];
                 dout      <= dout_temp;
               end
             end
           end
      endcase
    end
  endcase
endmodule








          
