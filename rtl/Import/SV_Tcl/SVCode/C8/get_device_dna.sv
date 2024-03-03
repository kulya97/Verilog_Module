//File: get_device_dna.sv
module get_device_dna 
#(
  parameter SIM_DNA_VALUE = 66
)
(
  input logic clk,
  input logic rst,
  output logic [95 : 0] dna
);

  localparam CNT_MAX = 95;
  logic dna_so;
  logic read;
  logic shift;
  logic [6 : 0] cnt;
  logic [6 : 0] cnt_d1;
  logic [95 : 0] dna_i;

  typedef enum logic [2 : 0] {idle, read_dna, shift_dna, shift_done, write_dna} states_t;
  states_t cs, ns;
  
  DNA_PORTE2 
  #(
    .SIM_DNA_VALUE(SIM_DNA_VALUE)
  )
  i_DNA_PORTE2 (
  .DOUT(dna_so), 
  .CLK(clk), 
  .DIN('0), 
  .READ(read),
  .SHIFT(shift) 
  );
  
  always_ff @(posedge clk) begin
    if (rst) cs <= idle;
    else cs <= ns;
  end
  
  always_comb begin
    ns = cs;
    case (cs)
      idle       : ns = read_dna;
      read_dna   : ns = shift_dna;
      shift_dna  : if (cnt == CNT_MAX) ns = shift_done;
      shift_done : ns = write_dna;
      write_dna  : ns = idle;
      default    : ns = idle;
    endcase
  end
  
  always_ff @(posedge clk) begin
    case (cs)
      idle, shift_done, write_dna: 
        begin
          cnt <= '0;
          read <= '0;
          shift <= '0;
        end
      read_dna: 
        begin
          cnt <= '0;
          read <= '1;
          shift <= '0;
        end
      shift_dna:
        begin
          cnt <= cnt + 1;
          read <= '0;
          shift <= '1;
        end
      default:
        begin
          cnt <= '0;
          read <= '0;
          shift <= '0;
        end
    endcase
  end
                  
  always_ff @(posedge clk) begin
    cnt_d1 <= cnt;
  end
  
  for(genvar i = 0; i <= CNT_MAX; i++) begin
    always_ff @(posedge clk) begin
      if (cnt_d1 == i)
        dna_i[i] <= dna_so;
    end
  end
  
  always_ff @(posedge clk) begin
    if (cs == write_dna)
      dna <= dna_i;
  end
endmodule  
  
  
  
  
