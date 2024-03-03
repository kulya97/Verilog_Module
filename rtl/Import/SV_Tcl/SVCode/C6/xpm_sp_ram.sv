// ECC_MODE
// |   "no_ecc" - Disables ECC       
// |   "encode_only" - Enables ECC Encoder only
// |   "decode_only" - Enables ECC Decoder only
// |   "both_encode_and_decode"
// MEM_PRIMITIVE
// |   "auto"- Allow Vivado Synthesis to choose
// |   "distributed"- Distributed memory      
// |   "block"- Block memory                 
// |   "ultra"- Ultra RAM memory    
// WRITE_MODE_A         
// read_first, no_change, write_first. Default value = read_first.

module xpm_sp_ram 
#(
  parameter AW = 3,
  parameter DW = 4,
  parameter CASCADE_HEIGHT = 8,
  parameter ECC_MODE = "no_ecc", 
  parameter MEMORY_INIT_FILE = "sp_ram_8x4.mem",
  parameter MEMORY_PRIMITIVE = "distributed",
  parameter READ_LATENCY_A = 3,
  parameter WRITE_MODE_A = "read_first"
)
(
  input logic clka,
  input logic rsta,
  input logic [AW - 1 : 0] addra,
  input logic [DW - 1 : 0] dina,
  input logic ena,
  input logic wea,
  input logic regcea,
  output logic [DW - 1 : 0] douta
);

  localparam MEMORY_DEPTH = 2 ** AW;
  localparam MEMORY_SIZE  = MEMORY_DEPTH * DW;
  xpm_memory_spram 
  #(
    .ADDR_WIDTH_A(AW),                   
    .AUTO_SLEEP_TIME(0),                 
    .BYTE_WRITE_WIDTH_A(DW),             
    .CASCADE_HEIGHT(CASCADE_HEIGHT),     
    .ECC_MODE(ECC_MODE),                 
    .MEMORY_INIT_FILE(MEMORY_INIT_FILE), 
    .MEMORY_INIT_PARAM(""),              
    .MEMORY_OPTIMIZATION("true"),        
    .MEMORY_PRIMITIVE("auto"),           
    .MEMORY_SIZE(MEMORY_SIZE),           
    .MESSAGE_CONTROL(0),                 
    .READ_DATA_WIDTH_A(DW),              
    .READ_LATENCY_A(READ_LATENCY_A),     
    .READ_RESET_VALUE_A("0"),            
    .RST_MODE_A("SYNC"),                 
    .SIM_ASSERT_CHK(0),                 
    .USE_MEM_INIT(0),                    
    .WAKEUP_TIME("disable_sleep"),       
    .WRITE_DATA_WIDTH_A(DW),             
    .WRITE_MODE_A(WRITE_MODE_A)          
  )
  xpm_memory_spram_inst 
  (
   .dbiterra(),   
   .douta(douta),     
   .sbiterra(),       
   .addra(addra),     
   .clka(clka),       
   .dina(dina),       
   .ena(ena),         
   .injectdbiterra(), 
   .injectsbiterra(), 
   .regcea(regcea),   
   .rsta(rsta),       
   .sleep('1),        
   .wea(wea)          
  );
endmodule

