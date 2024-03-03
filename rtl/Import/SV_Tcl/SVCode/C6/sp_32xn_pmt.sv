//File: sp_32xn_pmt.sv
//Single port RAM using primitive RAM32X1S
module sp_32xn_pmt
#( parameter DW = 4 )
(
  input logic wclk,
  input logic we,
  input logic [4 : 0] addr,
  input logic [DW - 1 : 0] din,
  output logic [DW - 1 : 0] dout
);

  for (genvar i = 0; i < DW; i++) begin
    RAM32X1S i_ram32x1s
    (
     .WE  (we     ), 
     .WCLK(wclk   ),
     .D   (din[i] ), 
     .A0  (addr[0]),
     .A1  (addr[1]),
     .A2  (addr[2]),
     .A3  (addr[3]),
     .A4  (addr[4]),
     .O   (dout[i])
    );
  end
endmodule
