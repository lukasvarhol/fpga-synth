from pathlib import Path
import numpy as np
import math

SCRIPT_DIR = Path(__file__).resolve().parent

LUT_DIR = SCRIPT_DIR.parent / "fpga" / "luts"
LUT_DIR.mkdir(exist_ok=True)

outfile = LUT_DIR / "wavetable_lut.hex"

MIDI_RANGE = 128
NOTES_PER_BAND = 6
BANDS = np.int16(math.ceil((MIDI_RANGE/NOTES_PER_BAND)))
N_LUT = 10
FS = 48_000
AUDIO_BITS = 24
AMP_BITS = AUDIO_BITS-1

K_maximums = np.zeros(BANDS, dtype=np.int32)

notes = np.arange(MIDI_RANGE)
note_freqs = 440.0 * (2.0 ** ((notes - 69) / 12.0))

for i in range(BANDS):
    hi_note = min((i+1)*NOTES_PER_BAND - 1, MIDI_RANGE - 1)  
    K_maximums[i] = int((FS/2) // note_freqs[hi_note])

def generate_square_lut(BANDS, K_maximums, N_LUT, AMP_BITS):
    N = 1 << N_LUT
    n = np.arange(N)
    theta = 2*np.pi*n/N

    luts = []
    for i in range(BANDS):
        K = int(K_maximums[i])
        ks = np.arange(1, K+1, 2) # odd harmonics
        coeffs = 1.0 / ks                   

        x = np.sum(coeffs[:, None] * np.sin(ks[:, None] * theta[None, :]), axis=0)
        x /= np.max(np.abs(x))
        fullscale = (1 << AMP_BITS) - 1
        x *= fullscale
        x = np.round(x)
        luts.append(np.int32(x))
    return luts

def generate_saw_lut(BANDS, K_maximums, N_LUT, AMP_BITS):
    N = 1 << N_LUT
    n = np.arange(N)
    theta = 2*np.pi*n/N

    luts = []
    for i in range(BANDS):
        K = int(K_maximums[i])
        ks = np.arange(1, K+1)
        coeffs = 1.0 / ks

        x = np.sum(coeffs[:, None] * np.sin(ks[:, None] * theta[None, :]), axis=0)
        x /= np.max(np.abs(x))
        fullscale = (1 << AMP_BITS) - 1
        x *= fullscale
        x = np.round(x)
        luts.append(np.int32(x))
    return luts

def generate_triangle_lut(BANDS, K_maximums, N_LUT, AMP_BITS):
    N = 1 << N_LUT
    n = np.arange(N)
    theta = 2*np.pi*n/N

    luts = []
    for i in range(BANDS):
        K = int(K_maximums[i])
        ks = np.arange(1, K+1, 2)
        signs = (-1)**((ks-1)//2)
        coeffs = signs/(ks**2)

        x = np.sum(coeffs[:, None] * np.sin(ks[:, None] * theta[None, :]), axis=0)
        x /= np.max(np.abs(x))
        fullscale = (1 << AMP_BITS) - 1
        x *= fullscale
        x = np.round(x)
        luts.append(np.int32(x))
    return luts

def generate_sin_lut(N_LUT, AMP_BITS):
    N = 1 << N_LUT
    x = np.round(
        np.sin(2 * np.pi * np.arange(N) / N)
    ).astype(np.int32)
    fullscale = (1 << AMP_BITS) - 1
    x *= fullscale
    x = np.round(x)
    return x

from pathlib import Path

def write_luts_to_hex(luts, out_path, mode="w"):
    width_bits = AUDIO_BITS
    out_path = Path(out_path)
    mask = (1 << width_bits) - 1
    hex_digits = (width_bits + 3) // 4

    if isinstance(luts, (list, tuple)):
        bands = luts
    else:
        bands = [luts]

    with out_path.open(mode) as f:
        for band in bands:
            for v in band:
                u = int(v) & mask          # two's complement wrap
                f.write(f"{u:0{hex_digits}X}\n")



square_luts = generate_square_lut(BANDS, K_maximums, N_LUT, AMP_BITS)
saw_luts = generate_saw_lut(BANDS, K_maximums, N_LUT, AMP_BITS)
triangle_luts = generate_triangle_lut(BANDS, K_maximums, N_LUT, AMP_BITS)
sin_lut = generate_sin_lut(N_LUT, AMP_BITS)
write_luts_to_hex(square_luts, outfile, mode="w") 
write_luts_to_hex(saw_luts, outfile, mode="a")  
write_luts_to_hex(triangle_luts, outfile, mode="a")  
write_luts_to_hex(sin_lut, outfile, mode="a") 