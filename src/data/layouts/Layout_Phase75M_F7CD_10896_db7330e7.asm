db $3F,$00
db $08
db $0F,$15,$2C,$06
db $0F,$30,$27,$16

db $3F,$1D
db $03
db $12,$37,$15

db $23,$C0
db $08|VRAMWriteCommand_Repeat
db $FF

db $23,$C9
db $02
db $AA,$22

db $23,$CD
db $03|VRAMWriteCommand_Repeat
db $0F

db $23,$D1
db $02|VRAMWriteCommand_DrawVert
db $84,$48

db $23,$D7
db $05
db $03,$0C,$88,$00,$88

db $23,$E1
db $03
db $88,$00,$88

db $23,$E9
db $03
db $88,$00,$88

db $23,$D3
db $02|VRAMWriteCommand_DrawVert
db $84,$48

db $20,$2C
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $20,$2A
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $20,$CA
db $03|VRAMWriteCommand_Repeat
db $30

db $20,$AD
db $06|VRAMWriteCommand_Repeat
db $30

db $20,$D2
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$02
db $15|VRAMWriteCommand_Repeat
db $30

db $21,$06
db $02
db $5E,$5F

db $21,$26
db $02
db $5C,$5D

db $21,$0E
db $02
db $5E,$5F

db $21,$2E
db $02
db $5C,$5D

db $23,$61
db $1E|VRAMWriteCommand_Repeat
db $30

db $23,$46
db $02
db $5C,$5D

db $23,$66
db $02
db $60,$61

db $23,$4E
db $02
db $5C,$5D

db $23,$6E
db $02
db $60,$61

db $21,$46
db $10|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $74

db $21,$47
db $10|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $75

db $21,$5C
db $02|VRAMWriteCommand_Repeat
db $30

db $21,$79
db $02|VRAMWriteCommand_Repeat
db $30

db $21,$96
db $02|VRAMWriteCommand_Repeat
db $30

db $21,$B2
db $03|VRAMWriteCommand_Repeat
db $30

db $21,$C2
db $03|VRAMWriteCommand_Repeat
db $30

db $21,$C9
db $04|VRAMWriteCommand_Repeat
db $30

db $21,$F9
db $05|VRAMWriteCommand_Repeat
db $30

db $22,$33
db $02|VRAMWriteCommand_Repeat
db $30

db $22,$56
db $02|VRAMWriteCommand_Repeat
db $30

db $22,$79
db $02|VRAMWriteCommand_Repeat
db $30

db $22,$9C
db $02|VRAMWriteCommand_Repeat
db $30

db $22,$82
db $03|VRAMWriteCommand_Repeat
db $30

db $22,$CA
db $03|VRAMWriteCommand_Repeat
db $30

db $22,$DB
db $03|VRAMWriteCommand_Repeat
db $30

db $22,$F8
db $02|VRAMWriteCommand_Repeat
db $30

db $23,$15
db $02|VRAMWriteCommand_Repeat
db $30

db $23,$22
db $03|VRAMWriteCommand_Repeat
db $30

db $23,$31
db $03|VRAMWriteCommand_Repeat
db $30

db $21,$36
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$7C
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$D3
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$E4
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$EA
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $21,$EC
db $07|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$19
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$A3
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $3F

db $22,$BC
db $01
db $3F

db $21,$82
db $02|VRAMWriteCommand_DrawVert
db $70,$71

db $21,$83
db $02|VRAMWriteCommand_DrawVert
db $72,$73

db $21,$1D
db $82|VRAMWriteCommand_DrawVert
db $6E,$6F

db $21,$4E
db $10|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $74

db $21,$4F
db $10|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $75

db VRAMWriteCommand_Stop

;VRAM Data for title screen (palettes, attributes and tiles)
Layout_TitleScreen_F8D9:

;Palette
db $3F,$00					;VRAM pos to write to
db $0D						;write 13 bytes
