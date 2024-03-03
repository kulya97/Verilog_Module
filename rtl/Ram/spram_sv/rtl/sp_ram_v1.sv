//File: sp_ram_v1.sv
module sp_ram_v1 #(
    parameter AW            = 10,
    parameter DW            = 18,
    parameter WRITE_MODE    = "no_change",
    parameter RAM_STYLE_VAL = "block"
) (
    input  logic              clk,
    input  logic              we,
    input  logic [AW - 1 : 0] addr,
    input  logic [DW - 1 : 0] din,
    output logic [DW - 1 : 0] dout
);

  localparam DEPTH = 2 ** AW;

  (* RAM_STYLE = RAM_STYLE_VAL *)
  logic [DW - 1 : 0] mem     [DEPTH] = '{default: '0};
  logic              we_d1;
  logic [AW - 1 : 0] addr_d1;
  logic [DW - 1 : 0] din_d1;

  always_ff @(posedge clk) begin
    we_d1   <= we;
    addr_d1 <= addr;
    din_d1  <= din;
  end

  case (WRITE_MODE)
    "read_first": begin
      always_ff @(posedge clk) begin
        if (we_d1) begin
          mem[addr_d1] <= din_d1;
        end
        dout <= mem[addr_d1];
      end
    end
    "write_first": begin
      always_ff @(posedge clk) begin
        if (we_d1) begin
          mem[addr_d1] <= din_d1;
          dout         <= din_d1;
        end else begin
          dout <= mem[addr_d1];
        end
      end
    end
    "no_change": begin
      always_ff @(posedge clk) begin
        if (we_d1) begin
          mem[addr_d1] <= din_d1;
        end else begin
          dout <= mem[addr_d1];
        end
      end
    end
  endcase
endmodule




