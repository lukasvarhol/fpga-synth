`timescale 1ns / 1ps

module band_selector #(
    parameter int NUM_BANDS = 22,
    parameter int MIDI_NOTES = 128,
    parameter int NOTES_PER_BAND = 6
    )
    (
        input logic [$clog2(MIDI_NOTES)-1:0] note,

        output logic [$clog2(NUM_BANDS)-1:0] band
    )

    always_comb begin
        band = note / NOTES_PER_BAND;
        if (band >= NUM_BANDS)
            band = NUM_BANDS - 1;
    end
endmodule