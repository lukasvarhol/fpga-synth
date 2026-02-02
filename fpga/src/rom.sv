`timescale 1ns / 1ps

module rom #(
    parameter int ADDR_W = 7,         // 128 entries
    parameter int DATA_W = 32 ,       // 32 bit values
    parameter string FILE = "lut.hex" // Look-up Table file
    )(
        input   logic                 clk,
        input   logic [ADDR_W-1:0]    addr,
        
        output  logic [DATA_W-1:0]    data
    );
    
    (* ram_style = "distributed" *)
    logic [DATA_W-1:0] rom [0:(1<<ADDR_W)-1];

  initial begin
    $readmemh(FILE, rom);
  end

  always_ff @(posedge clk) begin
    data <= rom[addr];
  end
endmodule
