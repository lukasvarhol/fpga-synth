from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
LUT_DIR = SCRIPT_DIR.parent / "fpga" / "luts"
LUT_DIR.mkdir(exist_ok=True)

hex_path = LUT_DIR / "wavetable_lut.hex"

with open(hex_path, "r") as f:
    lines = [ln.strip() for ln in f if ln.strip()]

num_words = len(lines)
word_bits = len(lines[0]) * 4  # hex chars * 4 bits

total_bits = num_words * word_bits
total_bytes = total_bits // 8

print("words:", num_words)
print("word_bits:", word_bits)
print("total_bytes:", total_bytes)
print("total_kb:", total_bytes / 1024)
