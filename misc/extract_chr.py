import sys
if len(sys.argv) != 3:
    print("Usage: python extract_chr.py <input.nes> <out.bin>")
    raise SystemExit(1)

with open(sys.argv[1], "rb") as f:
    h = f.read(16)
    if h[:4] != b"NES\x1a":
        raise SystemExit("Not an iNES ROM")
    prg = h[4] * 16384
    chr_ = h[5] * 8192
    if chr_ == 0:
        raise SystemExit("ROM has 0 CHR banks (CHR-RAM) — nothing to extract")
    f.seek(16 + prg)
    data = f.read(chr_)

with open(sys.argv[2], "wb") as o:
    o.write(data)

print(f"Wrote {len(data)} bytes")
