`timescale 1ns / 1ps

module sample_rate_tick_driver #(
    parameter int CLK_FREQ = 100000000,    // Clock frequency : 100MHz
    parameter int FS = 48000               // Sample frequency: 48kHz
    )(
        input   logic      clk, n_rst,
        output  logic      tick
    );

    logic [$clog2(CLK_FREQ + FS)-1:0] counter;

    always_ff @( posedge clk ) begin : accumulation
        if (!n_rst) begin
            tick <= '0;
            counter <= '0;
            end
        else 
            if (counter + FS >= CLK_FREQ) begin
                tick <= '1;
                counter  <= counter + FS - CLK_FREQ;
                end
            else begin
                tick <= '0;
                counter <= counter + FS;
                end 
    end

endmodule