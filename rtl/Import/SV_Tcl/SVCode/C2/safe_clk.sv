//File: safe_clk.sv
module safe_clk
#(
  parameter DELAY_NUM = 4
)
(
  (* CLOCK_BUFFER_TYPE = "NONE" *) 
  input logic clk,
  input logic rst,
  output logic sys_clk
);

  (* ASYNC_REG = "TRUE" *)
  logic [DELAY_NUM - 1 : 0] cdly = '0;

  always_ff @(posedge clk, posedge rst) begin
    if (rst) 
      cdly <= '0;
    else
      cdly <= {cdly[DELAY_NUM - 2 : 0], 1'b1};
  end

  BUFGCE 
  #(
    .CE_TYPE("SYNC"),          // ASYNC, HARDSYNC, SYNC
    .IS_CE_INVERTED(1'b0),     // Programmable inversion on CE
    .IS_I_INVERTED(1'b0),      // Programmable inversion on I
    .SIM_DEVICE("ULTRASCALE")  // ULTRASCALE
  )
  BUFGCE_inst 
  (
      .O(sys_clk),   
      .CE(cdly[DELAY_NUM - 1]),
      .I(clk)    
  );
endmodule



