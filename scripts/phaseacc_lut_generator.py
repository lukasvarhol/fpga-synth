from pathlib import Path
import numpy as np

SCRIPT_DIR = Path(__file__).resolve().parent

LUT_DIR = SCRIPT_DIR.parent / "fpga" / "luts"
LUT_DIR.mkdir(exist_ok=True)

outfile = LUT_DIR / "phaseacc.hex"

FS = 48_000
N_PA = 32
A4 = 69
A4_FREQ = 440.0
MIDI_RANGE = 128

with open(outfile, "w") as f:
    for note in range(128):
        note_freq = A4_FREQ * (2.0 ** ((note - A4) / 12))
        phase_inc = int((note_freq * (1 << N_PA)) / FS)
        f.write(f"{phase_inc:08X}\n")

print(f"Wrote {outfile}")