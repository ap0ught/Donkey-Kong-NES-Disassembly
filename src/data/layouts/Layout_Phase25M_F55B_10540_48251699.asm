db $3F,$00
db $20
db $0F,$15,$2C,$12				;all background palettes
db $0F,$27,$02,$17
db $0F,$30,$36,$06
db $0F,$30,$2C,$24

db $0F,$02,$36,$16				;sprite palettes
db $0F,$30,$27,$24
db $0F,$16,$30,$37
db $0F,$06,$27,$02

;after palette there are attributes
db $23,$C0
db $08|VRAMWriteCommand_Repeat
db $FF						;very top of the screen (where score is at)

db $23,$C8
db $03
db $55,$AA,$22					;barrels, Donkey Kong and a little bit of platform to the side

db $23,$CD
db $03|VRAMWriteCommand_Repeat
db $0F

;the actual stage layout
db $20,$2C
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $20,$81
db $04|VRAMWriteCommand_DrawVert
db $50,$51,$52,$53

db $20,$82
db $04|VRAMWriteCommand_DrawVert
db $54,$55,$56,$57

db $20,$83
db $04|VRAMWriteCommand_DrawVert
db $58,$59,$5A,$5B

db $20,$2A
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $20,$AD
db $06|VRAMWriteCommand_Repeat
db $30

db $20,$CA
db $03|VRAMWriteCommand_Repeat
db $30

db $20,$D2
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$02
db $0E|VRAMWriteCommand_Repeat
db $30

db $21,$10
db $0C
db $3E,$3E,$45,$3D,$3D,$3D,$3C,$3C
db $3C,$3B,$3B,$3B

db $21,$2D
db $0F
db $3F,$24,$24,$37,$37,$37,$36,$36
db $36,$35,$35,$35,$49,$34,$34

db $21,$59
db $01
db $3F

db $21,$6D
db $11
db $40,$38,$38,$39,$39,$39,$3A,$3A
db $3A,$3B,$3B,$3B,$43,$3C,$3C,$3D
db $3D

db $21,$84
db $1A
db $3D,$3D,$3D,$3E,$3E,$3E,$30,$30
db $30,$31,$31,$31,$32,$32,$32,$33
db $33,$33,$34,$49,$34,$35,$35,$35
db $36,$36

db $21,$A4
db $06
db $36,$36,$4B,$37,$37,$37

db $21,$C6
db $01
db $3F

db $21,$E2
db $17
db $30,$30,$3E,$3E,$45,$3D,$3D,$3D
db $3C,$43,$3C,$3B,$3B,$3B,$3A,$3A
db $3A,$39,$39,$39,$38,$40,$38

db $21,$AB
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$04
db $18
db $37,$37,$37,$36,$36,$36,$4A,$35
db $35,$34,$34,$34,$48,$33,$33,$32
db $32,$32,$31,$31,$31,$30,$30,$30

db $22,$30
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$39
db $01
db $3F

db $22,$4A
db $01
db $3F

db $22,$59
db $05
db $40,$38,$38,$39,$39

db $22,$64
db $1A
db $39,$39,$39,$3A,$3A,$3A,$42,$3B
db $3B,$3C,$3C,$3C,$44,$3D,$3D,$3E
db $3E,$3E,$30,$30,$30,$31,$31,$31
db $32,$32

db $22,$84
db $12
db $32,$32,$47,$33,$33,$33,$34,$34
db $34,$35,$4A,$35,$36,$36,$36,$37
db $37,$37

db $22,$A6
db $01
db $3F

db $22,$AE
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$C2
db $0B
db $3B,$3B,$3A,$3A,$41,$39,$39,$39
db $38,$38,$38

db $22,$E2
db $1A
db $34,$34,$33,$33,$33,$32,$32,$32
db $31,$31,$46,$30,$30,$30,$3E,$3E
db $3E,$3D,$3D,$3D,$3C,$3C,$3C,$3B
db $3B,$3B

db $23,$0C
db $10
db $3F,$24,$24,$24,$37,$37,$37,$36
db $36,$36,$35,$35,$35,$49,$34,$34

db $23,$39
db $01
db $3F

db $23,$4C
db $13
db $3F,$24,$24,$24,$38,$38,$38,$39
db $39,$39,$3A,$3A,$3A,$42,$3B,$3B
db $3C,$3C,$3C

db $23,$61
db $0F|VRAMWriteCommand_Repeat
db $30

db $23,$70
db $0F
db $31,$31,$31,$32,$32,$32,$33,$33
db $33,$34,$34,$34,$35,$35,$35

db $23,$24
db $02|VRAMWriteCommand_DrawVert
db $4C,$4D

db $23,$25
db $02|VRAMWriteCommand_DrawVert
db $4E,$4F

db VRAMWriteCommand_Stop

;Phase 3 (100M)
Layout_Phase100M_F71C:
db $3F,$00					;palette changes
db $08						;
db $0F,$2C,$27,$02				;tile 0
db $0F,$30,$12,$24				;tile 1

db $3F,$1D
db $03
db $06,$30,$12					;?

db $23,$C0
db $08|VRAMWriteCommand_Repeat
db $FF

db $23,$C9
db $07
db $55,$00,$AA,$AA,$0F,$0F,$0F

db $23,$E2
db $05
db $04,$00,$00,$00,$01

db $20,$C5
db $02
db $70,$72

db $20,$E5
db $02
db $71,$73

db $20,$CA
db $02|VRAMWriteCommand_Repeat
db $62

db $21,$05
db $16|VRAMWriteCommand_Repeat
db $62

db $21,$A4
db $18|VRAMWriteCommand_Repeat
db $62

db $22,$43
db $1A|VRAMWriteCommand_Repeat
db $62

db $22,$E2
db $1C|VRAMWriteCommand_Repeat
db $62

db $23,$61
db $1E|VRAMWriteCommand_Repeat
db $62

db $21,$08
db $01
db $63

db $21,$17
db $01
db $63

db $21,$A8
db $01
db $63

db $21,$B7
db $01
db $63

db $22,$48
db $01
db $63

db $22,$57
db $01
db $63

db $22,$E8
db $01
db $63

db $22,$F7
db $01
db $63

db $21,$25
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$29
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$36
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$3A
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$C4
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$D0
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$DB
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$63
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$6C
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$73
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$7C
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $23,$02
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $23,$0F
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $23,$1D
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$0A
db $02|VRAMWriteCommand_DrawVert
db $6E,$6F

db $22,$18
db $02|VRAMWriteCommand_DrawVert
db $70,$71

db $22,$19
db $02|VRAMWriteCommand_DrawVert
db $72,$73

db VRAMWriteCommand_Stop
