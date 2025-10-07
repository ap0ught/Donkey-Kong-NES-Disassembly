# Donkey Kong NES - Architecture Overview

This document provides a high-level overview of the Donkey Kong NES disassembly project architecture.

## Project Structure

```
Donkey-Kong-NES-Disassembly/
│
├── Documentation
│   ├── README.md              ← Start here!
│   ├── README.dev             ← Developer guide
│   ├── CONTRIBUTING.md        ← Contribution guidelines
│   ├── ARCHITECTURE.md        ← This file
│   └── Notes.txt              ← Label conventions
│
├── Build System
│   ├── .github/workflows/     ← GitHub Actions CI/CD
│   └── .gitignore             ← Version control rules
│
├── Source Code
│   ├── DonkeyKongDisassembly.asm  ← Main game code
│   ├── Defines.asm            ← Memory addresses and constants
│   ├── iNES_Header.asm        ← ROM header
│   └── JPRemap.asm            ← Version-specific macros
│
└── Tools (misc/)
    └── ExtractGFX.py          ← Graphics extraction script
```

## NES Hardware Architecture

### CPU: Ricoh 2A03 (Modified 6502)

```
┌─────────────────────────────────────────────┐
│              NES Console                     │
│                                              │
│  ┌──────────────┐       ┌─────────────────┐ │
│  │   CPU        │───────│  Program ROM    │ │
│  │  (2A03)      │       │   (PRG ROM)     │ │
│  │  @ 1.79 MHz  │       │   32KB          │ │
│  └──────┬───────┘       └─────────────────┘ │
│         │                                    │
│  ┌──────▼──┐       ┌─────────────────┐     │
│  │  RAM    │       │  Character ROM  │     │
│  │  2KB    │       │   (CHR ROM)     │     │
│  └─────────┘       │   8KB           │     │
│                    └────────┬────────┘     │
│  ┌──────────────┐           │              │
│  │   APU        │    ┌──────▼────────┐    │
│  │  (Audio)     │    │      PPU       │    │
│  └──────────────┘    │  (Graphics)    │    │
│                      │   @ 5.37 MHz   │    │
│  ┌──────────────┐    └────────┬───────┘    │
│  │ Controllers  │             │            │
│  └──────────────┘             │            │
└───────────────────────────────┼────────────┘
                                │
                           ┌────▼─────┐
                           │   TV     │
                           │  Screen  │
                           └──────────┘
```

### Memory Map

```
+---------------+ $FFFF
|               |
|  PRG ROM      | Program code and data
|               | (32KB on Donkey Kong)
|               |
+---------------+ $8000
|               |
|  SRAM         | Work RAM expansion
|  (Optional)   | (not used by DK)
|               |
+---------------+ $6000
|               |
|  Expansion    | Expansion ROM
|               |
+---------------+ $4020
|  APU & I/O    | Sound and controller registers
+---------------+ $4000
|  PPU Regs     | Graphics chip registers
+---------------+ $2000
|               |
|  RAM Mirrors  | Mirrors of $0000-$07FF
|               |
+---------------+ $0800
|  RAM          | 2KB work RAM
+---------------+ $0000
```

### Zero Page ($0000-$00FF)

Fast-access memory for frequently used variables:
```
$00-$0F: System/temporary variables
$10-$1F: Controller input and RNG
$20-$3F: Score and game state
$40-$5F: Jumpman (player) variables
$60-$7F: Enemy and object variables
$80-$FF: General purpose
```

## Game Phases

Donkey Kong consists of four distinct game phases (levels):

1. **25M** - Barrels stage
2. **50M** - Rivets stage (unused in NES version)
3. **75M** - Elevators stage
4. **100M** - Rivets stage

Each phase has unique:
- Level layout
- Enemy patterns
- Platform positions
- Win conditions

## Version Architecture

### Three Versions

```
┌─────────────────────────────────────┐
│     DonkeyKongDisassembly.asm       │
│                                     │
│  Version = JP | US | Gamecube       │
└────────┬────────────────────────────┘
         │
    ┌────▼────┐
    │         │
    ├─────────┴──────────┐
    │                    │
┌───▼────┐      ┌────────▼──────┐
│   JP   │      │   US/Gamecube │
│  Rev 0 │      │   Rev 1+      │
└────────┘      └───────────────┘
```

### Conditional Assembly

Version differences are handled via conditional assembly:

```assembly
If Version = JP
  ; Japanese-specific code
else
  ; US/Gamecube code
endif
```

### JPRemap.asm Macros

Provides macros for common version differences:
- Return value handling
- Branch distance adjustments
- Code organization changes

## Game Loop Architecture

```
Start
  ↓
Reset Vector
  ↓
Initialize Hardware
  ↓
Clear RAM
  ↓
Load Initial Game State
  ↓
Enable NMI & Rendering
  ↓
┌─────────────────┐
│  Main Loop      │←──────┐
│                 │       │
│  ┌───────────┐  │       │
│  │ Wait for  │  │       │
│  │  VBlank   │  │       │
│  └─────┬─────┘  │       │
│        ↓        │       │
│  ┌───────────┐  │       │
│  │ Read      │  │       │
│  │ Input     │  │       │
│  └─────┬─────┘  │       │
│        ↓        │       │
│  ┌───────────┐  │       │
│  │ Update    │  │       │
│  │ Game      │  │       │
│  │ Logic     │  │       │
│  └─────┬─────┘  │       │
│        ↓        │       │
│  ┌───────────┐  │       │
│  │ Update    │  │       │
│  │ Sprites   │  │       │
│  └─────┬─────┘  │       │
│        ↓        │       │
└────────┼────────┘       │
         └────────────────┘

During VBlank (NMI):
  ↓
Update PPU (nametables, palettes)
  ↓
DMA Sprite Transfer (OAM)
  ↓
Update Scroll Position
  ↓
Return to Main Loop
```

## Game State Machine

```
        ┌──────────────┐
        │  Power On    │
        └──────┬───────┘
               ↓
        ┌──────────────┐
        │ Title Screen │←───────┐
        └──────┬───────┘        │
               ↓                │
        ┌──────────────┐        │
    ┌───│   Gameplay   │        │
    │   │  (25M-100M)  │        │
    │   └──────┬───────┘        │
    │          ↓                │
    │   ┌──────────────┐        │
    │   │ Phase        │        │
    │   │ Complete     │        │
    │   └──────┬───────┘        │
    │          ↓                │
    │   ┌──────────────┐        │
    └──→│  Game Over   │────────┘
        └──────────────┘
```

## Entity System

### Jumpman (Player)

```
Position: X, Y coordinates
State: Standing, Walking, Jumping, Climbing, Hammer
Direction: Left or Right
Platform: Current platform index
```

### Enemies

Different types per phase:
- **Barrels** (25M): Rolling, climbing, blue (fire) barrels
- **Springs** (75M): Bouncing springs
- **Fires** (75M, 100M): Moving fire enemies

### Objects

- **Hammer**: Temporary power-up
- **Items**: Collectible bonus items (hat, parasol, purse)
- **Pauline**: Damsel in distress (at top of level)

## Graphics System

### Background Tiles

Donkey Kong uses background tiles for most graphics:
- Level platforms and ladders
- Donkey Kong himself
- UI elements (score, lives, bonus)

### Sprite Tiles (OAM)

Limited sprite usage:
- Jumpman (player character)
- Barrels and other moving enemies
- Items and pickups
- Pauline's head/body
- Ending sequence (DK as sprite)

## Sound System

### APU Channels

```
┌──────────────┐
│  Square 1    │ - Melody and effects
├──────────────┤
│  Square 2    │ - Harmony
├──────────────┤
│  Triangle    │ - Bass notes
├──────────────┤
│  Noise       │ - Percussion and effects
├──────────────┤
│  DMC         │ - (Not used in DK)
└──────────────┘
```

## Data Flow

```
Controller Input
       ↓
┌──────────────┐
│  Read Input  │
└──────┬───────┘
       ↓
┌──────────────┐     ┌──────────────┐
│ Update       │────→│ Check        │
│ Jumpman      │     │ Collisions   │
└──────┬───────┘     └──────┬───────┘
       ↓                    ↓
┌──────────────┐     ┌──────────────┐
│ Update       │     │ Update Score │
│ Enemies      │     │   & Bonus    │
└──────┬───────┘     └──────┬───────┘
       ↓                    ↓
┌──────────────────────────────────┐
│    Update Sprite Positions       │
└────────────────┬─────────────────┘
                 ↓
         ┌───────────────┐
         │  NMI Handler  │
         │  (VBlank)     │
         └───────┬───────┘
                 ↓
         ┌───────────────┐
         │  DMA Transfer │
         │  to OAM       │
         └───────┬───────┘
                 ↓
              Screen
```

## Build System

### Assembler: asm6

```
DonkeyKongDisassembly.asm
  ├── Defines.asm
  ├── iNES_Header.asm
  ├── JPRemap.asm
  └── Graphics data (.bin files)
       ↓
     asm6
       ↓
  DonkeyKong.nes
```

### GitHub Actions CI/CD

```
Push/PR Trigger
       ↓
Install asm6
       ↓
┌──────────────────┐
│  Build JP ver    │
├──────────────────┤
│  Build US ver    │
├──────────────────┤
│  Build GC ver    │
└──────┬───────────┘
       ↓
Upload Artifacts
       ↓
(On tag) Create Release
```

## Performance Considerations

### CPU Cycles

- NES CPU runs at ~1.79 MHz
- ~29,780 CPU cycles per frame (at 60 Hz)
- Game logic must fit within frame budget
- Heavy processing done during VBlank

### Memory Constraints

- Only 2KB RAM available
- Careful memory management required
- Zero page used for critical variables
- Stack at $0100-$01FF

## Code Organization Principles

### Label Format

```
VERSION_TAG/NAME_ADDRESS

Examples:
CODE_C000    - General code at $C000
JP_LOOP_C100 - Japan-specific loop
DATA_D000    - Data block
UNUSED_E000  - Unused code/data
```

### Comments

- Semicolons (;) for comments
- Explain non-obvious operations
- Document version differences
- Reference game mechanics

### Alignment

- Tabs for alignment (matching original style)
- Labels at column 0
- Instructions not indented
- Comments aligned consistently

## References

- [NES Dev Wiki](https://wiki.nesdev.com/)
- [6502 Reference](http://www.6502.org/tutorials/)
- [asm6 Documentation](https://github.com/freem/asm6f)

---

This architecture provides a foundation for understanding and working with the Donkey Kong NES disassembly project.
