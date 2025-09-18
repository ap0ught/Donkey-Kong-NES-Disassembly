; Macro for handling conditional storage of a value (0 or 1, possibly inverted) to a memory address.
; Used in several locations that require the same logic, with minor differences between JP and other versions.

; Variable to determine the branch distance between result=1 and result=0
; (Used with Macro_ReturnA for correct code flow in different versions)

; Make sure Version is defined first
.ifndef Version                         ; Assembly directive: check if Version symbol is not defined
Version = US    ; Default to US version ; Set default version if not previously defined
.endif                                  ; End of conditional assembly block

; Calculate branch distance based on version differences
If Version = JP
  ReturnABranchDist = 5				; JP version: includes JMP, so branch is longer
else
  ReturnABranchDist = 3				; Other versions: shorter branch, no JMP
endif

; Macro_ReturnA
; Parameters:
;   StoringAddress - Address to store the result (0 or 1, possibly inverted)
;   InvertFlag     - If set to 1, inverts the stored value (0->1, 1->0)
;
; JP version stores the value to memory and uses a JMP for code flow.
; Other versions simply load the value and return.
Macro Macro_ReturnA StoringAddress,InvertFlag  ; Define macro with two parameters
If Version = JP                         ; Conditional assembly: JP version path
  LDA #$00^InvertFlag			; Load 0 (or 1 if inverted) - XOR operation with InvertFlag
  JMP StoreVal				; Jump to store and return (unconditional jump)

  LDA #$01^InvertFlag			; Load 1 (or 0 if inverted) - XOR operation with InvertFlag

StoreVal:                               ; Label for storage routine
  STA StoringAddress			; Store result to memory address specified by parameter
  RTS					; Return from subroutine to caller
else                                    ; Non-JP version path
  LDA #$00^InvertFlag			; Load 0 (or 1 if inverted) - XOR operation with InvertFlag
  RTS					; Return immediately with value in accumulator

  LDA #$01^InvertFlag			; Load 1 (or 0 if inverted) - XOR operation with InvertFlag
  RTS					; Return immediately with value in accumulator
endif                                   ; End of version-specific conditional assembly
endm                                    ; End of macro definition
