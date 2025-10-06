db $0F,$27,$27,$27				;tile palette 1
db $0F,$30,$30,$30				;tile palette 2
db $0F						;so, you're telling me that palette 3 has only a single color update?

db $3F,$11					;next location
db $01						;a single byte of update (sprite palette 0, used for cursor)
db $25						;

db $23,$E0
db $10|VRAMWriteCommand_Repeat			;16 bytes of repeated update
db $55

db $23,$F0
db $08|VRAMWriteCommand_Repeat
db $AA

;from here actually draw title screen
db $20,$83
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$84
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$85
db $01
db $62

db $21,$05
db $01
db $62

db $20,$A6
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$88
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$89
db $01
db $62

db $21,$09
db $01
db $62

db $20,$8A
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$8C
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$AD
db $C2
db $62

db $20,$CE
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$8F
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$91
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$B2
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$B3
db $01
db $62

db $20,$94
db $01
db $62

db $20,$F3
db $01
db $62

db $21,$14
db $01
db $62

db $20,$96
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$97
db $02|VRAMWriteCommand_Repeat
db $62

db $20,$D7
db $02|VRAMWriteCommand_Repeat
db $62

db $21,$17
db $02|VRAMWriteCommand_Repeat
db $62

db $20,$9A
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$DB
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $20,$9C
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$47
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$68
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$69
db $01
db $62

db $21,$4A
db $01
db $62

db $21,$A9
db $01
db $62

db $21,$CA
db $01
db $62

db $21,$4C
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$4D
db $01
db $62

db $21,$CD
db $01
db $62

db $21,$4E
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$50
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$71
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$92
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$53
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$55
db $05|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$56
db $03|VRAMWriteCommand_Repeat
db $62

db $21,$D6
db $03|VRAMWriteCommand_Repeat
db $62

db $21,$98
db $02|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $62

db $21,$97
db $01
db $62

;this is where strings are stored (1 PLAYER GAME A, 2 PLAYER GAME B, etc.)

;1 PLAYER GAME A
db $22,$09
db $0F
db $01,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0A

;1 PLAYER GAME B
db $22,$49
db $0F
db $01,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0B

;2 PLAYER GAME A
db $22,$89
db $0F
db $02,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0A

;2 PLAYER GAME B
db $22,$C9
db $0F
db $02,$24,$19,$15,$0A,$22,$0E,$1B
db $24,$10,$0A,$16,$0E,$24,$0B

;(c)1981 NINTENDO CO.,LTD.
db $23,$05
db $16
db $D3,$01,$09,$08,$01,$24,$17,$12
db $17,$1D,$0E,$17,$0D,$18,$24,$0C
db $18,$65,$15,$1D,$0D,$64

;MADE IN JAPAN
db $23,$4B
db $0D
db $16,$0A,$0D,$0E,$24,$12,$17,$24
db $13,$0A,$19,$0A,$17

db VRAMWriteCommand_Stop

;data for hud - score symbols (I, II, TOP) and other counters
Layout_HUD_FA1B:
db $20,$63
db $01						;I
db $FF

db $20,$6D
db $03
db $D0,$D1,$D2					;word TOP

db $20,$76
db $02
db $FE,$FF					;II

db $20,$94
db $0A						;top of lives/bonus/loop counters portion
db $25,$16,$2A,$26,$27,$28,$29,$2A
db $15,$2D

db $20,$B4
db $0A
db $2B,$24,$2C,$24,$24,$24,$24,$2C		;empty tiles (default is 24) are for values to be written later
db $24,$2F

db VRAMWriteCommand_Stop
