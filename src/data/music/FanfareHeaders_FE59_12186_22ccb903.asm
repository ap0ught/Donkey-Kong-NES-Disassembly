db GameStartSoundHeader-FanfareHeaders_FE59
db PhaseCompleteSoundHeader-FanfareHeaders_FE59
db KongDefeatedSoundHeader-FanfareHeaders_FE59
db PhaseStartSoundHeader-FanfareHeaders_FE59
db KongFallingSoundHeader-FanfareHeaders_FE59
db ScoreSoundHeader-FanfareHeaders_FE59
db GamePauseSoundHeader-FanfareHeaders_FE59
db TitleScreenThemeSoundHeader-FanfareHeaders_FE59
db DeadPart2SoundHeader-FanfareHeaders_FE59

;Each fanfare has a header, with following format:
;1 byte - note length lookup offset
;2 bytes - sound data address, square 2 data (or square 1 for a couple of exceptions
;1 byte - triangle data offset
;1 byte - square 1 data offset

;if sound channel data offset is 0, that channel won't be used. square 2 is used for all tracks except for GameStart and DeadPart2, where square 1 is the primary channel

GameStartSoundHeader:
db $00
dw GameStartSoundData_FE8F
db GameStartTriangleData_FEAA-GameStartSoundData_FE8F	;<(DATA_FEAA-DATA_FE8F)
db $00

PhaseCompleteSoundHeader:
db $08
dw PhaseCompleteSoundData_FEB0
db $00
db PhaseCompleteSquare1Data_FEBC-PhaseCompleteSoundData_FEB0

KongDefeatedSoundHeader:
db $00
dw KongDefeatedSoundData_FECF
db $00
db KongDefeatedSquare1Data_FEE9-KongDefeatedSoundData_FECF

PhaseStartSoundHeader:
db $08
dw PhaseStartSoundData_FF05
db $00
db PhaseStartSquare1Data_FF10-PhaseStartSoundData_FF05

KongFallingSoundHeader:
db $00
dw KongFallingSoundData_FFAD
db $00
db KongFallingSquare1Data_FFB0-KongFallingSoundData_FFAD

ScoreSoundHeader:
db $00
dw ScoreSoundData_FFBE
db $00
db $00

GamePauseSoundHeader:
db $00
dw GamePauseSoundData_FFC4
db $00
db $00

;uses all channels
TitleScreenThemeSoundHeader:
db $0F
dw TitleScreenThemeSoundData_FF20
db TitleScreenThemeTriangleData_FF41-TitleScreenThemeSoundData_FF20
db TitleScreenThemeSquare1Data_FF5E-TitleScreenThemeSoundData_FF20

DeadPart2SoundHeader:
db $00
dw DeadPart2SoundData_FFA1
db DeadPart2TriangleData_FFA9-DeadPart2SoundData_FFA1
db $00

;Fanfare 1 - Game Start

;Square. Apparently, it's the only fanfare that has square ONE as primary channel, instead of square TWO
GameStartSoundData_FE8F:
db $86,$46,$82,$4A,$83,$26,$46,$80
db $34,$32,$34,$32,$34,$32,$34,$32
db $34,$32,$34,$32,$34,$32,$34,$32
db $84,$34,$00

GameStartTriangleData_FEAA:
db $A9,$AC,$EE,$E8,$33,$35

;Fanfare 2 - Phase Complete

PhaseCompleteSoundData_FEB0:
db $16,$16,$57,$1E,$20,$64,$9E,$1E
db $20,$64,$9E,$00

PhaseCompleteSquare1Data_FEBC:
db $80,$30,$30,$85,$30,$80,$1A,$1C
db $81,$1E,$82,$1A,$80,$1A,$1C,$81
db $1E,$82,$1A

;Fanfare 3 - Kong Defeated (Ending Theme)

KongDefeatedSoundData_FECF:
db $5E,$5E,$5C,$5C,$5A,$5A,$58,$58
db $57,$16,$18,$9A,$96,$59,$18,$1A
db $9C,$98,$5F,$5E,$60,$5E,$5C,$5A
db $1F,$00

KongDefeatedSquare1Data_FEE9:
db $81,$1A,$1A,$18,$18,$16,$16,$38
db $38,$82,$26,$42,$26,$42,$28,$46
db $28,$46,$30,$28,$30,$28,$81,$3A
db $85,$3C,$84,$3A

;Fanfare 4 - Phase Start

PhaseStartSoundData_FF05:
db $5E,$02,$20,$42,$4A,$42,$60,$5E
db $60,$1D,$00

PhaseStartSquare1Data_FF10:
db $82,$26,$42,$26,$42,$81,$40,$80
db $42,$44,$48,$26,$28,$2C,$83,$2E

;Fanfare 8 - Title Theme

TitleScreenThemeSoundData_FF20:
db $56,$56,$E0,$42,$5A,$5E,$5C,$99
db $58,$58,$E2,$42,$5E,$60,$5E,$9B
db $5A,$5A,$CA,$42,$60,$62,$4A,$8D
db $5C,$5E,$E0,$42,$5A,$5C,$5E,$1D
db $00

TitleScreenThemeTriangleData_FF41:
db $82,$6F,$6E,$EE,$71,$70,$F0,$77
db $76,$F6,$57,$56,$D6,$A0,$9A,$96
db $B4,$A2,$9C,$98,$B6,$5C,$9C,$96
db $57,$5C,$96,$74,$2F

TitleScreenThemeSquare1Data_FF5E:
db $85,$02,$81,$2E,$34,$2E,$83,$34
db $81,$48,$28,$30,$28,$30,$28,$85
db $30,$81,$30,$36,$30,$83,$36,$81
db $26,$2C,$30,$2C,$30,$2C,$16,$16
db $1A,$16,$34,$16,$1A,$16,$34,$16
db $1C,$18,$36,$18,$1C,$18,$36,$18
db $16,$2E,$80,$16,$36,$34,$36,$83
db $16,$81,$02,$2E,$80,$16,$36,$34
db $30,$86,$2E

;Fanfare 9 - Death

DeadPart2SoundData_FFA1:
db $81,$1A,$82,$1E,$30,$83,$16,$00

DeadPart2TriangleData_FFA9:
db $42,$96,$B0,$E6

;Fanfare 5 - Kong is Falling

KongFallingSoundData_FFAD:
db $03,$83,$00

KongFallingSquare1Data_FFB0:
db $87,$42,$3E,$42,$3E,$42,$3E,$42
db $3E,$42,$3E,$42,$82,$3E

;Fanfare 6 - Score

ScoreSoundData_FFBE:
db $0A,$0C,$0E,$54,$90,$00

;Fanfare 7 - Pause sound

GamePauseSoundData_FFC4:
db $04,$12,$04,$12,$04,$12,$04,$92
db $00      

;music data starts here
MusicDataOffsets_FFCD:
db Phase25MMusicData_FFD4-MusicData_FFD4	;25M theme
db Phase25MMusicData_FFD4-MusicData_FFD4	;\
db Phase25MMusicData_FFD4-MusicData_FFD4	;|duplicates of 25M
db Phase25MMusicData_FFD4-MusicData_FFD4	;/
db Phase100MMusicData_FFDD-MusicData_FFD4	;100M theme
db HurryUpMusicData_FFE2-MusicData_FFD4		;HURRY UP!!!
db HammerMusicData_FFE6-MusicData_FFD4		;hammer theme
