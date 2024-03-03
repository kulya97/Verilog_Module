module serial_to_parallel
(
   input  logic clk,
   input  logic rst_n,

   input  logic serial_i,
   input  logic valid_i,

   output logic [7:0]  parallel_o,
   output logic        valid_o
);
// 8 flip flop used as registers
logic [7:0] shift_reg_8;
// 3flip flops used as counter
logic [2:0] count;
// 2 flip flop used for the edge detector
logic valid_int, valid_int_Q;


// DATAPATH (used to drive properly parallel_o)
always_ff @(posedge clk or negedge rst_n)
begin : proc_DATA_PATH
   if(~rst_n) begin
       shift_reg_8 <= '0;
   end
   else
   begin
      if(valid_i)
         shift_reg_8[7:0] <= {serial_i,shift_reg_8[7:1]};
   end
end
assign parallel_o = shift_reg_8;




// Controller (used to drive properly valid_o)
always_ff @(posedge clk or negedge rst_n)
begin : proc_CONTROL
   if(~rst_n)
   begin
      count <= 0;
      valid_int   <= 1'b0;
      valid_int_Q <= 1'b0;
   end
   else
   begin
      valid_int_Q <= valid_int;

      if(valid_i)
      begin
        count <= count + 1'b1;
        if(count == '1)
          valid_int <= 1'b1;
        else
          valid_int <= 1'b0;
      end
   end
end

assign valid_o = valid_int & ~valid_int_Q;



endmodule // serial_to_parall
