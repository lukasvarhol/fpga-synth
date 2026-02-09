`timescale 1ns / 1ps

module sample_rate_tick_driver #(
    parameter int CLK_FREQ = 12_000_000,    // Clock frequency : 12MHz
    parameter int FS = 48_000               // Sample frequency: 48kHz
    )(
        input   logic      clk_i, n_rst_i,
        output  logic      tick_o
    );

    logic [$clog2(CLK_FREQ + FS)-1:0] counter;

    always_ff @( posedge clk_i ) begin : accumulation
        if (!n_rst_i) begin
            tick_o <= '0;
            counter <= '0;
            end
        else 
            if (counter + FS >= CLK_FREQ) begin
                tick_o <= '1;
                counter  <= counter + FS - CLK_FREQ;
                end
            else begin
                tick_o <= '0;
                counter <= counter + FS;
                end 
    end

endmodule