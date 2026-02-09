`timescale 1ns / 1ps

module waveform_loader #(
    parameter int LUT_BITS   = 10,                     // address bits per table
    parameter int LUT_LEN    = (1 << LUT_BITS),           // samples per table
    parameter int DATA_W     = 24,
    parameter int NUM_WAVES  = 4,
    parameter int NUM_BANDS  = 22,

    // 3 band-limited waves + 1 sine table:
    parameter int NUM_TABLES = ((NUM_WAVES - 1) * NUM_BANDS) + 1,
    parameter int DEPTH      = NUM_TABLES * LUT_LEN,
    parameter string FILE    = "wavetable_lut.hex"
    )(
        input   logic                 clk_i,
        input   logic [$clog2(NUM_WAVES)-1:0]  waveform_select_i,
        input   logic [LUT_BITS-1:0] phase_i,
        input   logic [$clog2(NUM_BANDS-1):0] band_o,
        
        output  logic [DATA_W-1:0]    data
    );

    // [0 ... (1024*22)-1]              SQUARE
    // [1024*22 ... 2(1024*22)-1]       SAW
    // [2(1024*22) ... 3(1024*22)-1]    TRIANGLE
    // [3(1024*22) ... 3(1024*23)-1]    SINE

    localparam int SQUARE_BASE = 0;
    localparam int SAW_BASE = LUT_LEN * NUM_BANDS;
    localparam int TRIANGLE_BASE = 2 * (LUT_LEN* NUM_BANDS);
    localparam int SINE_BASE = 3 * (LUT_LEN * NUM_BANDS);

    localparam int ADDR_W = $clog2(DEPTH);
    logic [ADDR_W-1:0] addr;

    (* ram_style = "block" *)
    logic signed [DATA_W-1:0] rom [0:DEPTH-1];

    always_comb begin
        case (waveform_select_i)
            2'd0: addr = SQUARE_BASE + (band_o * LUT_LEN) + phase_i;
            2'd1: addr = SAW_BASE + (band_o * LUT_LEN) + phase_i;
            2'd2: addr = TRIANGLE_BASE + (band_o * LUT_LEN) + phase_i;
            default: addr = SINE_BASE + phase_i;
        endcase
    end

    always_ff @(posedge clk_i) begin
        data <= rom[addr];
    end

endmodule