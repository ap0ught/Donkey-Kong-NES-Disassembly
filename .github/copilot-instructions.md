# GitHub Copilot Instructions for Donkey Kong NES Disassembly

## Repository Overview

This is a complete disassembly of Donkey Kong for the NES, covering three versions:
- **Rev 0** (Japanese, referred to as JP)
- **Rev 1** (US/International)
- **Gamecube** (from Animal Crossing)

The disassembly uses the asm6 assembler and is written in 6502 assembly language.

## Key Files

- `DonkeyKongDisassembly.asm` - Main assembly file
- `Defines.asm` - Memory addresses, constants, and definitions
- `iNES_Header.asm` - NES ROM header definitions
- `JPRemap.asm` - Macros for handling JP vs US version differences
- `Notes.txt` - Label conventions and terminology reference

## Code Conventions

### Label Format

Labels follow the pattern: `VERSION_TAG/NAME_ADDRESS`

Examples:
- `CODE_C000` - General code block at address $C000
- `JP_LOOP_C100` - Japan-specific loop at $C100
- `DATA_D000` - Data block at $D000
- `UNUSED_E000` - Unused code/data at $E000

### Label Tags

- **CODE** - Marks a block of code
- **DATA** - Marks a block of data
- **UNUSED** - Marks unused code or data
- **LOOP** - Marks loop structures
- **RETURN** - Marks return points from routines

### Version-Specific Labels

- Default labels refer to Revision 1 (US version)
- **JP** prefix - Revision 0 (Japanese) specific code
- **Gamecube** prefix - Gamecube version specific code

### Comments

- Use semicolons (`;`) for comments
- Add comments for non-obvious code sections
- Explain the purpose of routines and complex operations
- Document version-specific differences
- Use tabs for alignment (matching existing code style)

Example:
```assembly
LDA DATA_C1FA,X                     ;check platform index
CMP Jumpman_CurrentPlatformIndex    ;compare with current position
BEQ CODE_D074                       ;if equal, phase complete!
```

### Version-Specific Code

Use conditional assembly for version differences:

```assembly
If Version = JP
  CMP #$74
  BCS CODE_CB18
else
  CMP #$78
  BCS CODE_CB18
endif
```

## Terminology

- **Jumpman** - The player character (later known as Mario). Use "Jumpman" for authenticity.
- **Sprite Tiles** - OAM tiles
- **Sprite** - An object that uses sprite tiles (Note: Donkey Kong uses background tiles, except in the ending)
- **Square (sound)** - Pulse wave
- **Phases** - Game stages: 25M, 50M, 75M, 100M

## Memory Addressing

Key memory locations are defined in `Defines.asm`:

### Controller Input
- `$14` - Player 1 controller input
- `$15` - Player 1 previous input
- `$16` - Player 2 controller input
- `$17` - Player 2 previous input

### Game State
- `$18-$1F` - RNG values
- `$12` - Camera X position
- `$13` - Camera Y position

Always use defined constants instead of raw addresses for clarity.

## Building

The project uses asm6 assembler:
```bash
asm6 DonkeyKongDisassembly.asm output.nes
```

To build different versions, modify the `Version` constant in `DonkeyKongDisassembly.asm`:
- `Version = JP` or `0`
- `Version = US` or `1`
- `Version = Gamecube` or `2`

## Code Style

1. **Alignment**: Use tabs to align comments and operands (matching existing style)
2. **Indentation**: Instructions are not indented, labels are at column 0
3. **Constants**: Use named constants from `Defines.asm` instead of magic numbers
4. **Labels**: Follow the established naming convention
5. **Comments**: Align comments consistently with existing code

## When Adding Code

1. Follow the existing label format and conventions
2. Add appropriate comments explaining the code's purpose
3. Use defined constants from `Defines.asm`
4. Document any version-specific behavior
5. Test all three versions if making changes that could affect them
6. Preserve the code's authenticity (e.g., use "Jumpman" not "Mario")

## When Documenting

1. Focus on explaining what the code does, not how (the assembly is the how)
2. Document the game logic and behavior
3. Explain non-obvious mechanics
4. Note any differences between versions
5. Reference memory addresses using the names from `Defines.asm`

## Important Notes

- Graphics data is NOT included due to copyright - it must be extracted separately
- The original code structure is preserved even when it's "spaghetti" for authenticity
- Address consistency between versions requires manual tracking
- Some sections are not fully documented yet - contributions welcome

## GitHub Actions

The repository has automated builds for all three versions via GitHub Actions. Workflow file: `.github/workflows/build.yml`

## References

- [README.md](../README.md) - User documentation
- [README.dev](../README.dev) - Developer documentation
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines
- [ARCHITECTURE.md](../ARCHITECTURE.md) - Architecture overview
- [PROJECT_STATUS.md](../PROJECT_STATUS.md) - Current project status
- [GRAPHICS_WORKFLOW.md](../GRAPHICS_WORKFLOW.md) - Graphics editing guide
- [Notes.txt](../Notes.txt) - Detailed label conventions and terminology
- [NESdev Wiki](https://wiki.nesdev.com/) - NES hardware documentation
- [6502 Reference](http://www.6502.org/tutorials/) - CPU instruction set
