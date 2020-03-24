*=* "Memory Routines"

//
// These are generic memory copy and fill routines.
//

//
// Fill a chunk of memory with a byte value.
//
// r0L value to store
// r1 target memory
// r2 number of bytes to store
//
FillMemory:
  ldy #$00
!l1:
  lda r0L
  sta (r1), y
  Dec16(r2)
  CmpWI(r2, $0000)
  beq !end+
  iny
  bne !l1-
  inc r1H
  jmp !l1-

!end:
  rts

//
// Copy a chunk of memory
//
// r0 source memory
// r1 target memory
// r2 number of bytes to transfer
//
// Borrowed from https://github.com/mist64/geos/blob/2090bca64fc2627beef5c8232aafaec61f1f5a53/kernal/memory/memory2.s#L123
//
CopyMemory:
  lda r2L
  ora r2H
  beq !l7+
  PushW(r0)
  PushB(r1H)
  PushB(r2H)
  PushB(r3L)
!l1:
  CmpW(r0, r1)
!l2:
  bcs !l3+
  bcc !l8+
!l3:
  ldy #0
  lda r2H
  beq !l5+
!l4:
  lda (r0), y
  sta (r1), y
  iny
  bne !l4-
  inc r0H
  inc r1H
  dec r2H
  bne !l4-
!l5:
  cpy r2L
  beq !l6+
  lda (r0), y
  sta (r1), y
  iny
  bra !l5-
!l6:
  PopB(r3L)
  PopB(r2H)
  PopB(r1H)
  PopW(r0)
!l7:
  rts

!l8:
  clc
  lda r2H
  adc r0H
  sta r0H
  clc
  lda r2H
  adc r1H
  sta r1H
  ldy r2L
  beq !lA+
!l9:
  dey
  lda (r0), y
  sta (r1), y
  tya
  bne !l9-
!lA:
  dec r0H
  dec r1H
  lda r2H
  beq !l6-
!lB:
  dey
  lda (r0), y
  sta (r1), y
  tya
  bne !lB-
  dec r2H
  bra !lA-
