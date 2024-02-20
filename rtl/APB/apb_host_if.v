module apb_host_if
#(
    parameter   APB_ABIT = 16,
    parameter   APB_DBIT = 32
)
(
    input                       aclk                ,        
    input                       areset_n            ,   
    input                       cclk                ,        
    input                       creset_n            ,   

    input                       i_apb_psel          ,     
    input                       i_apb_penable       ,     
    input       [3:0]           i_apb_pstrb         ,
    input                       i_apb_pwrite        ,      
    input       [APB_ABIT-1:0]  i_apb_paddr         ,       
    input       [APB_DBIT-1:0]  i_apb_pwdata        ,      
    input                       apb_bus_width       ,
    input                       apb_pready_isp      ,
    input       [APB_DBIT-1:0]  apb_prdata_isp      ,
                                    
    output wire                 o_apb_pready        ,      
    output wire [APB_DBIT-1:0]  o_apb_prdata        
);

reg                 apb_psel    ;
reg                 apb_penable;                                               
reg [3:0]           apb_pstrb  ;
reg                 apb_pwrite ;       
reg [APB_ABIT-1:0]  apb_paddr  ;
reg [APB_DBIT-1:0]  apb_pwdata ;
always @(negedge areset_n or posedge aclk) begin                    
    if(~areset_n) begin                                              
        apb_psel    <= 0;
        apb_penable <= 0;                                            
        apb_pstrb   <= 0;
        apb_pwrite  <= 0;                                            
        apb_paddr   <= 0;
        apb_pwdata  <= 0;
    end                                                              
    else begin                                                       
        apb_psel    <= i_apb_psel   ;
        apb_penable <= i_apb_penable;                                   
        apb_pstrb   <= i_apb_pstrb  ;
        apb_pwrite  <= i_apb_pwrite ;                                          
        apb_paddr   <= i_apb_paddr  ;
        apb_pwdata  <= i_apb_pwdata ;
    end                                                              
end   

reg [2:0]   arstate;
reg [2:0]   next_arstate;
reg [4:0]   maincnt;

wire        apb_miss_addr;

localparam AR_IDLE      = 0;
localparam AR_OP_STT    = 1;
localparam AR_R_RDY     = 2;    // read
localparam AR_S_RDY     = 3;    // send ready
localparam AR_DONE      = 4;
localparam AR_UNDEFINED = 7;

always @(*) begin
    next_arstate = AR_UNDEFINED;
    case (arstate)
        AR_IDLE :
            if (apb_psel)
                next_arstate = AR_OP_STT;

        AR_OP_STT :
            if (apb_penable)
                next_arstate = apb_pwrite ? AR_S_RDY : AR_R_RDY;
            else if(~apb_psel)
                next_arstate = AR_IDLE;

        AR_R_RDY :
            if (apb_miss_addr | apb_pready_isp)
                next_arstate = AR_S_RDY;

        AR_S_RDY :
            next_arstate = AR_DONE;

        AR_DONE :
            next_arstate = AR_IDLE;

    endcase
end

wire ar_r_rdy = (arstate == AR_R_RDY);
wire ar_s_rdy = (arstate == AR_S_RDY);

wire change_arstate = (next_arstate != AR_UNDEFINED);
always @(posedge aclk, negedge areset_n) begin
    if (~areset_n)              arstate <= AR_IDLE;
    else if (change_arstate)    arstate <= next_arstate;
end

localparam APB_MISS_ADDR_FIRE_NUM = 8;
assign apb_miss_addr = (maincnt == (APB_MISS_ADDR_FIRE_NUM - 1)) & ar_r_rdy;

always @(posedge aclk, negedge areset_n) begin
    if (~areset_n)  maincnt <= 0;
    else begin
        case (arstate)
            AR_IDLE :
                if (change_arstate)
                    maincnt <= 0;

            AR_R_RDY :
                if (change_arstate)
                    maincnt <= 0;
                else
                    maincnt <= maincnt + 1;
        endcase
    end
end

reg [APB_DBIT-1:0]  apb_prdata_d1;
always @(posedge aclk, negedge areset_n) begin
    if (~areset_n)              apb_prdata_d1 <= 0;
    else if (apb_pready_isp)    apb_prdata_d1 <= apb_prdata_isp;
end

assign o_apb_pready = ar_s_rdy;
`ifdef RTL_SIM
assign o_apb_prdata = ar_s_rdy ? apb_prdata_d1 : 32'h0;
`else
assign o_apb_prdata = apb_prdata_d1;
`endif

endmodule
