# Improved ExtractGFX.py
import sys

FileToOpen = "Donkey Kong (U) (PRG1) [!p].nes"
FileToGen = "DKGFX.bin"

with open(FileToOpen, "rb") as f:
    h = f.read(16)
    if h[:4] != b"NES\x1a":
        raise SystemExit("Not an iNES ROM")

    prg = h[4] * 16384  # PRG ROM size in bytes
    chr_ = h[5] * 8192  # CHR ROM size in bytes

    if chr_ == 0:
        raise SystemExit("ROM has 0 CHR banks (CHR-RAM) — nothing to extract")

    f.seek(16 + prg)  # Skip header + PRG ROM
    data = f.read(chr_)  # Read CHR ROM

with open(FileToGen, "wb") as o:
    o.write(data)

print(f"Wrote {len(data)} bytes")