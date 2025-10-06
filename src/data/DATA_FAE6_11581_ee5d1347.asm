db $8D,$8D,$8C,$8C,$8B,$8C,$83,$83
db $8F,$8F,$8F,$8F,$8D,$85,$84

;sweep values for Jump SFX (if bit 7 is clear (values below $80) sweep is disabled)
DATA_FAF5:
db $85,$7F,$85,$85,$85,$7F,$8D,$8D
db $8D,$8D,$8D

;first three bytes are unused

ChannelFrequencyLookup_FB00:
db $07,$F0,$00					;first 3 bytes are unused

db $00,$00,$69,$00,$53,$00,$46,$00
db $D4,$00,$BD,$00,$A8,$00,$9F,$00
db $8D,$00,$7E,$01,$AB,$01,$7C,$01
db $52,$01,$3F,$01,$1C,$00,$FD,$00
db $EE,$00,$E1,$03,$57,$02,$F9

;unused
db $02,$CF
;---

db $02,$A6,$02,$80,$02,$3A,$02,$1A
db $01,$FC,$01,$DF,$01,$C4,$06,$AE
db $05,$9E,$05,$4D,$05,$01,$04,$75
db $04,$35,$03,$F8,$03,$BF,$03,$89

;note length data
ChannelLengthLookup_FB4C:
db $05,$0A,$14,$28,$50,$1E,$3C,$0B
db $06,$0C,$18,$30,$60,$24

db $48						;unused

db $07,$0D,$1A,$34,$78,$27,$4E

;TriangleNoteLength_FB62:
DATA_FB62:
db $0A,$08,$05,$0A,$09

;player dead square frequency values
DATA_FB67:
db $50,$40,$46,$4A,$50,$56,$5C,$64
db $6C,$74,$7C,$88,$90,$9A
