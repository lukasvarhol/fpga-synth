# FPGA Audio Synth (Work in Progress)

This project is an **FPGA-based digital audio synthesizer** built from first principles, starting with a software reference model and gradually moving toward a full hardware implementation.

The current focus is on **wavetable synthesis**, **numerically controlled oscillators (NCOs)**, and **smooth waveform morphing**, developed and validated in Python before being translated to HDL.

---

## Project Goals

- Design a clean, modular **digital oscillator core** suitable for FPGA implementation
- Explore **band-limited wavetable synthesis** to avoid aliasing
- Implement **smooth waveform morphing** (single control morphing across multiple waveforms)
- Develop a **software reference model** that exactly mirrors intended hardware behavior
- Eventually interface the FPGA with external control (e.g. Raspberry Pi) and a DAC

---

## Current Features

### Numerically Controlled Oscillator (NCO)

- Fixed-point phase accumulator
- Frequency control via tuning word (`M`)
- MIDI note to frequency mapping
- Sample-rate–accurate waveform generation

### Wavetable Synthesis

- Precomputed lookup tables (LUTs)
- Power-of-two LUT sizes
- Phase-indexed table lookup
- Linear interpolation between LUT samples

### Band-Limited Wavetables

- Multiple tables per waveform
- Tables selected by pitch band (e.g. grouped MIDI notes)
- Prevents high-frequency aliasing

### Waveform Morphing

- Single morph parameter smoothly interpolates:
  - within a waveform (phase interpolation)
  - between adjacent waveforms (crossfading)

- Morph control spans _all_ available waveforms continuously
- Designed to map cleanly to fixed-point FPGA logic

### Interactive Visualization (Python / Jupyter)

- `ipywidgets` slider to control morph parameter
- Live plotting of output waveform
- Useful for debugging, listening tests, and design validation

---

## Repository Structure (So Far)

```
/ (root)
│
├─ notebooks/
│   └─ nco.ipynb              # NCO derivation and testing
│
└─ README.md
```

(Structure is evolving.)

---

## Key Parameters

| Parameter | Description                     |
| --------- | ------------------------------- |
| `FS`      | Audio sample rate (e.g. 48 kHz) |
| `N_PA`    | Phase accumulator bit width     |
| `N_LUT`   | LUT address bits                |
| `N_FRAC`  | Fractional interpolation bits   |
| `M`       | Tuning word for NCO             |

All arithmetic is designed to be **FPGA-friendly** (fixed-point, shifts, masks).

---

## Next Steps

Planned near-term work:

- ADSR envelope generator
- Click-free note on/off handling
- Audio output playback tests
- Fixed-point range and overflow analysis
- HDL implementation of NCO + wavetable core
- DAC selection and output stage

Longer-term:

- Polyphony
- Modulation sources (LFOs, envelopes)
- Control interface (SPI / UART from Raspberry Pi)
- Full FPGA synth voice

---

## Status

Core DSP concepts are implemented and behaving correctly in software. The project is transitioning from exploratory prototyping toward hardware-oriented design decisions.

---

_This README will evolve as the project matures._
