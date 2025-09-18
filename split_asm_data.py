#!/usr/bin/env python3
"""
Split asm6/asm6f source into include files with build verification:
- Finds contiguous "data blocks" (db/dw/hex/fill/incbin lines, comments, and label-only lines).
- Moves each block to src/data/<name>.asm and replaces it with incsrc in the main file.
- Verifies the build works before and after splitting to ensure no regressions.
- By default, only splits blocks >= min_lines (to avoid churning tiny tables).
- Handles ASM6-specific syntax and directives properly.

Usage:
  python split_asm_data.py DonkeyKongDisassembly.asm out/DonkeyKongDisassembly.split.asm --data-dir src/data --min-lines 6 --dry-run
  python split_asm_data.py DonkeyKongDisassembly.asm DonkeyKongDisassembly.asm --data-dir src/data --verify

Safeguards:
- Verifies original file assembles successfully before splitting
- Verifies split result assembles to identical binary
- The transform is textual: assembled bytes should be identical
- Preserves ASM6-specific syntax and formatting
"""
import argparse
import hashlib
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile
from typing import List, Tuple, Optional

# ASM6-specific data tokens (case-insensitive)
DATA_TOKENS = {
    "db",
    ".db",
    "dw",
    ".dw",
    "byte",
    ".byte",
    "word",
    ".word",
    "hex",
    ".hex",
    "fill",
    ".fill",
    "incbin",
    ".incbin",
    "dbyt",
    ".dbyt",
    "dword",
    ".dword",
    "dl",
    ".dl",  # ASM6f extensions
}

# ASM6 assembler directives that shouldn't be in data blocks
ASM_DIR_CMDS = {
    "org",
    ".org",
    "base",
    ".base",
    "include",
    ".include",
    "incsrc",
    ".incsrc",
    "equ",
    ".equ",
    "set",
    ".set",
    "=",
    "macro",
    ".macro",
    "endm",
    ".endm",
    "rept",
    ".rept",
    "endr",
    ".endr",
    "if",
    ".if",
    "ifdef",
    ".ifdef",
    "ifndef",
    ".ifndef",
    "else",
    ".else",
    "elseif",
    ".elseif",
    "endif",
    ".endif",
    "enum",
    ".enum",
    "ende",
    ".ende",
    "fillvalue",
    ".fillvalue",
    "pad",
    ".pad",
    "align",
    ".align",
    "error",
    ".error",
    "warning",
    ".warning",
}

# ASM6-specific conditional directives that might contain data
CONDITIONAL_TOKENS = {
    "if",
    ".if",
    "ifdef",
    ".ifdef",
    "ifndef",
    ".ifndef",
    "else",
    ".else",
    "elseif",
    ".elseif",
    "endif",
    ".endif",
}

# Regex patterns
LABEL_ONLY_RE = re.compile(r"^\s*([A-Za-z_\.][\w\.]*[:]?)\s*[:]\s*(?:;.*)?$")
DATA_LINE_RE = re.compile(
    r"^\s*(?:([A-Za-z_\.][\w\.]*[:]?)\s*[:]\s*)?([\.]?[A-Za-z]+)\b"
)
COMMENT_OR_BLANK_RE = re.compile(r"^\s*(?:;.*)?$")
ASSIGNMENT_RE = re.compile(r"^\s*([A-Za-z_][\w]*)\s*[=]\s*(.+?)(?:\s*;.*)?$")
CONDITIONAL_RE = re.compile(r"^\s*(if|ifdef|ifndef|else|elseif|endif)\b", re.IGNORECASE)


def find_assembler() -> Optional[str]:
    """Find asm6f or asm6 assembler in PATH or common locations."""
    assemblers = ["asm6f", "asm6", "asm6f.exe", "asm6.exe"]

    # Check PATH first
    for asm in assemblers:
        if shutil.which(asm):
            return asm

    # Check common local paths
    local_paths = [".", "tools", "bin", "../tools", "../bin"]
    for path in local_paths:
        for asm in assemblers:
            full_path = pathlib.Path(path) / asm
            if full_path.exists() and full_path.is_file():
                return str(full_path)

    return None


def run_assembler(
    asm_path: str,
    input_file: pathlib.Path,
    output_file: pathlib.Path,
    verbose: bool = False,
) -> Tuple[bool, str, str]:
    """
    Run the assembler on the input file.
    Returns (success, stdout, stderr)
    """
    try:
        cmd = [asm_path, str(input_file), str(output_file)]
        if verbose:
            print(f"Running: {' '.join(cmd)}")

        result = subprocess.run(
            cmd, capture_output=True, text=True, timeout=30  # 30 second timeout
        )

        return result.returncode == 0, result.stdout, result.stderr

    except subprocess.TimeoutExpired:
        return False, "", "Assembly process timed out"
    except Exception as e:
        return False, "", f"Error running assembler: {e}"


def get_file_hash(filepath: pathlib.Path) -> str:
    """Get SHA256 hash of a file."""
    if not filepath.exists():
        return ""

    sha256_hash = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            sha256_hash.update(chunk)
    return sha256_hash.hexdigest()


def verify_assembly(
    asm_path: str, input_file: pathlib.Path, description: str, verbose: bool = False
) -> Tuple[bool, Optional[str]]:
    """
    Verify that an assembly file can be assembled successfully.
    Returns (success, output_hash) where output_hash is None if assembly failed.
    """
    with tempfile.NamedTemporaryFile(suffix=".nes", delete=False) as temp_output:
        temp_output_path = pathlib.Path(temp_output.name)

    try:
        print(f"Verifying {description}...", end="")
        success, stdout, stderr = run_assembler(
            asm_path, input_file, temp_output_path, verbose
        )

        if success:
            output_hash = get_file_hash(temp_output_path)
            print(" ✓")
            if verbose and stdout:
                print(f"  Assembler output: {stdout}")
            return True, output_hash
        else:
            print(" ✗")
            print(f"  Assembly failed for {description}")
            if stderr:
                print(f"  Error: {stderr}")
            if stdout:
                print(f"  Output: {stdout}")
            return False, None

    finally:
        # Clean up temp file
        if temp_output_path.exists():
            temp_output_path.unlink()


def is_data_line(line: str) -> bool:
    """Check if line contains data definition tokens."""
    line_clean = line.strip()
    if not line_clean or line_clean.startswith(";"):
        return False

    m = DATA_LINE_RE.match(line)
    if not m:
        return False

    tok = m.group(2).lower() if m.group(2) else ""
    return tok in DATA_TOKENS


def is_label_only(line: str) -> bool:
    """Check if line is label-only (no instruction)."""
    return bool(LABEL_ONLY_RE.match(line))


def is_comment_or_blank(line: str) -> bool:
    """Check if line is comment or blank."""
    return bool(COMMENT_OR_BLANK_RE.match(line))


def is_assignment(line: str) -> bool:
    """Check if line is a variable assignment (ASM6 style)."""
    return bool(ASSIGNMENT_RE.match(line))


def is_conditional_directive(line: str) -> bool:
    """Check if line is a conditional assembly directive."""
    return bool(CONDITIONAL_RE.match(line))


def is_assembler_directive(line: str) -> bool:
    """Check if line contains assembler directives that shouldn't be in data blocks."""
    line_clean = line.strip().lower()
    if not line_clean or line_clean.startswith(";"):
        return False

    # Check for directives
    words = line_clean.split()
    if not words:
        return False

    first_word = words[0]
    # Remove label if present
    if ":" in first_word:
        parts = first_word.split(":", 1)
        if len(parts) > 1 and parts[1]:
            first_word = parts[1]
        else:
            # Pure label line
            return False

    return first_word in ASM_DIR_CMDS


def is_block_line(line: str) -> bool:
    """Check if line can be part of a data block."""
    return (
        is_data_line(line)
        or is_label_only(line)
        or is_comment_or_blank(line)
        or is_assignment(line)
    )


def should_break_block(line: str) -> bool:
    """Check if line should break a data block."""
    return is_assembler_directive(line) or is_conditional_directive(line)


def sanitize_name(s: str) -> str:
    """Sanitize filename, preserving ASM6 naming conventions."""
    if not s:
        return "block"

    # Remove trailing colon from labels
    s = s.rstrip(":")

    # Replace invalid filename characters
    s = re.sub(r"[^A-Za-z0-9_.-]+", "_", s).strip("_")

    # Ensure it starts with letter or underscore
    if s and not (s[0].isalpha() or s[0] == "_"):
        s = "block_" + s

    return s or "block"


def detect_first_label(lines: List[str], start: int, end: int) -> Optional[str]:
    """Extract the first meaningful label from a block."""
    # Check the start line for labels
    m = LABEL_ONLY_RE.match(lines[start])
    if m:
        return m.group(1).rstrip(":")

    m = DATA_LINE_RE.match(lines[start])
    if m and m.group(1):
        return m.group(1).rstrip(":")

    # Look backward for nearby labels (within 3 lines)
    for k in range(max(0, start - 3), start):
        mm = LABEL_ONLY_RE.match(lines[k])
        if mm:
            return mm.group(1).rstrip(":")

    # Look forward in the block for the first label
    for k in range(start, min(end, start + 5)):
        mm = LABEL_ONLY_RE.match(lines[k])
        if mm:
            return mm.group(1).rstrip(":")
        mm = DATA_LINE_RE.match(lines[k])
        if mm and mm.group(1):
            return mm.group(1).rstrip(":")

    return None


def hash_block(text: str) -> str:
    """Generate short hash for block content."""
    return hashlib.sha1(text.encode("utf-8", errors="ignore")).hexdigest()[:8]


def count_actual_data_lines(lines: List[str], start: int, end: int) -> int:
    """Count actual data lines (excluding comments and blanks)."""
    count = 0
    for i in range(start, end):
        if is_data_line(lines[i]) or is_label_only(lines[i]):
            count += 1
    return count


def validate_block(lines: List[str], start: int, end: int) -> bool:
    """Validate that block is suitable for extraction."""
    # Must contain at least one actual data line
    has_data = False
    for i in range(start, end):
        if is_data_line(lines[i]):
            has_data = True
            break

    if not has_data:
        return False

    # Check for problematic constructs
    for i in range(start, end):
        line = lines[i].strip()
        if line and not (is_block_line(lines[i]) or should_break_block(lines[i])):
            # Unknown line type - be conservative
            return False

    return True


def find_data_blocks(lines: List[str], min_lines: int) -> List[Tuple[int, int]]:
    """Find all suitable data blocks in the source."""
    i, n = 0, len(lines)
    blocks = []

    while i < n:
        line = lines[i]

        if is_data_line(line):
            # Start of potential data block
            start = i
            j = i

            # Expand forward while we have block-compatible lines
            while (
                j < n and is_block_line(lines[j]) and not should_break_block(lines[j])
            ):
                j += 1

            end = j
            block_len = end - start
            actual_data_lines = count_actual_data_lines(lines, start, end)

            # Apply filters
            if (
                block_len >= min_lines
                and actual_data_lines >= max(1, min_lines // 2)
                and validate_block(lines, start, end)
            ):
                blocks.append((start, end))

            i = end
        else:
            i += 1

    return blocks


def generate_include_line(relpath: pathlib.Path, use_quotes: bool = True) -> str:
    """Generate ASM6-compatible include line."""
    path_str = relpath.as_posix()
    if use_quotes:
        return f'incsrc "{path_str}"'
    else:
        return f"incsrc {path_str}"


def backup_file(filepath: pathlib.Path) -> pathlib.Path:
    """Create backup of original file."""
    backup_path = filepath.with_suffix(filepath.suffix + ".backup")
    counter = 1
    while backup_path.exists():
        backup_path = filepath.with_suffix(f"{filepath.suffix}.backup{counter}")
        counter += 1

    backup_path.write_bytes(filepath.read_bytes())
    return backup_path


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    ap.add_argument("infile", help="Input ASM file to process")
    ap.add_argument("outfile", help="Output ASM file (use same as infile to overwrite)")
    ap.add_argument(
        "--data-dir", default="src/data", help="Directory for extracted data files"
    )
    ap.add_argument(
        "--min-lines", type=int, default=6, help="Minimum lines to extract as block"
    )
    ap.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without writing files",
    )
    ap.add_argument(
        "--backup",
        action="store_true",
        help="Create backup of original file before overwriting",
    )
    ap.add_argument(
        "--force", action="store_true", help="Overwrite existing data files"
    )
    ap.add_argument(
        "--verify",
        action="store_true",
        help="Verify assembly before and after splitting",
    )
    ap.add_argument(
        "--assembler",
        help="Path to asm6f/asm6 assembler (auto-detected if not specified)",
    )
    ap.add_argument("--verbose", "-v", action="store_true", help="Verbose output")

    args = ap.parse_args()

    src = pathlib.Path(args.infile)
    out = pathlib.Path(args.outfile)
    data_dir = pathlib.Path(args.data_dir)

    if not src.exists():
        print(f"Error: Input file '{src}' not found", file=sys.stderr)
        return 1

    # Find assembler if verification is requested
    assembler = None
    if args.verify:
        assembler = args.assembler or find_assembler()
        if not assembler:
            print(
                "Error: Could not find asm6f/asm6 assembler for verification.",
                file=sys.stderr,
            )
            print("Install asm6f or specify path with --assembler", file=sys.stderr)
            return 1

        if args.verbose:
            print(f"Using assembler: {assembler}")

    # Read source file
    try:
        lines = src.read_text(encoding="utf-8", errors="ignore").splitlines()
    except Exception as e:
        print(f"Error reading '{src}': {e}", file=sys.stderr)
        return 1

    # Verify original assembly works (if verification enabled)
    original_hash = None
    if args.verify:
        success, original_hash = verify_assembly(
            assembler, src, "original file", args.verbose
        )
        if not success:
            print(
                "Error: Original file does not assemble successfully. Fix errors before splitting."
            )
            return 1

    # Find data blocks
    blocks_info = find_data_blocks(lines, args.min_lines)

    if not blocks_info:
        print("No suitable data blocks found.")
        if args.verbose:
            print(f"Searched {len(lines)} lines with min_lines={args.min_lines}")
        return 0

    # Process blocks
    edits = []
    blocks = []

    for start, end in blocks_info:
        block_text = "\n".join(lines[start:end]) + "\n"

        # Generate filename
        label = detect_first_label(lines, start, end)
        base = sanitize_name(label or f"block_{start+1}")
        hash_suffix = hash_block(block_text)
        fname = f"{base}_{start+1:05d}_{hash_suffix}.asm"
        relpath = data_dir / fname

        # Generate include line
        inc_line = generate_include_line(data_dir / fname)

        edits.append((start, end, inc_line))
        blocks.append((relpath, block_text))

        if args.verbose:
            actual_lines = count_actual_data_lines(lines, start, end)
            print(
                f"Block {len(blocks)}: lines {start+1}-{end}, "
                f"{end-start} total/{actual_lines} data -> {fname}"
            )

    # Show summary
    print(f"Found {len(blocks)} data block(s) to extract:")
    for i, (path, _) in enumerate(blocks):
        start, end, _ = edits[i]
        print(f"  {path.name} (lines {start+1}-{end})")

    if args.dry_run:
        print("\n[DRY RUN] No files would be written.")
        if args.verify:
            print("Verification would be performed if not in dry-run mode.")
        return 0

    # Create backup if requested and overwriting
    if args.backup and src == out and src.exists():
        backup_path = backup_file(src)
        print(f"Created backup: {backup_path}")

    # Check for existing files
    if not args.force:
        existing = [p for p, _ in blocks if p.exists()]
        if existing:
            print(
                f"Error: {len(existing)} data files already exist. Use --force to overwrite:"
            )
            for p in existing[:5]:  # Show first 5
                print(f"  {p}")
            if len(existing) > 5:
                print(f"  ... and {len(existing)-5} more")
            return 1

    # Create data directory
    data_dir.mkdir(parents=True, exist_ok=True)

    # Apply edits (back-to-front to avoid index issues)
    new_lines = lines[:]
    for start, end, inc_line in reversed(edits):
        new_lines[start:end] = [inc_line]

    # Write data files
    try:
        for relpath, text in blocks:
            relpath.parent.mkdir(parents=True, exist_ok=True)
            relpath.write_text(text, encoding="utf-8")
            if args.verbose:
                print(f"Wrote: {relpath}")
    except Exception as e:
        print(f"Error writing data files: {e}", file=sys.stderr)
        return 1

    # Write main file
    try:
        out.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
        print(f"Wrote main file: {out}")
    except Exception as e:
        print(f"Error writing main file: {e}", file=sys.stderr)
        return 1

    # Verify split result assembles correctly
    if args.verify:
        success, split_hash = verify_assembly(
            assembler, out, "split result", args.verbose
        )
        if not success:
            print("ERROR: Split result does not assemble!")
            print("This indicates the splitting process introduced errors.")
            return 1

        # Compare output hashes
        if original_hash and split_hash:
            if original_hash == split_hash:
                print(
                    "✓ Verification passed: Split result assembles to identical binary"
                )
            else:
                print(
                    "WARNING: Split result assembles successfully but produces different binary"
                )
                print(f"Original hash: {original_hash[:16]}...")
                print(f"Split hash:    {split_hash[:16]}...")
                print("This may indicate a problem with the splitting logic.")
                return 1

    print(f"Successfully split {len(blocks)} data blocks.")
    if assembler:
        print(f"Manual verification: {assembler} {out} output.nes")

    return 0


if __name__ == "__main__":
    sys.exit(main())
