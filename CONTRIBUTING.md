# Contributing to Donkey Kong NES Disassembly

Thank you for your interest in contributing to this project! This document provides guidelines for contributing to the disassembly.

## Getting Started

1. Read [README.dev](README.dev) for technical documentation
2. Review [Notes.txt](Notes.txt) for label conventions and terminology
3. Set up your development environment

## Development Workflow

### 1. Fork and Clone

```bash
git clone https://github.com/your-username/Donkey-Kong-NES-Disassembly.git
cd Donkey-Kong-NES-Disassembly
```

### 2. Set Up Build Environment

Install asm6:
```bash
git clone https://github.com/freem/asm6f.git
cd asm6f
make
sudo make install
```

Extract graphics (requires original ROM):
```bash
cd misc
python ExtractGFX.py
```

### 3. Make Your Changes

- Follow existing code style and conventions
- Add comments to explain complex code sections
- Update documentation if needed
- Test all three versions (JP, US, Gamecube)

### 4. Test Your Changes

Build and test all versions:
```bash
# Test US version
sed -i 's/Version = .*/Version = US/' DonkeyKongDisassembly.asm
asm6 DonkeyKongDisassembly.asm DK_US.nes

# Test JP version
sed -i 's/Version = .*/Version = JP/' DonkeyKongDisassembly.asm
asm6 DonkeyKongDisassembly.asm DK_JP.nes

# Test Gamecube version
sed -i 's/Version = .*/Version = Gamecube/' DonkeyKongDisassembly.asm
asm6 DonkeyKongDisassembly.asm DK_GC.nes
```

Test in an emulator to ensure the game still works correctly.

### 5. Submit a Pull Request

- Create a descriptive title
- Explain what you changed and why
- Reference any related issues
- Include screenshots/videos if relevant

## Code Style Guidelines

### Labels

Follow the established format: `VERSION_TAG/NAME_ADDRESS`

Examples:
- `CODE_C000` - General code block
- `JP_LOOP_C100` - Japan-specific loop
- `DATA_D000` - Data block
- `UNUSED_E000` - Unused code/data

### Tags

Use appropriate tags:
- `CODE` - Code blocks
- `DATA` - Data blocks  
- `UNUSED` - Unused code/data
- `LOOP` - Loop structures
- `RETURN` - Return points

### Comments

- Add comments for non-obvious code
- Explain the purpose of routines
- Document version-specific differences
- Use semicolons (`;`) for comments

Example:
```assembly
;check if jumpman is on platform where pauline is
LDA DATA_C1FA,X
CMP Jumpman_CurrentPlatformIndex
BEQ CODE_D074        ;if yes, phase complete!
```

### Version-Specific Code

Use conditional assembly for version differences:
```assembly
If Version = JP
  CMP #$74
  BCS CODE_CB18
  CMP #$6F
else
  CMP #$78
  BCS CODE_CB18
  CMP #$73
endif
```

## Documentation Improvements

Documentation contributions are highly valued! You can help by:

- Adding comments to undocumented code sections
- Improving existing comments
- Documenting memory addresses in Defines.asm
- Writing tutorials or guides
- Improving README files

## Release Process

Releases are handled automatically through GitHub Actions:

### Creating a Release

1. Update version documentation if needed
2. Tag the commit with a version number:
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

3. GitHub Actions will automatically:
   - Build all three ROM versions
   - Create a GitHub release
   - Attach ROM files to the release

### Version Numbering

We use semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Significant disassembly improvements or restructuring
- **MINOR**: New documented sections, feature additions
- **PATCH**: Bug fixes, comment improvements, small updates

## Automated Builds

Every push and pull request triggers automated builds via GitHub Actions:

- Three ROM versions are built (if graphics data is available)
- Build artifacts are available in the Actions tab
- Failed builds will notify contributors

## What to Contribute

### High Priority
- Document undocumented code sections
- Add missing comments
- Verify accuracy of existing comments
- Document memory addresses

### Medium Priority
- Improve code organization
- Add helper scripts/tools
- Enhance documentation
- Create tutorials

### Low Priority
- Code style improvements
- Typo fixes
- Minor optimizations

## Questions?

- Open an issue for questions
- Check existing issues and pull requests
- Review documentation first

## Code of Conduct

- Be respectful and constructive
- Help newcomers
- Give credit where due
- Focus on the project's educational goals

## Legal Notice

This project is for educational and preservation purposes. The original game is © Nintendo. Do not distribute ROM files or copyrighted graphics.

## Thank You!

Your contributions help preserve gaming history and educate others about NES development. Every contribution, no matter how small, is appreciated!
