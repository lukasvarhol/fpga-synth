`timescale 1ns / 1ps

module phase_accumulator #(
    parameter int WORD_BITS = 32    // Phase accumulator word size : 32 bit
    )(
        input   logic                 clk_i, n_rst_i,
        input   logic                 enable_i,
        input   logic [WORD_BITS-1:0] phase_i,

        output  logic [WORD_BITS-1:0] phase_o 
    );

    always_ff @(posedge clk_i) begin : accumulation
        if (~n_rst_i) 
            phase_o <= '0;
        else if (enable) 
            phase_o <= phase_o + phase_i;  // Phase will automatically wrap    
    end
endmodule
