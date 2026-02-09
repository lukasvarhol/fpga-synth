`timescale 1ns / 1ps

module nco #(
        parameter CLK_FREQ = 12_000_000,
        parameter FS = 48_000,
        parameter MIDI_BITS = 7,
        parameter WORD_BITS = 32,
        parameter NUM_BANDS = 22,
        parameter NOTES_PER_BAND = 6,
        parameter NUM_WAVES = 4,
        parameter LUT_BITS = 10,
        parameter AUDIO_BITS = 24,
    )
    (
        input wire clk_i, n_rst_i,
        input wire [MIDI_BITS-1:0] midi_note_i,

        output wire [AUDIO_BITS-1:0] audio_o
    );

    reg [WORD_BITS-1:0] phase_accumulation;
    reg [WORD_BITS-1:0] phase_value;

    reg [$clog2[NUM_BANDS]-1:0] band;
    wire tick;

    sample_rate_tick_driver #(
        .CLK_FREQ(CLK_FREQ),
        .FS(FS)
    ) u_sample_rate_tick_driver (
        .clk_i(clk_i),
        .n_rst_i(n_rst_i),
        .tick_o(tick)
    )

    rom #(
        .ADDR_W(MIDI_BITS),         
        .DATA_W(WORD_BITS),     
        .FILE("phaseacc.hex") 
    ) phase_values_rom (
        clk_i(clk_i),
        addr_i(midi_note),
        data_o(phase_value),
    )

    phase_accumulator #(
        .WORD_BITS(WORD_BITS)
    ) u_phase_accumulator (
        .clk_i(clk_i),
        .n_rst_i(n_rst_i),
        .enable_i(tick),
        .phase_i(phase_value),
        .phase_o(phase_accumulation)
    );

    band_selector #(
        .NUM_BANDS(NUM_BANDS),
        .MIDI_BITS(MIDI_BITS),
        .NOTES_PER_BAND(NOTES_PER_BAND)
    ) u_band_selector (
        .note_i(midi_note),
        .band_o(band)
    );

    waveform_loader #(
        .LUT_BITS(LUT_BITS),                     
        .LUT_LEN(1 << LUT_BITS),           
        .DATA_W(AUDIO_BITS),
        .NUM_WAVES(NUM_WAVES),
        .NUM_BANDS(NUM_BANDS),
        .NUM_TABLES(((NUM_WAVES - 1) * NUM_BANDS) + 1),
        .DEPTH(NUM_TABLES * (1 << LUT_BITS)),
        .FILE("wavetable_lut.hex")
    ) u_waveform_loader #(
        .clk_i(clk_i),
        .waveform_select_i(),
        .phase_i(phase_accumulation[WORD_BITS-1:(WORD_BITS-LUT_BITS)]),
        .band_i(band),
        .data_o(audio_o)
    )

    // TODO: 
    // - fractional lerp with remaining phase_accumulation bits
    // - morphing lerp between waveforms (introduce new input signal)
    // - lerp crossfade between tables
    
endmodule