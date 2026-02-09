`timescale 1ns / 1ps

module rom #(
    parameter int ADDR_W = 7,         // 128 entries
    parameter int DATA_W = 32 ,       // 32 bit values
    parameter string FILE = "phaseacc.hex" // Look-up Table file
    )(
        input   logic                 clk_i,
        input   logic [ADDR_W-1:0]    addr_i,
        
        output  logic [DATA_W-1:0]    data_o
    );

    (* ram_style = "distributed" *)
    logic [DATA_W-1:0] rom [0:(1<<ADDR_W)-1];

  initial begin
    $readmemh(FILE, rom);
  end

  always_ff @(posedge clk_i) begin
    data_o <= rom[addr_i];
  end
endmodule
