*=* "VIC Routines"

//
// These routines can be used to manage the current VIC bank as well as character
// memory & screen memory
//

#if REGISTER_MODE

//
// Set the VIC bank, screen memory and character memory
// This is the hadrware register variant
//
// X bank number (0-3) (multiples of 16k)
// A character memory within the bank (0-7) (multiples of 2k)
// Y screen memory within the bank (0-15) (multiples of 1k)
//
SetVICBank:
  mult2
  sta $02
  lda cia.CI2PRA
  and #cia.VIC_BANK_REVERSE_MASK
  ora BankLookup, x
  sta cia.CI2PRA
  lda vic.VMCSB
  and #vic.CHAR_MEM_REV_POINTER_MASK
  ora $02
  sta vic.VMCSB
  tya
  mult4
  mult4
  tay
  sty $02
  lda vic.VMCSB
  and #vic.SCREEN_MEM_REV_POINTER_MASK
  ora $02
  sta vic.VMCSB
  jmp UpdateBaseLocations

#else

//
// Set the VIC bank, screen memory and character memory
// This is the pseudo register variant
//
// r0L bank number (0-3) (multiples of 16k)
// r0H character memory within the bank (0-7) (multiples of 2k)
// r1L screen memory within the bank (0-15) (multiples of 1k)
//
SetVICBank:
  asl r0H
  lda r0L
  tax
  lda cia.CI2PRA
  and #cia.VIC_BANK_REVERSE_MASK
  ora BankLookup, x
  sta cia.CI2PRA
  lda vic.VMCSB
  and #vic.CHAR_MEM_REV_POINTER_MASK
  ora r0H
  sta vic.VMCSB
  asl r1L
  asl r1L
  asl r1L
  asl r1L
  lda vic.VMCSB
  and #vic.SCREEN_MEM_REV_POINTER_MASK
  ora r1L
  sta vic.VMCSB
  jmp UpdateBaseLocations

#endif

//
// Updates the 4 base locations below based on how the VIC bank,
// screen memory and character memory are configured.
//
UpdateBaseLocations:
  lda cia.CI2PRA
  and #cia.VIC_BANK_MASK
  eor #cia.VIC_BANK_MASK
  mult16
  sta vic.BankMemoryBase + $01
  lda vic.VMCSB
  pha
  and #vic.SCREEN_MEM_POINTER_MASK
  div4
  clc
  adc vic.BankMemoryBase + $01
  sta vic.ScreenMemoryBase + $01
  clc
  adc #$03
  sta vic.SpritePointerBase + $01
  pla
  and #vic.CHAR_MEM_POINTER_MASK
  mult4
  clc
  adc vic.BankMemoryBase + $01
  sta vic.CharacterMemoryBase + $01

  rts

BankLookup:
  .byte cia.BANK_0_MASK
  .byte cia.BANK_1_MASK
  .byte cia.BANK_2_MASK
  .byte cia.BANK_3_MASK

/*

Constants for the C64's Video Interface Chip (VIC-II)

*/
.namespace vic {
  //
  // 16-bit pointer to the start of the VIC's memory in the current bank.
  // Since the VIC can only see 16k, there are 4 possible banks in the C64.
  //
  // $0000 = BANK 0
  // $4000 = BANK 1
  // $8000 = BANK 2
  // $C000 = BANK 3
  //
  BankMemoryBase:
    .word DEFAULT_VIC_BANK

  //
  // This location contains a 16-bit pointer to the start of screen memory
  // in the current bank. It defaults to $0400, which is the C64's power
  // on default in bank 0. When you call SetVICBank, it updates this pointer.
  //
  ScreenMemoryBase:
    .word DEFAULT_SCREEN_BASE

  //
  // 16-bit pointer to the start of the sprite pointers. This is always 1016
  // bytes after the start of screen memory.
  //
  SpritePointerBase:
    .word DEFAULT_SPRITE_POINTER_BASE

  //
  // This location contains a 16-bit pointer to the start of character memory
  // in the current bank. It defaults to $1000, which is the C64's power
  // on default in bank 0. When you call SetVICBank, it updates this pointer.
  CharacterMemoryBase:
    .word DEFAULT_CHAR_BASE

  .label SCREEN_MEM_POINTER_MASK     = %11110000
  .label SCREEN_MEM_REV_POINTER_MASK = %00001111
  .label CHAR_MEM_POINTER_MASK       = %00001110
  .label CHAR_MEM_REV_POINTER_MASK   = %11110001

  .label DEFAULT_VIC_BANK            = $0000
  .label DEFAULT_SCREEN_BASE         = $0400
  .label DEFAULT_CHAR_BASE           = $1000
  .label DEFAULT_SPRITE_POINTER_BASE = $07f8

  // The 47 VIC-II registers
  .label SP0X   = $d000
  .label SP0Y   = $d001
  .label SP1X   = $d002
  .label SP1Y   = $d003
  .label SP2X   = $d004
  .label SP2Y   = $d005
  .label SP3X   = $d006
  .label SP3Y   = $d007
  .label SP4X   = $d008
  .label SP4Y   = $d009
  .label SP5X   = $d00a
  .label SP5Y   = $d00b
  .label SP6X   = $d00c
  .label SP6Y   = $d00d
  .label SP7X   = $d00e
  .label SP7Y   = $d00f
  .label MSIGX  = $d010 // MSB of sprite x positions
  .label SCROLY = $d011
  .label RASTER = $d012
  .label LPENX  = $d013
  .label LPENY  = $d014
  .label SPENA  = $d015 // Sprite enable
  .label SCROLX = $d016
  .label YXPAND = $d017
  .label VMCSB  = $d018
  .label VICIRQ = $d019
  .label IRQMSK = $d01a
  .label SPBGPR = $d01b
  .label SPMC   = $d01c
  .label XXPAND = $d01d
  .label SPSPCL = $d01e
  .label SPBGCL = $d01f
  .label EXTCOL = $d020
  .label BGCOL0 = $d021
  .label BGCOL1 = $d022
  .label BGCOL2 = $d023
  .label BGCOL3 = $d024
  .label SPMC0  = $d025
  .label SPMC1  = $d026
  .label SP0COL = $d027
  .label SP1COL = $d028
  .label SP2COL = $d029
  .label SP3COL = $d02a
  .label SP4COL = $d02b
  .label SP5COL = $d02c
  .label SP6COL = $d02d
  .label SP7COL = $d02e

  .label COLCLK = $d81a
}
