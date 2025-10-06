# extract_chr_simple.py
# Usage: python extract_chr_simple.py DonkeyKong.nes DKGFX.bin
from __future__ import print_function

import sys


def main():
    if len(sys.argv) != 3:
        print("Usage: python extract_chr_simple.py <in.nes> <out.bin>")
        sys.exit(1)

    inp, outp = sys.argv[1], sys.argv[2]
    with open(inp, "rb") as f:
        header = f.read(16)
        if len(header) != 16 or header[:4] != b"NES\x1a":
            print("Not an iNES ROM")
            sys.exit(2)

        prg_banks = header[4]  # 16 KB each
        chr_banks = header[5]  # 8 KB each
        flags6 = header[6]
        has_trainer = (flags6 & 0x04) != 0

        if chr_banks == 0:
            print("ROM has CHR-RAM (0 CHR) - nothing to extract")
            sys.exit(3)

        prg_size = prg_banks * 16384
        chr_size = chr_banks * 8192
        trainer = 512 if has_trainer else 0

        f.seek(16 + trainer + prg_size)
        data = f.read(chr_size)

    if len(data) != chr_size:
        print(
            "Unexpected CHR length: expected {} bytes, got {}".format(
                chr_size, len(data)
            )
        )
        sys.exit(4)

    with open(outp, "wb") as o:
        o.write(data)

    print("Wrote {} ({} bytes)".format(outp, len(data)))


if __name__ == "__main__":
    main()
