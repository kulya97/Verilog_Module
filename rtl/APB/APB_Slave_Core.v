module APB_Slave_Core #(
    parameter ADDR_WITDH = 24,
    parameter DATA_WITDH = 32

) (
    input                         PCLK,
    input                         PRESETn,
    //
    input      [  ADDR_WITDH-1:0] PADDR,
    input                         PSELx,
    input                         PENABLE,
    //
    input                         PWRITE,
    input      [  DATA_WITDH-1:0] PWDATA,
    //
    input      [             2:0] PPROT,    //APB4 sign unused  000
    input      [DATA_WITDH/8-1:0] PSTRB,    //APB3 sign 
    //
    output                        PREADY,   //APB3 sign
    output reg [  DATA_WITDH-1:0] PRDATA,
    //
    output                        PSLVERR,  //APB3 sign unused

    input  uart_rx,
    output uart_tx
);



  parameter REG1_ADDR = 32'h43C0_0000;
  parameter REG2_ADDR = 32'h43C0_0004;
  parameter REG3_ADDR = 32'h43C0_0008;
  parameter REG4_ADDR = 32'h43C0_000c;

  reg  [DATA_WITDH-1:0] r_reg1;
  reg  [DATA_WITDH-1:0] r_reg2;
  reg  [DATA_WITDH-1:0] r_reg3;
  reg  [DATA_WITDH-1:0] r_reg4;  //only read
  reg  [DATA_WITDH-1:0] r_invld_reg;

  wire                  w_apb_write_vld;
  wire                  w_apb_read_vld;
  reg                   r_writedata_vld;
  reg                   r_readdata_vld;

  wire [          63:0] uart_rx_data;
  wire                  uart_rx_valid;
  /*******************************************/
  assign PREADY          = 1'b1;
  //   assign PPROT           = 3'b000;
  //   assign PSTRB           = PWRITE ? 4'b0000 : 4'b1111;
  assign PSLVERR         = 1'b0;

  assign w_apb_write_vld = PWRITE && PSELx && PENABLE;
  assign w_apb_read_vld  = (!PWRITE) && PSELx && PENABLE;

  always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      r_reg1          <= 32'd0;
      r_reg2          <= 32'd0;
      r_reg3          <= 32'd0;
      r_writedata_vld <= 1'b0;
    end else if (w_apb_write_vld) begin
      case (PADDR[ADDR_WITDH-1:0])
        REG1_ADDR: begin
          r_reg1          <= PWDATA;
          r_writedata_vld <= 1'b1;
        end
        REG2_ADDR: begin
          r_reg2          <= PWDATA;
          r_writedata_vld <= 1'b1;
        end
        REG3_ADDR: begin
          r_reg3          <= PWDATA;
          r_writedata_vld <= 1'b1;
        end
        default: begin
          r_invld_reg     <= PWDATA;
          r_writedata_vld <= 1'b0;
        end
      endcase
    end
  end
  always @(*) begin
    if (w_apb_read_vld) begin
      case (PADDR[ADDR_WITDH-1:0])
        REG1_ADDR: begin
          PRDATA         <= r_reg1;
          r_readdata_vld <= 1'b1;
        end
        REG2_ADDR: begin
          PRDATA         <= r_reg2;
          r_readdata_vld <= 1'b1;
        end
        REG3_ADDR: begin
          PRDATA         <= r_reg3;
          r_readdata_vld <= 1'b1;
        end
        REG4_ADDR: begin
          PRDATA         <= uart_rx_data[31:0];
          r_readdata_vld <= 1'b1;
        end
        default: begin
          PRDATA         <= r_invld_reg;
          r_readdata_vld <= 1'b0;
        end
      endcase
    end else begin
      PRDATA         <= 32'd0;
      r_readdata_vld <= 1'b0;
    end
  end

  wire [63:0] uart_tx_reg;
  assign uart_tx_reg = {REG1_ADDR, r_reg1};
  uart_reg_tx_module_0 your_instance_name (
      .clk          (PCLK),             // input wire clk
      .rst_n        (PRESETn),          // input wire rst_n
      .uart_tx_port (uart_tx),          // output wire uart_tx_port
      .uart_tx_reg  (uart_tx_reg),      // input wire [63 : 0] uart_tx_reg
      .uart_tx_valid(r_writedata_vld),  // input wire uart_tx_valid
      .uart_tx_ready()                  // output wire uart_tx_ready
  );

  uart_reg_rx_module_0 your_instance_name2 (
      .clk          (PCLK),          // input wire clk
      .rst_n        (PRESETn),       // input wire rst_n
      .uart_rx_port (uart_rx),       // input wire uart_rx_port
      .uart_rx_data (uart_rx_data),  // output wire [63 : 0] uart_rx_data
      .uart_rx_ready(1),             // input wire uart_rx_ready
      .uart_rx_valid(uart_rx_valid)  // output wire uart_rx_valid
  );
endmodule
