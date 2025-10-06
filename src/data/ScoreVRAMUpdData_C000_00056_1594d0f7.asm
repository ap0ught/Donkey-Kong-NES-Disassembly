db $20,$70,$06,$00				;TOP
db $20,$64,$06,$00				;Player 1
db $20,$78,$06,$00				;Player 2
db $20,$B7,$04,$00				;Bonus

;----------------------------------------------
;!UNUSED
;Loop counter uses a single byte write, so this is unecessary and unused
UNUSED_C010:
db $20,$BC,$01,$00
;----------------------------------------------

;Input data for demo
DemoInputData_C014:
;probably doesn't look good. shrugio
db Input_Right
db Input_Up
db Input_Left
db Input_Up

db Input_Left
db Demo_NoInput
db Demo_JumpCommand
db Input_Right

db Demo_NoInput
db Input_Left
db Input_Right
db Input_Right

db Input_Right
db Demo_JumpCommand
db Input_Right
db Demo_JumpCommand

db Input_Right
db Input_Left
db Input_Right
db Input_Left

;Timings for each input (^^^) for demo
DemoTimingData_C028:
db $DB,$60,$E2,$55
db $14,$20,$01,$F9
db $A0,$E0,$30,$10
db $10,$01,$50,$01
db $30,$D0,$FF,$FF				;after this it'll start taking garbage values, which should be impossible, unless you disable barrels

DATA_C03C:
dw Tilemap_DonkeyKong_SideToss_C63E		;\pointers to Kong's frames. this one is "toss to the side"
dw Tilemap_DonkeyKong_Stationary_C657		;/this one is simply stationary Donkey (default pose)
dw Tilemap_RemoveII_C6E1			;erase II if not in two player mode
dw DATA_C760					;erase various tiles for ending (part 1)

;various table pointers for the ending (erase tiles, draw some), combined with a table from above
DATA_C044:
dw DATA_C77D
dw DATA_C6E4
dw DATA_C6F1
dw DATA_C753
dw DATA_C708
dw DATA_C719					;init Donkey Kong's defeated frame (attributes & first frame)
dw Tilemap_DonkeyKong_Defeated1_C71C		;Defeated Kong frame 1
dw Tilemap_DonkeyKong_Defeated2_C735		;Defeated Kong frame 2
dw DATA_C74E

;other tables for 25M
dw DATA_C08C					;elevated platform data (25M)
dw DATA_C0CF					;platform ends for jumpman to fall off (25M)
dw DATA_C161					;broken ladder positions (25M)

;dynamic table that would be set in a routine that's not called anywhere (see UNUSED_D650)
UNUSED_C05C:
dw UnusedCollisionTable_0460

DATA_C05E:
dw Phase25MPlatforms_Hitboxes_C0C3		;25M platform collision dimensions
dw Phase25MGaps_Hitbox_C0DF			;25M fall area collision dimensions
dw BrokenLadder_Hitbox_C16E			;25M broken ladders' collision dimensions

;collision dimensions related to the dynamic table from above (also happens to be unused)
UNUSED_C064:
dw UNUSED_C2C4

DATA_C066:
dw MovingPlatform_Hitbox_C2C8			;moving platforms' hitbox (75M)
dw DATA_C186
dw HammerPickup_Hitbox_C1B0
dw DATA_C192
dw DATA_C1CF					;y-positions for barrel drop areas (onto lower platform)

dw DATA_C1D5					;tossed barrel platform y-positions to make it bounce off (pattern = Barrel_VertTossPattern_StraightDown)
dw UNUSED_C1DB					;tossed barrel platform y-positions to make it bounce off (pattern = Barrel_VertTossPattern_DiagonalRight)
dw DATA_C1E1					;tossed barrel platform y-positions to make it bounce off (pattern = Barrel_VertTossPattern_LeftAndRight)

dw DATA_C19E					;
dw DATA_C1E7					;

;MORE Background Donkey Kong Tilemaps
dw Tilemap_DonkeyKong_PickupBarrel_C60C		;
dw Tilemap_DonkeyKong_HitChestLeftHand_C670	;\chest hitting frames
dw Tilemap_DonkeyKong_HitChestRightHand_C689	;/
dw Tilemap_DonkeyKong_HoldingBarrel_C625
;-----------------------------------------------------

dw Palette_FlameEnemy_Threatened_C6A2		;Pointer to Sprite Palette 2 (100M flame enemies when Jumpman is equipped with the hammer. turn blue by default)
dw EraseBuffer					;use RAM (buffer for misc tile erasing (bolts and pauline's items))
dw DATA_C18E
dw DATA_C196
dw Palette_FlameEnemy_C6A6			;Pointer to Sprite Palette 2 (flame enemies)

;data related with checking sloped (or elevated or whatever I'll call them the next day) surfaces (25M only)
;byte 1 - base x-pos for the lowest elevation
;byte 2 - base y-pos for the lowest elevation
;byte 3 - offset for the collision table for the entire platform, for small bits it's always 4
;byte 4 - x-offset between each elevation (-$18 is for platforms where elevation goes from right to left)
;byte 5 - number of bits to go through (if not counting 0)
;byte 6 - terminator if $FE, if not can be used to have different platform collisions on the same platform (which is the case with the lowest platform)
DATA_C08C:
db $00,$D8,$00,$00,$01,$00			;first platform has two types of hitboxes, a long one that extend from the very left of the screen, and then elevated bits
db $80,$D7,$04,$18,$06,$FE			;by the way, 6? there are clearly 5 elevated platforms...

db $C8,$BC,$04,-$18,$09,$FE			;from here on elevated only
db $20,$9E,$04,$18,$09,$FE
db $C8,$80,$04,-$18,$09,$FE
db $20,$62,$04,$18,$09,$FE
db $C8,$44,$04,-$18,$06,$FE
db $80,$28,$04,$00,$01,$FE			;the very last platform that marks the end of the level, which is a single platform with no elevations

;y-position of each platform (from highest point + 16 pixels), used to calculate platform index
;FF sets index to 7 (which is the lowest platform)
;Phase 1
Phase25MPlatformYPositions_C0BC:
db $BC,$9E,$80,$62,$44,$28,$FF
