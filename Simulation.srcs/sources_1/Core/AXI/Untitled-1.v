module axi ();
  // localparam Sidle,Swstart,Swtrans,Swend,Srstart,Srtrans,Srend;
  // reg wcurrent_state,wnext_state;
  // reg rcurrent_state,rnext_state;
  wire M_AXI_ACLK;
  wire wstart;
  /*************写地址*************************/
  always @(posedge M_AXI_ACLK) begin
    if (wstart) awvalid = 1;
    else if (awvalid && awready) awvalid = 0;
    else awvalid = awvalid;
  end
  always @(posedge M_AXI_ACLK)
    if (rst) waddress = 0;
    else if (wstart) waddress = xxx;
    else waddress = waddress;
  // /*************写数据*************************/

  // always@(posedge M_AXI_ACLK)
  // if(rst)
  // wvalid=0;
  // else if(awvalid&&awready)
  // wvalid=1;
  // else
  // wvalid=wvalid;

  // always@(posedge M_AXI_ACLK)
  // if(rst||wlast)
  // wdata=0
  // else if(wvalid&&wready)
  // wdata=wdata+1;
  // else
  // wdata=wdata;

  // //写数据计数器
  // always@(posedge M_AXI_ACLK)
  // if(rst)
  // wcnt=0
  // else if(wvalid&&wready)
  // wcnt=wcnt+1;
  // else
  // wcnt=0;
  // //写结束
  // always@(posedge M_AXI_ACLK)
  //  if(wvalid&&wreafy&&wcnt==brust_len-1)
  // wlast=1;
  // else
  // wlast=0;

  // /*************读地址*************************/
  // always@(posedge M_AXI_ACLK)
  // if(rst)
  // arvaild=0;
  // esle if(arstart)
  // arvaild=1;
  // else if(arvaild&&arready)
  // arvaild=0;
  // else
  // arvaild=arvaild;

  // always@(posedge M_AXI_ACLK)
  // if(rst)
  // raddress=0;
  // else if(arstart)
  // raddress=xxx;
  // else 
  // raddress=raddress;
  // /*************读数据*************************/

  // always@(posedge M_AXI_ACLK)
  // if(rst)
  // rready=0;
  // else if(arvaild&&arready)
  // rready=1;
  // else 
  // rready=rready;
  // //存储数据
  // always@(posedge M_AXI_ACLK)
  // if(rst)
  // rdata=0;
  // else if(rvaild&&rready)
  // rdata=data_in;
  // else 
  // rdata=rdata;

  // //读启动
  // always@(posedge M_AXI_ACLK)
  //  if(rcurrent_state==Srstart)
  // rstart=1;
  // else
  // rstart=0;
  // /*************状态机*************************/

  // always@(posedge M_AXI_ACLK)
  // if wcurrent_state=Sidle;
  // else wcurrent_state=rnext_state;

  // always@(*)
  // case(wcurrent_state)
  // Sidle:wnext_state=Swstart;
  // Swstart:wnext_state=rstart?Swtrans:Swstart;
  // Swtrans:wnext_state=wlast?Swend:Swtrans;
  // Swend:wnext_state=Sidle;
  // endcase

  // always@(posedge M_AXI_ACLK)
  // if rcurrent_state=Sidle;
  // else rcurrent_state=rnext_state;

  // always@(*)
  // case(rcurrent_state)
  // Sidle:rnext_state=
  // Srstart:rnext_state=
  // Srtrans:rnext_state=
  // Srend:rnext_state=
  // endcase
endmodule
