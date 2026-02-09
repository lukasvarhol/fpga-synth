`timescale 1ns / 1ps

module band_selector #(
    parameter int NUM_BANDS = 22,
    parameter int MIDI_BITS = 7,
    parameter int NOTES_PER_BAND = 6
    )
    (
        input logic [MIDI_BITS-1:0] note_i,

        output logic [$clog2(NUM_BANDS)-1:0] band_o
    );

    always_comb begin
        band_o = note_i / NOTES_PER_BAND;
        if (band_o >= NUM_BANDS)
            band_o = NUM_BANDS - 1;
    end
endmodule