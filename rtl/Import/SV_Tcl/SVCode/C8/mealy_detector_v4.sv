//File: mealy_detector_v4.sv
module mealy_detector_v4
(
  input logic clk,
  input logic rst,
  input logic sin,
  output logic done
);

  typedef enum logic [1 : 0] {idle, got1, got10} state_t;
  state_t cs, ns;

  logic [2 : 0] mem [8];

  initial begin
    $readmemb("mealy.dat", mem);
  end

  always_ff @(posedge clk) begin
    if (rst) cs <= idle;
    else cs <= ns;
  end

  assign {done, ns} = mem[{sin, cs}];
endmodule




