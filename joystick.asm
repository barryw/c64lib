*=* "Joystick Routine"

//
// Read both joysticks and store the results
//
ReadJoysticks:
  ldx #$00
  jsr ReadJoystick
  inx
  jsr ReadJoystick
  rts

//
// Read the joystick position and button status and store the state
//
ReadJoystick:
  lda #DISABLE
  sta c64lib_joy_btn, x
  sta c64lib_joy_left, x
  sta c64lib_joy_right, x
  sta c64lib_joy_up, x
  sta c64lib_joy_down, x

  lda cia.CIAPRA, x
  and #JOY_BUTTON
  beq !set_button+
  and #JOY_LEFT
  beq !set_left+
  and #JOY_RIGHT
  beq !set_right+
  and #JOY_UP
  beq !set_up+
  and #JOY_DOWN
  beq !set_down+

  jmp !return+

!set_button:
  stb #ENABLE:c64lib_joy_btn, x
  jmp !return+

!set_left:
  stb #ENABLE:c64lib_joy_left, x
  jmp !return+

!set_right:
  stb #ENABLE:c64lib_joy_right, x
  jmp !return+

!set_up:
  stb #ENABLE:c64lib_joy_up, x
  jmp !return+

!set_down:
  stb #ENABLE:c64lib_joy_down, x

!return:
  rts
