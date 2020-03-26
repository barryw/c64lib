/*

Constants for the C64's 2 Complex Interface Adapters (CIA)

*/
.namespace cia {
  .label VIC_BANK_MASK         = %00000011
  .label VIC_BANK_REVERSE_MASK = %11111100

  .label BANK_0_MASK = %11
  .label BANK_1_MASK = %10
  .label BANK_2_MASK = %01
  .label BANK_3_MASK = %00

  .label CIAPRA = $dc00
  .label CIAPRB = $dc01
  .label CIDDRA = $dc02
  .label CIDDRB = $dc03
  .label TIMALO = $dc04
  .label TIMAHI = $dc05
  .label TIMBLO = $dc06
  .label TIMBHI = $dc07
  .label TODTEN = $dc08
  .label TODSEC = $dc09
  .label TODMIN = $dc0a
  .label TODHRS = $dc0b
  .label CIASDR = $dc0c
  .label CIAICR = $dc0d
  .label CIACRA = $dc0e
  .label CIACRB = $dc0f

  .label CI2PRA = $dd00
  .label CI2PRB = $dd01
  .label C2DDRA = $dd02
  .label C2DDRB = $dd03
  .label TI2ALO = $dd04
  .label TI2AHI = $dd05
  .label TI2BLO = $dd06
  .label TI2BHI = $dd07
  .label TO2TEN = $dd08
  .label TO2SEC = $dd09
  .label TO2MIN = $dd0a
  .label TO2HRS = $dd0b
  .label CI2SDR = $dd0c
  .label CI2ICR = $dd0d
  .label CI2CRA = $dd0e
  .label CI2CRB = $dd0f
}
