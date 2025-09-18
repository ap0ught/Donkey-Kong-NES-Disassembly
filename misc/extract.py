# pip install kaitaistruct
import ines
from kaitaistruct import KaitaiStream

with open("DonkeyKong.nes", "rb") as f:
    data = f.read()

rom = Ines.from_bytes(data)  # generated class
chr_size = rom.header.chr_rom_size * 8192
assert chr_size == 8192, f"Expected 8 KB CHR, got {chr_size} bytes"

# CHR starts after 16-byte header + PRG area
off = 16 + rom.header.prg_rom_size * 16384
chr_blob = data[off : off + chr_size]

with open("DKGFX.bin", "wb") as out:
    out.write(chr_blob)
print("Wrote DKGFX.bin (8 KB)")
