# Donkey Kong NES Disassembly

A complete disassembly of Donkey Kong for the NES, covering three different versions:
- **Rev 0** (Japanese release)
- **Rev 1** (International/US release)
- **Gamecube** (from Animal Crossing)

This disassembly is fully complete but documentation is still in progress.

## Quick Start

### Prerequisites
- [asm6 assembler](https://github.com/freem/asm6f)
- Python 3.x (for graphics extraction)
- Original Donkey Kong ROM file (for graphics extraction)

### Building

1. Extract graphics from your ROM:
   ```bash
   cd misc
   python ExtractGFX.py
   ```

2. Assemble the ROM:
   ```bash
   asm6 DonkeyKongDisassembly.asm DonkeyKong.nes
   ```

3. To build different versions, edit `DonkeyKongDisassembly.asm` and change the `Version` constant:
   ```assembly
   Version = US        ; Options: JP, US, Gamecube (or 0, 1, 2)
   ```

## Features

- Fully disassembled code for all three versions
- Detailed labels and comments
- Version-specific differences documented
- Support for all game phases (25M, 50M, 75M, 100M)

## Documentation

- [README.dev](README.dev) - Development documentation and build instructions
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines and workflow
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture and design
- [PROJECT_STATUS.md](PROJECT_STATUS.md) - Current project status and roadmap
- [GRAPHICS_WORKFLOW.md](GRAPHICS_WORKFLOW.md) - Graphics extraction and editing guide
- [Notes.txt](Notes.txt) - Labeling conventions and terminology

## Graphics Data

This disassembly does **not** include graphics data due to copyright restrictions. You must:
1. Obtain a legal copy of the original ROM
2. Use the Python script in the `misc` folder to extract graphics
3. The script will create `.bin` files for use with the disassembly

## Credits

Disassembled by RussianManSMWC

## License

This is a disassembly for educational and preservation purposes. The original game is © Nintendo.
