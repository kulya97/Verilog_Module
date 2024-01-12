

module IIC_Slave_Top (
    input        I_clk,
    input        I_rstn,
    
    input        I_wvalid,
    output       O_wready,
    input  [7:0] I_wdata,

    output       O_rvalid,
    input        I_rready,
    output [7:0] O_rdata,

    inout IIC_SDA,
    input IIC_SCL
);
endmodule
