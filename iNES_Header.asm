; iNES Header definition for Donkey Kong NES
; This header is required for NES emulators to recognize the ROM format and hardware mapping.

MAPPER = 0					; Mapper number (0 = NROM, no bank switching)
MIRRORING = 0					; Mirroring type: 0 = horizontal, 1 = vertical
REGION = 0					; Console region: 0 = NTSC, 1 = PAL

db "NES",$1A					; Constant iNES identifier ("NES" + MS-DOS EOF)

; PRG ROM size (in 16KB units)
If Version = Gamecube
  db $02					; Gamecube version: 2 x 16KB PRG ROM banks (32KB total)
else
  db $01					; Standard: 1 x 16KB PRG ROM bank (16KB total)
endif

If MAPPER > 15
  error "Mapper value too large for iNES 1.0 format"
endif

db $01						; CHR ROM size (in 8KB units): 1 x 8KB CHR ROM bank

; Flags 6: [....NNMM]
;   N = Mapper lower nibble (bits 4-7)
;   M = Mirroring (bit 0: 0=horizontal, 1=vertical)
db (MAPPER<<4)&$F0|MIRRORING	    ; Set mirroring and lower nibble of mapper

; Flags 7: [MMMM....]
;   M = Mapper upper nibble (bits 4-7)
db MAPPER&$F0					; Set upper nibble of mapper (should be 0 for NROM)

db $00						; PRG RAM size (unused, 0 = default 8KB if needed)
db REGION					; TV system: 0 = NTSC, 1 = PAL

db $00,$00,$00,$00,$00,$00			; Unused padding bytes (set to zero for iNES 1.0)
