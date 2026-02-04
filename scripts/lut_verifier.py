import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
LUT_DIR = SCRIPT_DIR.parent / "fpga" / "luts"
LUT_DIR.mkdir(exist_ok=True)

file_path = LUT_DIR / "wavetable_lut.hex"

tokens = file_path.read_text().split()

# infer width from max hex digits (e.g. 4 digits => 16 bits)
hex_digits = max(len(t.lstrip("0x").lstrip("0X")) for t in tokens)
WIDTH_BITS = hex_digits * 4

SIGN_BIT = 1 << (WIDTH_BITS - 1)
MASK = (1 << WIDTH_BITS) - 1

values = []
for token in tokens:
    u = int(token, 16) & MASK
    s = u - (1 << WIDTH_BITS) if (u & SIGN_BIT) else u
    values.append(s)

plt.figure()
plt.plot(values)
plt.xlabel("Index")
plt.ylabel("Value (signed)")
plt.title(f"Wavetable LUT (two's complement decoded, {WIDTH_BITS}-bit)")
plt.grid(True)
plt.show()
