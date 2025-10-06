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

Requirements:
  Python 3.6.8 or later (uses pathlib, subprocess features, and f-strings in some error messages)

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

# Check Python version
if sys.version_info < (3, 6, 8):
    print("ERROR: This script requires Python 3.6.8 or later")
    print(
        "Current version: {}.{}.{}".format(
            sys.version_info.major, sys.version_info.minor, sys.version_info.micro
        )
    )
    print("Please upgrade your Python installation or use a newer version")
    sys.exit(1)

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


def _supports_unicode() -> bool:
    enc = sys.stdout.encoding or ""
    try:
        "✓".encode(enc, errors="strict")
        return True
    except Exception:
        return False


_OK = "✓" if _supports_unicode() else "OK"
_FAIL = "✗" if _supports_unicode() else "FAIL"


def find_assembler():
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


def run_assembler(asm_path, input_file, output_file, verbose=False):
    """
    Run the assembler on the input file.
    Returns (success, stdout, stderr)
    """
    try:
        cmd = [asm_path, str(input_file), str(output_file)]
        if verbose:
            print("Running: {} (cwd={})".format(" ".join(cmd), input_file.parent))

        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30,  # 30 second timeout
            cwd=str(
                pathlib.Path(input_file).parent
            ),  # <— NEW: resolve includes correctly
        )

        return result.returncode == 0, result.stdout, result.stderr

    except subprocess.TimeoutExpired:
        return False, "", "Assembly process timed out"
    except Exception as e:
        return False, "", "Error running assembler: {}".format(e)


def get_file_hash(filepath):
    """Get SHA256 hash of a file."""
    if not filepath.exists():
        return ""

    sha256_hash = hashlib.sha256()
    with open(filepath, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            sha256_hash.update(chunk)
    return sha256_hash.hexdigest()


def verify_assembly(asm_path, input_file, description, verbose=False):
    """
    Verify that an assembly file can be assembled successfully.
    Returns (success, output_hash) where output_hash is None if assembly failed.
    """
    temp_output = tempfile.NamedTemporaryFile(suffix=".nes", delete=False)
    temp_output_path = pathlib.Path(temp_output.name)
    temp_output.close()

    try:
        print("Verifying {}...".format(description), end="")
        success, stdout, stderr = run_assembler(
            asm_path, input_file, temp_output_path, verbose
        )

        if success:
            output_hash = get_file_hash(temp_output_path)
            print(f" {_OK}")
            if verbose and stdout:
                print("  Assembler output: {}".format(stdout))
            return True, output_hash
        else:
            print(f" {_FAIL}")
            print("  Assembly failed for {}".format(description))
            if stderr:
                print("  Error: {}".format(stderr))
            if stdout:
                print("  Output: {}".format(stdout))
            return False, None

    finally:
        # Clean up temp file
        if temp_output_path.exists():
            temp_output_path.unlink()


def is_data_line(line):
    """Check if line contains data definition tokens."""
    line_clean = line.strip()
    if not line_clean or line_clean.startswith(";"):
        return False

    m = DATA_LINE_RE.match(line)
    if not m:
        return False

    tok = m.group(2).lower() if m.group(2) else ""
    return tok in DATA_TOKENS


def is_label_only(line):
    """Check if line is label-only (no instruction)."""
    return bool(LABEL_ONLY_RE.match(line))


def is_comment_or_blank(line):
    """Check if line is comment or blank."""
    return bool(COMMENT_OR_BLANK_RE.match(line))


def is_assignment(line):
    """Check if line is a variable assignment (ASM6 style)."""
    return bool(ASSIGNMENT_RE.match(line))


def is_conditional_directive(line):
    """Check if line is a conditional assembly directive."""
    return bool(CONDITIONAL_RE.match(line))


def is_assembler_directive(line):
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


def is_block_line(line):
    """Check if line can be part of a data block."""
    return (
        is_data_line(line)
        or is_label_only(line)
        or is_comment_or_blank(line)
        or is_assignment(line)
    )


def should_break_block(line):
    """Check if line should break a data block."""
    return is_assembler_directive(line) or is_conditional_directive(line)


def sanitize_name(s):
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


def detect_first_label(lines, start, end):
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


def hash_block(text):
    """Generate short hash for block content."""
    return hashlib.sha1(text.encode("utf-8", errors="ignore")).hexdigest()[:8]


def count_actual_data_lines(lines, start, end):
    """Count actual data lines (excluding comments and blanks)."""
    count = 0
    for i in range(start, end):
        if is_data_line(lines[i]) or is_label_only(lines[i]):
            count += 1
    return count


def validate_block(lines, start, end):
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


# Drop-in patch snippets for split_asm_data.py
# Fix: avoid capturing trailing label-only lines (e.g., CODE_FB75:) at the end of data blocks,
# while still allowing labels *inside* a data block when they are immediately followed by data.

# --- Add these helpers near the other predicate helpers ---


def next_significant_index(lines: list[str], idx: int) -> int:
    """Return index of next non-blank/non-comment line after idx, or len(lines) if none."""
    n = len(lines)
    k = idx + 1
    while k < n and is_comment_or_blank(lines[k]):
        k += 1
    return k


def next_significant_is_data(lines: list[str], idx: int) -> bool:
    """Return True if the next significant line after idx looks like data/assignment."""
    k = next_significant_index(lines, idx)
    if k >= len(lines):
        return False
    return is_data_line(lines[k]) or is_assignment(lines[k])


# --- Replace your find_data_blocks(...) with the version below ---


def find_data_blocks(lines, min_lines):
    """Find all suitable data blocks in the source.

    Heuristics:
    - Start a block only at a data line (db/dw/hex/fill/incbin/etc.).
    - Permit label-only lines *inside* the block only when they are immediately followed by data.
      If a label-only line is followed by non-data (typically code), treat it as the start of the next section
      and do not include it in the data block.
    - Trim any trailing label-only or comment lines that accidentally slip through, as an extra safeguard.
    """
    i, n = 0, len(lines)
    blocks = []

    while i < n:
        line = lines[i]

        if is_data_line(line):
            start = i
            j = i

            while j < n:
                cur = lines[j]

                # Hard break on assembler directives / conditionals
                if should_break_block(cur):
                    break

                # Allow block-compatible lines, with special rules for label-only lines
                if is_label_only(cur):
                    # Keep label only if followed by data/assignment; otherwise it's the start of next section
                    if next_significant_is_data(lines, j):
                        j += 1
                        continue
                    else:
                        break  # do not consume this label; let the next pass handle it

                if is_block_line(cur):
                    j += 1
                    continue

                # Unknown line type: stop block
                break

            end = j

            # Trim trailing label-only or comment/blank lines from the block, if any
            while end > start and (
                is_comment_or_blank(lines[end - 1]) or is_label_only(lines[end - 1])
            ):
                end -= 1

            block_len = end - start
            actual_data_lines = count_actual_data_lines(lines, start, end)

            if (
                block_len >= min_lines
                and actual_data_lines >= max(1, min_lines // 2)
                and validate_block(lines, start, end)
            ):
                blocks.append((start, end))

            i = max(end, i + 1)
        else:
            i += 1

    return blocks


from pathlib import Path


def generate_include_line(target_path: Path, base_dir: Path) -> str:
    """Generate ASM6-compatible incsrc line using a path *relative to base_dir*.
    base_dir should be the directory of the main ASM file being written (i.e., out.parent).
    """
    try:
        rel = Path(target_path).resolve().relative_to(Path(base_dir).resolve())
    except Exception:
        # Fallback if different drives on Windows: use os.path.relpath-style behavior
        try:
            rel = Path(pathlib.PurePath(*(Path(target_path).parts)))
        except Exception:
            rel = Path(target_path)
    path_str = rel.as_posix()
    return f'incsrc "{path_str}"'


def backup_file(filepath):
    """Create backup of original file."""
    backup_path = filepath.with_suffix(filepath.suffix + ".backup")
    counter = 1
    while backup_path.exists():
        backup_path = filepath.with_suffix(
            "{}.backup{}".format(filepath.suffix, counter)
        )
        counter += 1

    backup_path.write_bytes(filepath.read_bytes())
    return backup_path


def route_relpath(base_dir: pathlib.Path, base_name: str) -> pathlib.Path:
    low = base_name.lower()

    if "music" in low or "fanfare" in low or "channel" in low:
        return base_dir / "music" / base_name
    if "layout" in low or "phase" in low:
        return base_dir / "layouts" / base_name

    return base_dir / base_name


def coalesce_small_blocks(lines, blocks, max_total=40, gap_limit=3):
    """Merge adjacent small blocks when separated only by <= gap_limit lines
    of comments/blank lines, and total merged size <= max_total.
    Reduces tiny-file spam without changing assembled output.
    """
    if not blocks:
        return blocks

    merged = []
    cur_s, cur_e = blocks[0]

    def gap_ok(a_end, b_start):
        gap = lines[a_end:b_start]
        return all(is_comment_or_blank(x) for x in gap) and len(gap) <= gap_limit

    for s, e in blocks[1:]:
        if gap_ok(cur_e, s) and (e - cur_s) <= max_total:
            cur_e = e  # extend current merged window
        else:
            merged.append((cur_s, cur_e))
            cur_s, cur_e = s, e

    merged.append((cur_s, cur_e))
    return merged


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

    # Show Python version info if verbose
    if args.verbose:
        print(
            "Python version: {}.{}.{}".format(
                sys.version_info.major, sys.version_info.minor, sys.version_info.micro
            )
        )

    src = pathlib.Path(args.infile)
    out = pathlib.Path(args.outfile)
    data_dir = pathlib.Path(args.data_dir)

    if not src.exists():
        print("Error: Input file '{}' not found".format(src), file=sys.stderr)
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
            print("Using assembler: {}".format(assembler))

    # Read source file
    try:
        lines = src.read_text(encoding="utf-8", errors="ignore").splitlines()
    except Exception as e:
        print("Error reading '{}': {}".format(src, e), file=sys.stderr)
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

    blocks_info = find_data_blocks(lines, args.min_lines)
    blocks_info = coalesce_small_blocks(lines, blocks_info, max_total=40, gap_limit=3)
    if not blocks_info:
        print("No suitable data blocks found.")
        if args.verbose:
            print(
                "Searched {} lines with min_lines={}".format(len(lines), args.min_lines)
            )
        return 0

    # Process blocks
    edits = []
    blocks = []

    for start, end in blocks_info:
        block_text = "\n".join(lines[start:end]) + "\n"

        # Generate filename
        label = detect_first_label(lines, start, end)
        base = sanitize_name(label or "block_{}".format(start + 1))
        hash_suffix = hash_block(block_text)
        fname = "{}_{}_{}.asm".format(base, str(start + 1).zfill(5), hash_suffix)
        relpath = route_relpath(data_dir, fname)
        inc_line = generate_include_line(relpath, base_dir=out.parent)

        edits.append((start, end, inc_line))
        blocks.append((relpath, block_text))

        if args.verbose:
            actual_lines = count_actual_data_lines(lines, start, end)
            print(
                "Block {}: lines {}-{}, {} total/{} data -> {}".format(
                    len(blocks), start + 1, end, end - start, actual_lines, fname
                )
            )

    # Show summary
    print("Found {} data block(s) to extract:".format(len(blocks)))
    for i, (path, _) in enumerate(blocks):
        start, end, _ = edits[i]
        print("  {} (lines {}-{})".format(path.name, start + 1, end))

    if args.dry_run:
        print("\n[DRY RUN] No files would be written.")
        if args.verify:
            print("Verification would be performed if not in dry-run mode.")
        return 0

    # Create backup if requested and overwriting
    if args.backup and src == out and src.exists():
        backup_path = backup_file(src)
        print("Created backup: {}".format(backup_path))

    # Check for existing files
    if not args.force:
        existing = [p for p, _ in blocks if p.exists()]
        if existing:
            print(
                "Error: {} data files already exist. Use --force to overwrite:".format(
                    len(existing)
                )
            )
            for p in existing[:5]:  # Show first 5
                print("  {}".format(p))
            if len(existing) > 5:
                print("  ... and {} more".format(len(existing) - 5))
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
                print("Wrote: {}".format(relpath))
    except Exception as e:
        print("Error writing data files: {}".format(e), file=sys.stderr)
        return 1

    # Write main file
    try:
        out.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
        print("Wrote main file: {}".format(out))
    except Exception as e:
        print("Error writing main file: {}".format(e), file=sys.stderr)
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
                    " Verification passed: Split result assembles to identical binary"
                )
            else:
                print(
                    "WARNING: Split result assembles successfully but produces different binary"
                )
                print("Original hash: {}...".format(original_hash[:16]))
                print("Split hash:    {}...".format(split_hash[:16]))
                print("This may indicate a problem with the splitting logic.")
                return 1

    print("Successfully split {} data blocks.".format(len(blocks)))
    if assembler:
        print("Manual verification: {} {} output.nes".format(assembler, out))

    return 0


if __name__ == "__main__":
    sys.exit(main())
