# Graphics Workflow Guide - Donkey Kong NES

This guide explains how to work with graphics in the Donkey Kong NES disassembly project.

## Overview

Donkey Kong's graphics are stored as CHR ROM (Character ROM). This guide covers:
1. Extracting graphics from ROMs
2. Viewing and editing graphics
3. Understanding tile organization
4. Rebuilding ROMs with modified graphics

## Quick Start

### Extract Graphics from ROM

```bash
cd misc
python ExtractGFX.py
```

The script will:
- Locate your Donkey Kong ROM
- Extract CHR ROM data
- Create `.bin` files for use with the disassembly

## Understanding NES Graphics

### Tile Format

- Each tile is 8x8 pixels
- 2 bits per pixel = 4 colors per tile
- 16 bytes per tile:
  - Bytes 0-7: Low bitplane
  - Bytes 8-15: High bitplane

### Pattern Tables

Donkey Kong's CHR ROM is organized into pattern tables:
- **Pattern Table 0** ($0000-$0FFF): Sprites (Jumpman, barrels, etc.)
- **Pattern Table 1** ($1000-$1FFF): Background tiles (platforms, ladders, etc.)

Each pattern table contains 256 tiles (256 × 16 bytes = 4KB).

### Color Palettes

NES supports:
- 4 background palettes (for level graphics)
- 4 sprite palettes (for characters and objects)
- Each palette has 4 colors
- Colors selected from NES's 64-color master palette

## Donkey Kong Tile Organization

### Pattern Table 0 - Sprites

```
$00-$1F: Jumpman (Mario) - Standing, walking, jumping, climbing
$20-$2F: Jumpman with hammer
$30-$3F: Barrel sprites (rolling, blue barrels)
$40-$4F: Spring sprites
$50-$5F: Fire enemy sprites
$60-$6F: Item sprites (hat, parasol, purse)
$70-$7F: Pauline head sprite
$80-$8F: Explosion/destruction effects
$90-$9F: Score number sprites (100, 300, 500, 800)
$A0-$FF: Additional sprites and effects
```

### Pattern Table 1 - Background

```
$00-$1F: Platform/girder tiles (various angles)
$20-$3F: Ladder tiles (top, middle, bottom)
$40-$5F: Rivets and bolts
$60-$7F: UI elements (HUD, borders)
$80-$9F: Barrel pile graphics
$A0-$BF: Text characters (letters, numbers)
$C0-$DF: Title screen graphics
$E0-$FF: Decorative elements
```

## Viewing Graphics

### Option 1: Emulator Debug Tools (Recommended)

**Mesen:**
```bash
mesen DonkeyKong.nes
# Debug → PPU Viewer → CHR Viewer
```

**FCEUX:**
```bash
fceux DonkeyKong.nes
# Tools → PPU Viewer
```

### Option 2: YY-CHR

1. Download YY-CHR: https://www.romhacking.net/utilities/119/
2. Open YY-CHR
3. File → Open: Select your extracted `.bin` file
4. Settings:
   - Format: NES
   - 2bpp
   - 8x8 tiles
   - Width: 16 tiles

### Option 3: NES Screen Tool

For level layout editing:
1. Download: https://shiru.untergrund.net/software.shtml
2. Open ROM or extracted graphics
3. View nametables and attribute tables

## Editing Graphics

### Workflow

1. **Extract graphics**
   ```bash
   cd misc
   python ExtractGFX.py
   ```

2. **Backup original**
   ```bash
   cp extracted_graphics.bin extracted_graphics.bin.backup
   ```

3. **Open in editor** (YY-CHR recommended)
   - Load .bin file
   - Edit tiles as needed
   - Save changes

4. **Rebuild ROM**
   ```bash
   asm6 DonkeyKongDisassembly.asm DonkeyKong_modified.nes
   ```

5. **Test in emulator**
   ```bash
   fceux DonkeyKong_modified.nes
   ```

### Editing Tips

- **Preserve tile dimensions**: Keep all tiles 8x8 pixels
- **4-color limit**: Each tile can only use 4 colors
- **Test frequently**: Build and test after each change
- **Document changes**: Note which tiles you modified
- **Backup often**: Save multiple versions

## Common Modifications

### Change Jumpman's Colors

1. Open sprite pattern table (0) in YY-CHR
2. Locate Jumpman tiles ($00-$2F)
3. Edit colors using palette editor
4. Save and rebuild

### Modify Level Graphics

1. Open background pattern table (1)
2. Find platform/ladder tiles ($00-$3F)
3. Edit tile designs
4. Rebuild and test level appearance

### Add Custom Sprites

1. Find unused tile space in pattern table 0
2. Design new 8x8 sprite
3. Ensure 4-color palette compliance
4. Update sprite references in code (if needed)

## Graphics in Code

### Sprite References

Jumpman's sprite tiles are referenced in code:

```assembly
; Jumpman standing frame
LDA #$00        ; Tile number from pattern table 0
STA SpriteData  ; Store in sprite OAM

; Jumpman walking frame
LDA #$01
STA SpriteData
```

### Background Tile References

Level layouts reference background tiles:

```assembly
; Draw platform tile
LDA #$10        ; Tile from pattern table 1
STA PPUDATA     ; Write to nametable
```

## Version Differences

### JP vs US Graphics

- **Mostly identical** tile sets
- Minor color palette differences
- Some text character changes

### Gamecube Version

- **Same graphics** as US version
- Identical CHR ROM data
- No visual differences

## Advanced: Creating Custom Graphics

### Tools Needed

- Graphics editor (GIMP, Aseprite, etc.)
- YY-CHR or NES tile editor
- NES palette reference

### Process

1. **Design tiles**
   - Create 8x8 pixel artwork
   - Use only 4 colors per tile
   - Follow NES color restrictions

2. **Convert to NES format**
   - Import into YY-CHR
   - Arrange in pattern table
   - Save as NES 2bpp format

3. **Replace in project**
   ```bash
   cp custom_graphics.bin extracted_graphics.bin
   ```

4. **Update code references** (if adding new tiles)
   ```assembly
   ; Reference new custom tile
   LDA #$XX      ; Your new tile index
   ```

5. **Build and test**
   ```bash
   asm6 DonkeyKongDisassembly.asm DK_custom.nes
   fceux DK_custom.nes
   ```

## Palette Information

### Background Palettes

Donkey Kong uses different palettes per phase:

**25M (Barrels):**
- Palette 0: Girders (brown/orange)
- Palette 1: Ladders (cyan/blue)
- Palette 2: Barrels (brown)
- Palette 3: UI elements

**75M (Elevators):**
- Palette 0: Platforms (blue)
- Palette 1: Ladders (white)
- Palette 2: Springs (red)
- Palette 3: UI elements

**100M (Rivets):**
- Palette 0: Girders (red)
- Palette 1: Rivets (yellow)
- Palette 2: Structural (cyan)
- Palette 3: UI elements

### Sprite Palettes

- Palette 0: Jumpman (red, brown, skin tones)
- Palette 1: Barrels and enemies (brown, red)
- Palette 2: Items (various)
- Palette 3: Effects (white, yellow)

## Troubleshooting

### Graphics Look Corrupted

**Problem**: Tiles appear garbled

**Solutions**:
1. Verify CHR data is correct format (NES 2bpp)
2. Check file size (should be 8KB or 16KB)
3. Ensure graphics are extracted from correct ROM version
4. Verify pattern table selection in code

### Wrong Colors

**Problem**: Graphics visible but colors wrong

**Solutions**:
1. Check palette settings in emulator
2. Verify palette data in ROM
3. Ensure attribute tables are correct
4. Test with different emulators

### Missing Graphics

**Problem**: Blank tiles or black squares

**Solutions**:
1. Verify graphics file exists and is referenced
2. Check CHR ROM is included in build
3. Ensure PPU is configured correctly
4. Verify pattern table switches in code

### Build Size Issues

**Problem**: ROM size changed after modifying graphics

**Solution**: This is expected. CHR ROM adds to final ROM size:
- Original ROM: 32KB (including 8KB CHR)
- Modified graphics must fit in same 8KB

## Best Practices

### Version Control

- Commit graphics as binary files
- Document changes in commit messages
- Keep original ROM separate (not in repo)
- Tag versions after major graphics changes

### Organization

- Keep backup of original graphics
- Document tile usage in comments
- Use consistent naming for custom tiles
- Maintain tile organization standards

### Testing

- Test in multiple emulators
- Check all game phases (25M, 75M, 100M)
- Verify animations work correctly
- Test on hardware if possible

### Documentation

- Document custom tiles in code comments
- Keep a tile map reference document
- Note any palette changes
- Update README if modifying graphics workflow

## Graphics Extraction Script

### ExtractGFX.py Usage

```bash
cd misc
python ExtractGFX.py [input_rom] [output_bin]
```

### Script Features

- Automatically detects ROM format
- Validates ROM header
- Extracts CHR ROM to .bin file
- Provides size and offset information
- Works with all three DK versions

### Manual Extraction

If script doesn't work:

```bash
# Skip 16-byte header, extract 8KB CHR ROM
dd if=DonkeyKong.nes of=graphics.bin bs=1 skip=16400 count=8192
```

## Resources

### Tools

- **YY-CHR**: https://www.romhacking.net/utilities/119/
- **Mesen**: https://www.mesen.ca/
- **FCEUX**: http://fceux.com/
- **NES Screen Tool**: https://shiru.untergrund.net/software.shtml
- **Tile Molester**: https://www.romhacking.net/utilities/109/

### Documentation

- [NESdev Wiki - CHR ROM](https://wiki.nesdev.com/w/index.php/CHR_ROM)
- [NESdev Wiki - PPU](https://wiki.nesdev.com/w/index.php/PPU)
- [NES Graphics Guide](https://wiki.nesdev.com/w/index.php/PPU_palettes)

### Community

- [NESdev Forums](https://forums.nesdev.org/)
- [ROM Hacking.net](https://www.romhacking.net/)
- [/r/nes](https://reddit.com/r/nes)

## See Also

- [README.md](README.md) - Project overview
- [README.dev](README.dev) - Developer documentation
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture
- [misc/README.md](misc/README.md) - Tools documentation

---

For questions or issues with graphics, please open an issue on GitHub or consult the NESdev community.
