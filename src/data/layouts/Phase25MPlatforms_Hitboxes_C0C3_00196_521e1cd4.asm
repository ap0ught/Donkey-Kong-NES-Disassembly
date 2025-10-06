db $00,$00					;\
db $80,$00					;/lowest platform extended part hitbox ($80 pixels wide)

db $00,$00
db $18,$00					;small platform bits, each higher than the previous ($18 pixels, which is 3 8x8 tiles long)

;platform collision "dimensions" that are unused? it's for 2 tile wide ones, but those still use 3 tile wide hitboxes (there's no handling for individual elevations, either all parts use 3 8x8 tiles or 2 8x8 hitbox)
;to be fair, you're blocked by the screen boundaries so you can't walk off these 2 tile elevations or go further than intended
UNUSED_C0CB:
db $00,$00
db $10,$00

;X, Y and table offset for platform end areas in 25M, if Jumpman walks off the ledge, he will fall
DATA_C0CF:
db $E0,$BC,$00
db $10,$9E,$00
db $E0,$80,$00
db $10,$62,$00
db $E0,$44,$00
db $FE
