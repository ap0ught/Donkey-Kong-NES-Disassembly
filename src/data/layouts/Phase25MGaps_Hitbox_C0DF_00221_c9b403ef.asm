db $00,$00
db $10,$03

;X, Y and collision table offset for all ladders from 25M level
DATA_C0E3:
db $C8,$BC,$08
db $C8,$80,$04
db $B8,$74,$10
db $68,$58,$14
db $C8,$44,$04
db $60,$CF,$0C
db $70,$9B,$00
db $30,$9E,$04
db $50,$85,$08
db $80,$7D,$00
db $30,$62,$04
db $58,$60,$00
db $90,$28,$18
db $FE						;no more ladders

;varying hitboxes for ladders for 25M
;format: x-offset, y-offset, width, height
DATA_C10B:
db $00,$00,$08,$1D				;all ladders are 8 pixels wide
db $00,$00,$08,$17
db $00,$00,$08,$18
db $00,$00,$08,$09
db $00,$00,$08,$0B
db $00,$00,$08,$07
db $00,$00,$08,$19

;ladder top positions for 25M level (broken ladders can't be climbed down from the top)
DATA_C127:
db $C8,$BC,$00
db $70,$9B,$00
db $30,$9E,$00
db $C8,$80,$00
db $80,$7D,$00
db $30,$62,$00
db $58,$60,$00
db $C8,$44,$00
db $90,$28,$00
db $FE

;top of the ladder hitbox. used to check where the player can go down the ladder and where the player's animation for climbing on top plays
DATA_C143:
db $00,$00
db $08,$0D

;Jumpman's animation frames when climbing on top of the platform
;Jumpman_GFXFrame_ClimbingFlipped - draw Jumpman_GFXFrame_Climbing with horz flip
DATA_C147:
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db Jumpman_GFXFrame_ClimbingFlipped,Jumpman_GFXFrame_ClimbingFlipped
db Jumpman_GFXFrame_ClimbPlat_Frame1,Jumpman_GFXFrame_ClimbPlat_Frame1
db Jumpman_GFXFrame_ClimbPlat_Frame2,Jumpman_GFXFrame_ClimbPlat_Frame2
db Jumpman_GFXFrame_ClimbPlat_Frame1,Jumpman_GFXFrame_ClimbPlat_Frame1
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db Jumpman_GFXFrame_ClimbPlat_IsOn,Jumpman_GFXFrame_ClimbPlat_IsOn

;most likely placeholder for in case more frames are needed for climbing animation (or they were intending to show these frames earlier?)
UNUSED_C155:
db Jumpman_GFXFrame_ClimbPlat_IsOn
db Jumpman_GFXFrame_ClimbPlat_IsOn
db Jumpman_GFXFrame_ClimbPlat_IsOn
db Jumpman_GFXFrame_ClimbPlat_IsOn

;this data is used to animate jumpman when climbing the ladder.
DATA_C159:
db Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing,Jumpman_GFXFrame_Climbing
db Jumpman_GFXFrame_ClimbingFlipped,Jumpman_GFXFrame_ClimbingFlipped,Jumpman_GFXFrame_ClimbingFlipped

;placeholder for above?
UNUSED_C15F:
db $00,$00

;broken ladder positions
DATA_C161:
db $60,$B7,$00					;those $00's don't matter (they're supposed to offset collision table, but there's only one hitbox for all broken ladders)
db $50,$7B,$00
db $B8,$5C,$00
db $68,$40,$00
db $FE

;hitbox dimensions for broken ladders. in this order: left, top, right, bottom (so the last two are width and height respectively)
BrokenLadder_Hitbox_C16E:
db $00,$00
db $08,$18

;ladder end destination for the barrels when they move down said ladder (first ladder to check)
DATA_C172:
db $CA,$A7,$8E,$6B,$51

;x-position of the ladder that the barrel can mode down (first ladder check)
DATA_C177:
db $5C,$2C,$4C,$2C,$64

;ladder destination for the barrels when they can move down the ladder (second ladder to check)
DATA_C17C:
db $C6,$AA,$8C,$6D,$4D				;y-positions that the barrel should reach to change from going down the ladder state to normal horizontal movement state (???)

;x-positions where the barrel can move down a ladder (once again, it's the second ladder check)
DATA_C181:
db $C4,$6C,$7C,$54,$C4

;these are jumpman's hitbox dimensions for platforms and ladders in 25M level (so he is correctly offset & interacts with environment)
;x-disp, y-disp, width, height
;8 pixels to the right, whopping 17 pixels down... and it's 10 pixels wide and 17 pixels tall?
;yes
;Jumpman_TileHitbox_C186:
DATA_C186:
db $08,$11
db $0A,$11

;unused table similar to above, which is vertically closer to jumpman by 1px
;doesn't have a pointer entry
;Jumpman_TileHitboxUNUSED_C18A:
UNUSED_C18A:
db $08,$10
db $0A,$11

;same as above, but used when jumpman is jumping/falling
;only difference is it's closer to jumpman on y-axis by TWO pixels!
;Jumpman_TileHitboxWhenAirborn_C18E:
DATA_C18E:
db $08,$0F
db $0A,$11

DATA_C192:
db $05,$01,$0C,$09

DATA_C196:
db $05,$05,$0A,$0A

UNUSED_C19A:
db $08,$10,$08,$10

DATA_C19E:
db $04,$04,$0C,$0D

;jumpman's animation frames for when holding a hammer
Jumpman_HammerWalkingAnimFrames_C1A2:
db Jumpman_GFXFrame_Walk2_HammerUp
db Jumpman_GFXFrame_Stand_HammerUp
db Jumpman_GFXFrame_Walk1_HammerUp
db Jumpman_GFXFrame_Walk2_HammerDown
db Jumpman_GFXFrame_Stand_HammerDown
db Jumpman_GFXFrame_Walk1_HammerDown

;platform heights at which the hammer can be grabbed
DATA_C1A8:
db $03,$05					;Phase 1
db $02,$03					;unused Phase 2 (seems to match the Arcade version's hammer positions)
db $00,$00					;Phase 3 doesn't have hammers
db $03,$04					;Phase 4

;hitbox dimensions for the hammer when it can be grabbed by the player
HammerPickup_Hitbox_C1B0:
db $00,$00
db $08,$08					;8 by 8 pixels

;boundary positions
DATA_C1B4:
db $10,$E0
db $10,$E0					;unused because there's no Phase 2
db $0C,$E0
db $08,$E8

;table representing each bit value
DATA_C1BC:
db $01,$02,$04,$08,$10,$20,$40,$80

;25m's platform shift x-positions used for barrels and flame enemies (to determine if they should go up or down the elevations)
DATA_C1C4:
db $13,$30,$48,$60,$78,$90,$A8,$C0,$E0

;edge x-positions for barrels to drop from to the lower platform (in case didn't go down any ladders)
DATA_C1CD:
db $13,$DB

;Y-posisions for the falling barrel to check for to know where the platforms are to land on (when falling off a higher platform)
DATA_C1CF:
db $4C,$6A,$88,$A6,$C5,$FE

;Y-posisions for the falling barrel to check for to know where the platforms are to bounce off (tossed by DK)
;this is for a straight moving one
DATA_C1D5:
db $53,$6B,$8F,$A7,$CA,$FE

;these y-position values are for an unused diagonal-moving pattern
UNUSED_C1DB:
db $52,$6E,$8C,$AC,$C5,$FE

;and lastly, the left and right moving one
DATA_C1E1:
db $52,$6C,$8E,$A8,$CA,$FE

DATA_C1E7:
db $00,$06,$08,$08				;hmm...

;a lonely value that could've been directly loaded with LDA #$xx, but noooooooooo, it has to be a 1 byte table
DATA_C1EB:
db $19

;enemy destruction frames (by hammer)
EnemyDestructionAnimationFrames_C1EC:
db EnemyDestruction_Frame1
db EnemyDestruction_Frame2
db EnemyDestruction_Frame1
db EnemyDestruction_Frame2
db EnemyDestruction_Frame1
db EnemyDestruction_Frame2
db EnemyDestruction_Frame3
db EnemyDestruction_Frame4
db EnemyDestruction_Frame4
db EnemyDestruction_Frame4

;contains maximum amount of flame enemies that can be processed per-phase
;MaxNumberOfFlameEnemies_C1F6:
DATA_C1F6:
db $02,$04,$02,$04				;2 in 25M and 75M, 4 in 50M (unused) and 100M

;this table stores which platform marks the end of the phase when Jumpman reaches it
;PhaseCompletePlatformIndex_C1FA:
DATA_C1FA:
db $07,$05,$07					;for first 3 phases, with phase 2 obviously being unused

;max amount of entitites
DATA_C1FD:
db $09,$03

;springboards x-pos when spawned (RNG dependent)
DATA_C1FF:
db $00,$00,$04,$08

UNUSED_C203:
db $01,$02,$03,$04

;bonus score values (hundreds)
InitialBONUSScore_C207:
db $50,$60,$70,$80

UNUSED_C20B:
db $90						;unused bonus score counter value, it's capped at 8000.

;X/Y coordinates and collision data offset for all of 75M's platforms (collision data is at DATA_C252)
DATA_C20C:
db $0E,$D8,$18
db $0E,$C8,$04
db $86,$C8,$04
db $A6,$C0,$00
db $BE,$B8,$00
db $D6,$B0,$04
db $4E,$B0,$04
db $0E,$A0,$04
db $DE,$A0,$00
db $C6,$98,$00
db $AE,$90,$00
db $96,$88,$14
db $C6,$78,$0C
db $0E,$70,$04
db $46,$70,$08
db $8E,$68,$04
db $AE,$60,$00
db $C6,$58,$00
db $DE,$50,$00
db $66,$40,$10
db $86,$28,$00
db $FE

Phase75MPlatformYPositions_C24C:
db $B0,$78,$60,$40,$28,$FF

;hitboxes for 75M's platforms, only really contains widths
DATA_C252:
db $00,$00,$14,$00
db $00,$00,$1C,$00
db $00,$00,$24,$00
db $00,$00,$2C,$00
db $00,$00,$54,$00
db $00,$00,$12,$00
db $00,$00,$E4,$00

;X/Y coordinates and collision data offset for all of 75M's ladders (collision data is at DATA_C28D)
DATA_C26E:
db $18,$A0,$0C
db $20,$70,$10
db $50,$70,$14
db $60,$70,$14
db $98,$68,$08
db $C8,$78,$08
db $E0,$A0,$00
db $E0,$50,$0C
db $B0,$40,$08
db $90,$28,$04
db $FE

;hitboxes for ladders
DATA_C28D:
db $00,$00,$08,$10
db $00,$00,$08,$18
db $00,$00,$08,$20
db $00,$00,$08,$28
db $00,$00,$08,$30
db $00,$00,$08,$40

;ladder top positions for 75M level
DATA_C2A5:
db $18,$A0,$00
db $20,$70,$00
db $50,$70,$00
db $60,$70,$00
db $98,$68,$00
db $C8,$78,$00
db $E0,$A0,$00
db $E0,$50,$00
db $B0,$40,$00
db $90,$28,$00
db $FE

;collision/hitbox/what have you dimensions for... something.
UNUSED_C2C4:
db $04,$01
db $1B,$0E

;hitbox dimensions for moving platforms (75M)
MovingPlatform_Hitbox_C2C8:
db $00,$01
db $12,$01				;$12 (decimal 18) pixels wide, only 1 pixel high

;OAM slots for moving platforms from phase 2 (75M)
MovingPlatform_OAMSlots_C2CC:
db (PlatformSprite_OAM_Slot*4)
db (PlatformSprite_OAM_Slot*4)+8
db (PlatformSprite_OAM_Slot*4)+16
db (PlatformSprite_OAM_Slot*4)+24
db (PlatformSprite_OAM_Slot*4)+32
db (PlatformSprite_OAM_Slot*4)+40

;indexes between the first ladder and the last ladder to check on the same platform (for flame enemies)
DATA_C2D2:
db $00						;this single byte is actually unused
db $00,$09,$15,$18

UNUSED_C2D7:
db $00						;and this last one I guess

;ladder check stuff for flame enemies (75M)
;First Byte - Ladder's X-position, second byte - ladder's vertical end point, third byte - a state the flame enemy enters when at the position (climb up or down the ladder)
DATA_C2D8:
db $4C,$5F,FlameEnemy_State_LadderUp
db $5C,$5F,FlameEnemy_State_LadderUp
db $C4,$67,FlameEnemy_State_LadderUp
db $4C,$9F,FlameEnemy_State_LadderDown
db $5C,$9F,FlameEnemy_State_LadderDown
db $C4,$87,FlameEnemy_State_LadderDown
db $DC,$3F,FlameEnemy_State_LadderUp
db $DC,$67,FlameEnemy_State_LadderDown

;X/Y coordinates and collision data offset for all of 100M's platforms (collision data is at DATA_C306)
DATA_C2F0:
db $06,$D8,$00
db $06,$B8,$00
db $16,$90,$04
db $1E,$68,$08
db $26,$40,$0C
db $FE

Phase100MPlatformYPositions_C300:
db $B8,$90,$68,$40,$28,$FF

;all different platform hitboxes for 100M (again, only width matters)
DATA_C306:
db $00,$00,$F5,$00
db $00,$00,$D5,$00
db $00,$00,$C5,$00
db $00,$00,$B5,$00

;X/Y coordinates and collision data offset for all of 100M's ladders (collision data is at DATA_C341)
DATA_C316:
db $10,$B8,$00
db $78,$B8,$00
db $E8,$B8,$00
db $18,$90,$04
db $60,$90,$04
db $98,$90,$04
db $E0,$90,$04
db $20,$68,$04
db $80,$68,$04
db $D8,$68,$04
db $28,$40,$04
db $48,$40,$04
db $B0,$40,$04
db $D0,$40,$04
db $FE

;only two different ladder heights
DATA_C341:
db $00,$00,$08,$20
db $00,$00,$08,$28

;Ladder top positions for 100M level
DATA_C349:
db $10,$B8,$00
db $78,$B8,$00
db $E8,$B8,$00
db $18,$90,$00
db $60,$90,$00
db $98,$90,$00
db $E0,$90,$00
db $20,$68,$00
db $80,$68,$00
db $D8,$68,$00
db $28,$40,$00
db $48,$40,$00
db $B0,$40,$00
db $D0,$40,$00
db $FE

;indexes between the first ladder and the last ladder to check on the same platform
DATA_C374:
db $00,$09,$1E,$33,$48,$54

DATA_C37A:
db $0C,$A7,FlameEnemy_State_LadderUp
db $74,$A7,FlameEnemy_State_LadderUp
db $E4,$A7,FlameEnemy_State_LadderUp
db $0C,$C7,FlameEnemy_State_LadderDown
db $74,$C7,FlameEnemy_State_LadderDown
db $E4,$C7,FlameEnemy_State_LadderDown
db $14,$7F,FlameEnemy_State_LadderUp
db $5C,$7F,FlameEnemy_State_LadderUp
db $94,$7F,FlameEnemy_State_LadderUp
db $DC,$7F,FlameEnemy_State_LadderUp
db $1C,$57,FlameEnemy_State_LadderUp
db $7C,$57,FlameEnemy_State_LadderUp
db $D4,$57,FlameEnemy_State_LadderUp
db $14,$A7,FlameEnemy_State_LadderDown
db $5C,$A7,FlameEnemy_State_LadderDown
db $94,$A7,FlameEnemy_State_LadderDown
db $DC,$A7,FlameEnemy_State_LadderDown
db $24,$2F,FlameEnemy_State_LadderUp
db $44,$2F,FlameEnemy_State_LadderUp
db $AC,$2F,FlameEnemy_State_LadderUp
db $CC,$2F,FlameEnemy_State_LadderUp
db $1C,$7F,FlameEnemy_State_LadderDown
db $7C,$7F,FlameEnemy_State_LadderDown
db $D4,$7F,FlameEnemy_State_LadderDown
db $24,$57,FlameEnemy_State_LadderDown
db $44,$57,FlameEnemy_State_LadderDown
db $AC,$57,FlameEnemy_State_LadderDown
db $CC,$57,FlameEnemy_State_LadderDown

;X and Y positions for flame enemy spawns (100M)
;Init_100M_FlameEnemy_XYPos_C3CE:
DATA_C3CE:
db $08,$C7
db $10,$A7
db $18,$7F
db $20,$57
db $E8,$C7
db $E0,$A7
db $D8,$7F
db $D0,$57

;gap edge x positions in 100M, to prevent flame enemies from walking off
DATA_C3DE:
db $34,$AC
db $44,$BC

DATA_C3E2:
db $05,$03
db $0D,$0B

;platform edges where the flame enemies will stop moving, 25M, second platform
DATA_C3E6:
db $D4,$0C

;platform edges where the flame enemies will stop moving, 25M, first platform (at the very bottom)
DATA_C3E8:
db $E4,$0C

;platform edges, 75M, platform level 2, left platform
DATA_C3EA:
db $5D,$4B

;platform edges, 75M, platform level 2, right platform
DATA_C3EC:
db $CD,$C3

DATA_C3EE:
db $5D,$43

DATA_C3F0:
db $E5,$C3

DATA_C3F2:
db $ED,$03

;16-bit ladder movement update frequency for flame enemies, bitwise (bit set - move, otherwise don't), 25M
;first entry is for moving up the ladder, the second is moving down (moving down is faster)
DATA_C3F4:
dw %0100100100100100			;update every 3 frames with one exception of 4 frames
dw %0111011101110111			;don't update every 4th frame

;db $24,$49,$77,$77

;16-bit ladder movement update frequency for flame enemies, bitwise (bit set - move, otherwise don't), 100M
;same deal as above table
DATA_C3F8:
dw %0111011101110111
dw %1111111111111111

;db $77,$77,$FF,$FF

;x-positions, at which the y-position of the barrel gets affected during its bounce when it lands on a lower platform
;when bouncing to the right
DATA_C3FC:
db $0B,$0C,$0D,$15,$16,$17,$18,$19
db $1A,$1E,$1F

;y-position "speeds" for bouncing barrel's motion
DATA_C407:
db $FF,$FF,$FF
db $01,$01,$01,$01
db $FF,$FF
db $01,$01

;x-positions, at which the y-position of the barrel gets affected during its bounce when it lands on a lower platform
;when bouncing to the left
DATA_C412:
db $E4,$E3,$E2,$D8,$D7,$D6,$D5,$D4
db $D3,$D0,$CF

DATA_C41D:
db $48,$84,$C0

DATA_C420:
db $50,$8D,$C7

;x and y positions for misc. hitboxes
DATA_C423:
db $20,$C0					;oil barrel's flame
db $78,$60					;phase 2 isn't real, phase 2 can't hurt you (unused)
db $28,$44					;top-left lift end for the lifts that go upward (there's a special check and individual x/y offsets for the bottom-right one that aren't in a table)
db $6B,$20					;DK's hitbox pos

;misc. hitbox dimension pointers
DATA_C42B:
dw DATA_C433					;oil barrel flame hitbox (even if it hasn't been lit)
dw UNUSED_C437					;phase 2? never heard about such a thing
dw DATA_C43B					;lift ends
dw DATA_C43F					;DK

;remember format:
;offsets for top-left hitbox corner (X, Y)
;offsets for bottom-right hitbox corner (X, Y), basically width and height
DATA_C433:
db $00,$00					;are these values non-zero somewhere, or are these basically a waste?
db $10,$08					;width, height

UNUSED_C437:
db $00,$00
db $10,$08

DATA_C43B:
db $00,$00
db $60,$10					;huh, it's that long? that explains why you can land on the left side of the lowest platform (and safely walk on the bottom-left lift end since it lacks a hitbox), but you die when you try to jump over the bottom-right lift

DATA_C43F:
db $00,$00
db $2A,$20

;table used for barrel throw timer setting (based on difficulty)
CODE_C443:
db $B0,$A0,$78,$68,$68

DATA_C448:
db $88,$88,$88,$88,$88

;vertical barrel toss timings for DK (based on difficulty)
;DKVerticalBarrelTossTimes_C44D:
DATA_C44D:
db $48,$38,$28,$18,$18

;unused times, also based on difficulty I assume (related to the scrapped 50M?)
UNUSED_C452:
db $BB,$BB,$5E,$2F,$13

;timer for the next springboard spawn, based on difficulty
;SpringboardSpawnTimes_C457:
DATA_C457:
db $88,$78,$64,$56,$49

;timings for moving platforms, move every x-frames based on difficulty (bit set - move)
;MovingPlatformUpdateFrequency1_C45C:
DATA_C45C:
db %10001000,%10001000,%00100100,%01010101,%01010101

;second set of bits for above
;MovingPlatformUpdateFrequency2_C461:
DATA_C461:
db %10001000,%10001000,%01001001,%01010101,%01010101

;number of frames between each flame enemy spawn for 100M, based on difficulty
;100MFlameEnemySpawnTimes_C466:
DATA_C466:
db $40,$20,$10,$08,$01

;hitboxes for platform collision on which the jumpman can stand on
UNUSED_C46B:
dw DATA_C08C					;25M (different collision and uses different tables)
dw DATA_C20C					;50M that totally exists in NES Donkey Kong (no it doesnt)

DATA_C46F:
dw DATA_C20C					;platform hitboxes of 75M
dw DATA_C2F0					;100M

UNUSED_C473:
dw DATA_C0C3					;again, 25M uses a different platform collision detection thanks to the platforms DK whrecked
dw DATA_C20C					;50M that totally doesnt exist in NES Donkey Kong (yes it doesnt, don't look that up)

DATA_C477:
dw DATA_C252
dw DATA_C306

;pointers for ladder bottom hitbox positions and collision offsets
DATA_C47B:
dw DATA_C0E3					;25M
dw DATA_C20C					;50M
dw DATA_C26E					;75M
dw DATA_C316					;100M

;various ladder bottom hitboxes per phase
DATA_C483:
dw DATA_C10B
dw DATA_C20C					;placeholder
dw DATA_C28D
dw DATA_C341

;pointers for ladder top hitbox positions and collision offsets
DATA_C48B:
dw DATA_C127
dw DATA_C20C					;GUESS WHAT THIS MEANS
dw DATA_C2A5
dw DATA_C349

;pointers to platform heights (levels) for each phase
StagePlatformYPositionPointers_C493:
dw Phase25MPlatformYPositions_C0BC
dw DATA_C20C					;no phase 2. this is sadge (not even a valid table)
dw Phase75MPlatformYPositions_C24C
dw Phase100MPlatformYPositions_C300

;skipped over 25M
UNUSED_C49B:
dw DATA_C20C					;if you didn't know, there's no 50M level. I'm sure this info will come in handy

DATA_C49D:
dw DATA_C2D2
dw DATA_C374

UNUSED_C4A1:
dw DATA_C20C					;50M level doesn't exist and it can't hurt you

DATA_C4A3:
dw DATA_C2D8					;
dw DATA_C37A					;

;level and not-so-level layouts
ScreenLayoutData_C4A7:
dw Layout_Phase25M_F55B				;phase 1
dw Layout_TitleScreen_F8D9			;data pointer for cement factory phase. unfortunately, it was cut so no actual stage data left. it's place is occupied by title screen data.
dw Layout_Phase75M_F7CD				;
dw Layout_Phase100M_F71C			;
dw Layout_TitleScreen_F8D9			;title screen (Tilemap_TitleScreen_F8D9)
dw Layout_HUD_FA1B				;hud

;this data is used to initialize various entities, storing directly to their OAM slots
;Format: XYTRcOD
;X - initial X-position
;Y - initial Y-position
;T - Sprite tile (the first one to draw, after each +1 is addded for other tiles)
;Rc - Rows and columns - how many rows and columns to draw, with rows taking high nibble and columns low nibble (e.g. $12 is 1 row and 2 columns)
;O - OAM slot
;D - Drawing mode, see SpriteDrawingEngine_F096 for more (input A)
;for example, let's take a 6 byte row below:
;remove 6 sprite tiles starting from OAM offset E8, which is, by default, Pauline's head (so that means remove pauline, then reinitialize), X and Y-positions don't matter
;$FE acts as a terminator for the initializer

Phase25M_EntityInitData_C4B3:
db $00,$00,$01,$06,PaulineHead_OAM_Slot*4,$04

;draw Pauline's head tiles
db $50,$18,PaulineHead_Tile,$12,PaulineHead_OAM_Slot*4,$00

;then some BODY of Pauline's
db $50,$20,PaulineBody_GFXFrame_Frame2,$22,PaulineBody_OAM_Slot*4,$00

;remove barrels
db $00,$00,$03,$2C,Barrel_OAM_Slot*4,$04

;hammer 1
db $20,$7F,Hammer_GFXFrame_HammerUp,$21,Hammer_OAM_Slot*4,$00

;hammer 2
db $20,$46,Hammer_GFXFrame_HammerUp,$21,Hammer_OAM_Slot*4+8,$00

;remove score
db $00,$00,$01,$04,Score_OAM_Slot*4,$04

;remove jumpman
db $00,$00,$00,$04,Jumpman_OAM_Slot*4,$04

;init jumpman's position
db $30,$C7,$04,$22,Jumpman_OAM_Slot*4,$00

;remove flame enemies
db $00,$00,$02,$08,FlameEnemy_OAM_Slot*4,$04

;remove oil barrel flame
db $00,$00,$02,$02,Flame_OAM_Slot*4,$04

db $FE						;no more init

Phase75M_EntityInitData_C4F6:
;remove pauline
db $00,$00,$01,$06,PaulineHead_OAM_Slot*4,$04

;place pauline
db $50,$18,PaulineHead_Tile,$12,PaulineHead_OAM_Slot*4,$00
db $50,$20,PaulineBody_GFXFrame_Frame2,$22,PaulineBody_OAM_Slot*4,$00

;remove platforms
db $00,$00,$03,$0C,PlatformSprite_OAM_Slot*4,$04

;then place in some
db $30,$78,PlatformSprite_Tile,$12,PlatformSprite_OAM_Slot*4,$00	;each platform uses 2 OAM tiles btw
db $30,$A8,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+2)*4,$00
db $30,$49,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+4)*4,$00
db $70,$70,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+6)*4,$00
db $70,$A0,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+8)*4,$00
db $70,$D7,PlatformSprite_Tile,$12,(PlatformSprite_OAM_Slot+10)*4,$00

;remove something... (springboards?)
db $00,$00,$23,$02,$40,$04			;it skips 48???
db $00,$00,$23,$02,$58,$04

;init jumpman
db $00,$00,$00,$04,Jumpman_OAM_Slot*4,$04
db $10,$B7,Jumpman_GFXFrame_Stand,$22,Jumpman_OAM_Slot*4,$00

;init flame enemies
db $00,$00,$02,$08,FlameEnemy_OAM_Slot*4,$04
db $4C,$9F,FlameEnemy_GFXFrame_Frame1,$22,FlameEnemy_OAM_Slot*4,$00
db $CC,$67,FlameEnemy_GFXFrame_Frame1,$22,(FlameEnemy_OAM_Slot+4)*4,$00

;remove something else...
db $00,$00,$03,$0C,$60,$04
db $00,$00,$01,$16,$90,$04

db $FE

Phase100M_EntityInitData_C569:

;pauline as usual
db $00,$00,$01,$06,PaulineHead_OAM_Slot*4,$04
db $50,$18,PaulineHead_Tile,$12,PaulineHead_OAM_Slot*4,$00
db $50,$20,PaulineBody_GFXFrame_Frame2,$22,PaulineBody_OAM_Slot*4,$00

db $00,$00,$03,$04,Hammer_OAM_Slot*4,$04
db $14,$6E,Hammer_GFXFrame_HammerUp,$21,Hammer_OAM_Slot*4,$00
db $7C,$46,Hammer_GFXFrame_HammerUp,$21,(Hammer_OAM_Slot+2)*4,$00

db $00,$00,$01,$20,$50,$04

db $00,$00,$00,$04,Jumpman_OAM_Slot*4,$04
db $38,$C7,Jumpman_GFXFrame_Stand,$22,Jumpman_OAM_Slot*4,$00

db $00,$00,$02,$10,$10,$04

db $FE

;pointer for various entity initializations (tables above) for each phase
PhaseEntityInitPointers_C5A6:
dw Phase25M_EntityInitData_C4B3
dw Phase75M_EntityInitData_C4F6			;y'know the drill by now.
dw Phase75M_EntityInitData_C4F6
dw Phase100M_EntityInitData_C569

;unknown, maybe related with the table below?
UNUSED_C5AE:
db $7F,$7F,$7F,$00

DATA_C5B2:
db $5F,$3F,$00,$2F,$7F,$7F

UNUSED_C5B8:
db $00

;Y-positions for every bolt in 100M
DATA_C5B9:
db $A9,$A9,$81,$81,$59,$59,$31,$31

UNUSED_C5C1:
db $00,$30,$4C,$D5,$00

DATA_C5C6:
db $10,$E0,$00,$24,$50,$C0

UNUSED_C5CC:
db $00

;X-positions of every bolt in 100M level
DATA_C5CD:
db $3B,$B3,$3B,$B3,$3B,$B3,$38,$B3

UNUSED_C5D5:
db $00

DATA_C5D6:
db $22,$22,$22,$00

DATA_C5DA:
db $21,$21

UNUSED_C5DC:
db $00

DATA_C5DD:
db $20,$22,$22

UNUSED_C5E0:
db $00

DATA_C5E1:
db $22,$22,$22,$22,$21,$21,$21,$21

UNUSED_C5E9:
db $06,$0A,$1B,$00

DATA_C5ED:
db $82,$1C              

UNUSED_C5EF:
db $00

DATA_C5F0:
db $C5,$0A,$18

UNUSED_C5F3:
db $00

DATA_C5F4:
db $E8,$F7,$48,$57,$A8,$B7

DATA_C5FA:
db $08						;0 counts for something (idk yet)
db $17						;25M

UNUSED_C5FC:
db $00						;no 50M!!!!!!!!!!!!!

DATA_C5FD:
db $04
db $07

;another table with the sole purpose of being used in quality programming(TM)
DATA_C5FF:
db $0B

;------------------------------------------

;score sprite data
;there's data for completely unused 300 score bonus.

;Score values added to score counter (hundreds)
ScorePointAwards_C600:
db $01						;100
db $03						;300 (unused)
db $05						;500
db $08						;800

;score sprite tile
ScoreSpriteTiles_C604:
db Score_OneTile				;1 for 100
db Score_ThreeTile				;3 for 300 (unused)
db Score_FiveTile				;5 for 500
db Score_EightTile				;8 for 800

;------------------------------------------

;VRAM position for Donkey Kong's image (the top-leftmost tile), low byte (high byte is always the same)
DATA_C608:
db $84
db $8D						;HOW MANY TIMES DO WE HAVE TO TEACH YOU A LESSON OLD MAN (no phase 2 = unused)
db $84
db $8D

;picking up a barrel from the stack frame
Tilemap_DonkeyKong_PickupBarrel_C60C:
db $46						;6 columns, 4 tiles each
db $76,$77,$78,$79
db $7A,$7B,$7C,$7D
db $7E,$7F,$80,$81
db $82,$83,$84,$85
db $24,$24,$86,$87
db $24,$24,$24,$88

Tilemap_DonkeyKong_HoldingBarrel_C625:
db $46
db $24,$9C,$9D,$9E
db $9F,$A0,$A1,$A2
db $A3,$A4,$A5,$A6
db $A7,$A8,$A9,$AA
db $AB,$AC,$AD,$AE
db $24,$AF,$B0,$B1

;donkey kong frame - throwing barrel to the side (phase 1)
Tilemap_DonkeyKong_SideToss_C63E:
db $46
db $24,$24,$24,$89
db $24,$24,$8A,$8B
db $8C,$8D,$8E,$8F
db $90,$91,$92,$93
db $94,$95,$96,$97
db $98,$99,$9A,$9B

;donkey kong frame - standing still
Tilemap_DonkeyKong_Stationary_C657:
db $46
db $24,$B2,$68,$9E
db $B5,$B6,$6C,$C7
db $A3,$A4,$69,$A6
db $A7,$A8,$6B,$AA
db $C9,$CA,$6D,$BF
db $24,$CD,$6A,$B1

;Chest hit, left hand (from his perspective ofc)
Tilemap_DonkeyKong_HitChestLeftHand_C670:
db $46
db $C2,$C3,$24,$9E
db $C4,$C5,$C6,$C7
db $A3,$B9,$A5,$A6
db $A7,$BB,$6B,$C8
db $C9,$CA,$CB,$CC
db $24,$CD,$CE,$CF

;Chest hit, right hand
Tilemap_DonkeyKong_HitChestRightHand_C689:
db $46
db $24,$B2,$B3,$B4
db $B5,$B6,$B7,$B8
db $A3,$B9,$69,$BA
db $A7,$BB,$A9,$AA
db $BC,$BD,$BE,$BF
db $C0,$C1,$24,$B1

;palette for fireballs when in "panic mode" (100M exclusive)
;affects sprite palette 2
Palette_FlameEnemy_Threatened_C6A2:
db $13
db $2C,$16,$13

;sprite color palette 2 for flames.
;1 row with 3 "tiles" to upload (which is, 3 colors). 
Palette_FlameEnemy_C6A6:
db $13
db $16,$30,$37

;data for "Player X" screen.
Tilemap_PlayerScreen_C6AA:
db $23,$DB					;set up attributes
db $02|VRAMWriteCommand_Repeat
db $A0

db $21,$CA
db $0C|VRAMWriteCommand_Repeat
db $24

;"  PLAYER I  " (I is replaced with II (tile 67) if second player, obviously
db $21,$EA
db $0C
db $24,$24,$19,$15,$0A,$22,$0E,$1B,$24,Tile_Roman_I,$24,$24

db VRAMWriteCommand_Stop

;data for "GAME OVER" message
;Attributes first
Tilemap_GameOver_C6C2:
db $23,$E2
db $04
db $08,$0A,$0A,$02

db $22,$0A
db $0C|VRAMWriteCommand_Repeat			;lay some empty tile strips (so it looks like a proper message box, instead of simply injecting the message and creating cutoff)
db $24

;" GAME  OVER "
db $22,$2A
db $0C
db $24,$10,$0A,$16,$0E,$24,$24,$18,$1F,$0E,$1B,$24

db $22,$4A
db $0C|VRAMWriteCommand_Repeat
db $24						;one more strip

db VRAMWriteCommand_Stop

Tilemap_RemoveII_C6E1:
db $12						;1 row with 2 tiles
db $24,$24					;two empty tiles to remove II

;Erase score tiles for the ending
DATA_C6E4:
db $20,$63
db $1B|VRAMWriteCommand_Repeat			;all score, player 1, 2 and TOP
db $24

db $20,$94					;erase other stats (Lives, Bonus, Loop counter)
db $0A|VRAMWriteCommand_Repeat
db $24

db $20,$B4					;stats, bottom row
db $0A|VRAMWriteCommand_Repeat
db $24

db VRAMWriteCommand_Stop

;erase platforms for ending
DATA_C6F1:
db $21,$09
db $0E|VRAMWriteCommand_Repeat
db $24

db $21,$A9
db $0E|VRAMWriteCommand_Repeat
db $24

db $22,$49
db $0E|VRAMWriteCommand_Repeat
db $24

db $22,$E9
db $0E|VRAMWriteCommand_Repeat
db $24

db $3F,$1D
db $03
db $30,$36,$06					;sprite palette for kong

db VRAMWriteCommand_Stop

;erase kong (ending)
DATA_C708:
db $20,$8D
db $06|VRAMWriteCommand_Repeat
db $24

db $20,$AD
db $06|VRAMWriteCommand_Repeat
db $24

db $20,$CD
db $06|VRAMWriteCommand_Repeat
db $24

db $20,$ED
db $06|VRAMWriteCommand_Repeat
db $24

db VRAMWriteCommand_Stop

;Draw defeated kong (ending)
;Attributes
DATA_C719:
db $12						;two vertical lines with 1 byte each
db $AA,$AA

;first frame
Tilemap_DonkeyKong_Defeated1_C71C:
db $46						;defeated frame (6 columns, 4 tiles each)
db $24,$24,$DC,$DD
db $D4,$D5,$DE,$DF
db $D6,$D7,$E0,$E1
db $D8,$D9,$E2,$E3
db $DA,$DB,$E4,$E5
db $24,$24,$E6,$E7

;second frame
Tilemap_DonkeyKong_Defeated2_C735:
db $46
db $E8,$E9,$EA,$EB
db $EC,$ED,$EE,$EF
db $24,$F0,$F1,$F2
db $24,$F3,$F4,$F5
db $F6,$F7,$F8,$F9
db $FA,$FB,$FC,$FD

;Platform where Jumpman and Pauline are standing (ending)
DATA_C74E:
db $21,$08
db $10|VRAMWriteCommand_Repeat
db $62

db VRAMWriteCommand_Stop

;Platforms at the bottom (ending)
DATA_C753:
db $23,$09
db $0E|VRAMWriteCommand_Repeat
db $62

db $23,$29
db $0E|VRAMWriteCommand_Repeat
db $62

db $23,$49
db $0E|VRAMWriteCommand_Repeat
db $62

db VRAMWriteCommand_Stop

;used for DK Defeat cutscene (erase some tiles)
DATA_C760:
db $20,$C5					;erase umbrella
db $02|VRAMWriteCommand_Repeat			;
db $24

db $20,$CA					;erase platform with Pauline
db $02|VRAMWriteCommand_Repeat
db $24

db $20,$EA					;erase tiles below platform (there's none?)
db $02|VRAMWriteCommand_Repeat
db $24

db $20,$E5					;erase bottom tiles of umbrella
db $02|VRAMWriteCommand_Repeat			;
db $24						;

db $22,$0A					;erase handbag, top
db $02|VRAMWriteCommand_Repeat
db $24

db $22,$2A					;handbag, bottom
db $02|VRAMWriteCommand_Repeat			;
db $24						;

db $22,$18					;Umbrella 2 top
db $02|VRAMWriteCommand_Repeat			;
db $24						;

db VRAMWriteCommand_Stop

;Ending cutscene tile removal data part 2
DATA_C77D:
db $22,$38					;Umbrella 2 bottom
db $02|VRAMWriteCommand_Repeat
db $24

db $21,$29					;erasing ladders
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $21,$36
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $21,$D0
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $22,$6C
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $22,$73
db $04|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db $23,$0F
db $03|VRAMWriteCommand_Repeat|VRAMWriteCommand_DrawVert
db $24

db VRAMWriteCommand_Stop

;pretty sure those are common speed tables (NOT!!!!!!!!!)
DATA_C79A:
db $FF,$01

DATA_C79C:
db $01,$FF      
