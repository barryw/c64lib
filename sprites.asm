*=* "Sprite Routines"

//
// These routines can be used to move and manipulate the sprites on the 64.
//

#if REGISTER_MODE

//
// Position a sprite anywhere on the screen
// This variant uses hardware registers instead of pseudo registers
//
// X sprite number (0-7)
// A,Y  x pos (0-319)
// $02 y pos (0-199)
//
PositionSprite:
  pha
  tya
  pha
  txa
  mult2
  tay
  lda $02
  sta vic.SP0Y, y
  pla
  sta $02
  pla
  sta r6L
  lda $02
  adc #$00
  sta r6H
  stb r6L:vic.SP0X, y
  ldx r3L
  lda BitMaskPow2, x
  eor #$ff
  and vic.MSIGX
  tay
  lda #$01
  and r6H
  beq !no_msb+
  tya
  ora BitMaskPow2, x
  tay

!no_msb:
  sty vic.MSIGX

!return:
  rts

//
// Change one of a sprite's attributes
// This variant uses hardware registers instead of pseudo registers
//
// X sprite number (0-7)
// Y attribute to change (SPR_VISIBLE, SPR_X_EXPAND, SPR_Y_EXPAND, SPR_HMC, SPR_PRIORITY)
// A value for the attribute
// - Sprite visibility (SPR_SHOW, SPR_HIDE)
// - X/Y expansion (SPR_NORMAL, SPR_EXPAND)
// - Priority (SPR_FG, SPR_BG)
// - Hires or Multicolor (SPR_HIRES, SPR_MULTICOLOR)
//
ChangeSpriteAttribute:
  pha
  lda BitMaskPow2, x
  sta $02
  pla
  tax
  lda $02
  cpx #ENABLE
  beq !set_flag+
  eor #$ff
  and vic.SP0X, y
  jmp !clear_flag+
!set_flag:
  ora vic.SP0X, y
!clear_flag:
  sta vic.SP0X, y

  rts

#else

//
// Position a sprite anywhere on the screen
// This variant uses the zeropage pseudo registers, which may not be compatible with BASIC or the Kernal
//
// r3L sprite number (0-7)
// r4  x pos (0-319)
// r5L y pos (0-199)
//
PositionSprite:
  lda r3L
  mult2
  tay
  stb r5L:vic.SP0Y, y
  stb r4L:r6L
  lda r4H
  adc #$00
  sta r6H
  stb r6L:vic.SP0X, y
  ldx r3L
  lda BitMaskPow2, x
  eor #$ff
  and vic.MSIGX
  tay
  lda #$01
  and r6H
  beq !no_msb+
  tya
  ora BitMaskPow2, x
  tay

!no_msb:
  sty vic.MSIGX

!return:
  rts

//
// Change one of a sprite's attributes
// This variant uses the zeropage pseudo registers, which may not be compatible with BASIC or the Kernal
//
// r3L sprite number (0-7)
// r3H attribute to change (SPR_VISIBLE, SPR_X_EXPAND, SPR_Y_EXPAND, SPR_HMC, SPR_PRIORITY)
// r4L value for the attribute
// - Sprite visibility (SPR_SHOW, SPR_HIDE)
// - X/Y expansion (SPR_NORMAL, SPR_EXPAND)
// - Priority (SPR_FG, SPR_BG)
// - Hires or Multicolor (SPR_HIRES, SPR_MULTICOLOR)
//
ChangeSpriteAttribute:
  ldy r3H
  ldx r3L
  lda BitMaskPow2, x
  ldx r4L
  cpx #ENABLE
  beq !set_flag+
  eor #$ff
  and vic.SP0X, y
  jmp !clear_flag+
!set_flag:
  ora vic.SP0X, y
!clear_flag:
  sta vic.SP0X, y

  rts

#endif

//
// This allows us to translate sprite numbers into bit masks
//
BitMaskPow2:
  .byte %00000001
  .byte %00000010
  .byte %00000100
  .byte %00001000
  .byte %00010000
  .byte %00100000
  .byte %01000000
  .byte %10000000
