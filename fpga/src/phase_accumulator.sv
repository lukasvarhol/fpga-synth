`timescale 1ns / 1ps

module phase_accumulator #(
    parameter int WORD_BITS = 32    // Phase accumulator word size : 32 bit
    )(
        input   logic                 clk, n_rst,
        input   logic                 enable,
        input   logic [WORD_BITS-1:0] phase_i,

        output  logic [WORD_BITS-1:0] phase_o 
    );

    always_ff @(posedge clk) begin : accumulation
        if (~n_rst) 
            phase_o <= '0;
        else if (enable) 
            phase_o <= phase_o + phase_i;      
    end
endmodule
