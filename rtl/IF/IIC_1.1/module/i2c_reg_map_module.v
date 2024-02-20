module i2c_reg_map_module #(
    parameter integer REG_NUM   = 7'd70,
    parameter integer REG_WIDTH = 8'd8
) (
    input                      i_clk,
    input                      i_rstn,
    //--
    input                      i_i2c_done,
    output reg                 o_i2c_req,
    output reg [REG_WIDTH-1:0] o_i2c_data,
    output reg                 o_init_done
);

  //reg define
  reg [6:0] init_reg_cnt;

  //*****************************************************
  //**                    main code
  //*****************************************************

  always @(posedge i_clk or negedge i_rstn) begin
    if (!i_rstn) init_reg_cnt <= 7'd0;
    else if (o_i2c_req) init_reg_cnt <= init_reg_cnt + 7'b1;
  end


  always @(posedge i_clk or negedge i_rstn) begin
    if (!i_rstn) o_i2c_req <= 1'b0;
    else if (i_i2c_done && (init_reg_cnt < REG_NUM)) o_i2c_req <= 1'b1;
    else o_i2c_req <= 1'b0;
  end

  always @(posedge i_clk or negedge i_rstn) begin
    if (!i_rstn) o_init_done <= 1'b0;
    else if ((init_reg_cnt >= REG_NUM) && i_i2c_done) o_init_done <= 1'b1;
    else o_init_done <= o_init_done;
  end

  always @(posedge i_clk or negedge i_rstn) begin
    if (!i_rstn) o_i2c_data <= 16'b0;
    else begin
      case (init_reg_cnt)
        7'd0: o_i2c_data <= {8'h12, 8'h80};
        7'd1: o_i2c_data <= {8'h3d, 8'h03};
        7'd2: o_i2c_data <= {8'h15, 8'h00};
        7'd3: o_i2c_data <= {8'h17, 8'h23};
        7'd4: o_i2c_data <= {8'h18, 8'ha0};
        7'd5: o_i2c_data <= {8'h19, 8'h07};
        7'd6: o_i2c_data <= {8'h1a, 8'hf0};
        7'd7: o_i2c_data <= {8'h32, 8'h00};
        7'd8: o_i2c_data <= {8'h29, 8'ha0};
        7'd9: o_i2c_data <= {8'h2a, 8'h00};
        7'd10: o_i2c_data <= {8'h2b, 8'h00};
        7'd11: o_i2c_data <= {8'h2c, 8'hf0};
        7'd12: o_i2c_data <= {8'h0d, 8'h41};
        7'd13: o_i2c_data <= {8'h11, 8'h00};
        7'd14: o_i2c_data <= {8'h12, 8'h06};
        7'd15: o_i2c_data <= {8'h0c, 8'h10};
        7'd16: o_i2c_data <= {8'h42, 8'h7f};
        7'd17: o_i2c_data <= {8'h4d, 8'h09};
        7'd18: o_i2c_data <= {8'h63, 8'hf0};
        7'd19: o_i2c_data <= {8'h64, 8'hff};
        7'd20: o_i2c_data <= {8'h65, 8'h00};
        7'd21: o_i2c_data <= {8'h66, 8'h00};
        7'd22: o_i2c_data <= {8'h67, 8'h00};
        7'd23: o_i2c_data <= {8'h13, 8'hff};
        7'd24: o_i2c_data <= {8'h0f, 8'hc5};
        7'd25: o_i2c_data <= {8'h14, 8'h11};
        7'd26: o_i2c_data <= {8'h22, 8'h98};
        7'd27: o_i2c_data <= {8'h23, 8'h03};
        7'd28: o_i2c_data <= {8'h24, 8'h40};
        7'd29: o_i2c_data <= {8'h25, 8'h30};
        7'd30: o_i2c_data <= {8'h26, 8'ha1};
        7'd31: o_i2c_data <= {8'h6b, 8'haa};
        7'd32: o_i2c_data <= {8'h13, 8'hff};
        7'd33: o_i2c_data <= {8'h90, 8'h0a};
        7'd34: o_i2c_data <= {8'h91, 8'h01};
        7'd35: o_i2c_data <= {8'h92, 8'h01};
        7'd36: o_i2c_data <= {8'h93, 8'h01};
        7'd37: o_i2c_data <= {8'h94, 8'h5f};
        7'd38: o_i2c_data <= {8'h95, 8'h53};
        7'd39: o_i2c_data <= {8'h96, 8'h11};
        7'd40: o_i2c_data <= {8'h97, 8'h1a};
        7'd41: o_i2c_data <= {8'h98, 8'h3d};
        7'd42: o_i2c_data <= {8'h99, 8'h5a};
        7'd43: o_i2c_data <= {8'h9a, 8'h1e};
        7'd44: o_i2c_data <= {8'h9b, 8'h3f};
        7'd45: o_i2c_data <= {8'h9c, 8'h25};
        7'd46: o_i2c_data <= {8'h9e, 8'h81};
        7'd47: o_i2c_data <= {8'ha6, 8'h06};
        7'd48: o_i2c_data <= {8'ha7, 8'h65};
        7'd49: o_i2c_data <= {8'ha8, 8'h65};
        7'd50: o_i2c_data <= {8'ha9, 8'h80};
        7'd51: o_i2c_data <= {8'haa, 8'h80};
        7'd52: o_i2c_data <= {8'h7e, 8'h0c};
        7'd53: o_i2c_data <= {8'h7f, 8'h16};
        7'd54: o_i2c_data <= {8'h80, 8'h2a};
        7'd55: o_i2c_data <= {8'h81, 8'h4e};
        7'd56: o_i2c_data <= {8'h82, 8'h61};
        7'd57: o_i2c_data <= {8'h83, 8'h6f};
        7'd58: o_i2c_data <= {8'h84, 8'h7b};
        7'd59: o_i2c_data <= {8'h85, 8'h86};
        7'd60: o_i2c_data <= {8'h86, 8'h8e};
        7'd61: o_i2c_data <= {8'h87, 8'h97};
        7'd62: o_i2c_data <= {8'h88, 8'ha4};
        7'd63: o_i2c_data <= {8'h89, 8'haf};
        7'd64: o_i2c_data <= {8'h8a, 8'hc5};
        7'd65: o_i2c_data <= {8'h8b, 8'hd7};
        7'd66: o_i2c_data <= {8'h8c, 8'he8};
        7'd67: o_i2c_data <= {8'h8d, 8'h20};
        7'd68: o_i2c_data <= {8'h0e, 8'h65};
        7'd69: o_i2c_data <= {8'h09, 8'h00};
        default: o_i2c_data <= {8'h1C, 8'h7F};
      endcase
    end
  end

endmodule
