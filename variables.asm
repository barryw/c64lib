// 8 timers of 8 bytes each
// struct is as follows:
// 0   - enabled/disabled
// 1   - type: oneshot or continuous
// 2,3 - current value
// 4,5 - frequency
// 6,7 - call location on fire
.label c64lib_timers = kernal.TBUFFER

// Joystick storage
.label c64lib_joy_btn   = $6d
.label c64lib_joy_up    = $6f
.label c64lib_joy_down  = $71
.label c64lib_joy_left  = $73
.label c64lib_joy_right = $75
