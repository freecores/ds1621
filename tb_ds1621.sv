// regs: DS1621 Temperature Sensor

`define DS1621_CODE  4'h9
`define DS1621_ADDR  3'b001

`define DS1621_WROP  1'b0
`define DS1621_RDOP  1'b1

// Defined in the model
`ifndef DS1621_STOP
  `define DS1621_STOP  8'h22
  `define DS1621_TH    8'hA1
  `define DS1621_TL    8'hA2
  `define DS1621_CNT   8'hA8
  `define DS1621_SLP   8'hA9
  `define DS1621_TMP   8'hAA
  `define DS1621_CFG   8'hAC
  `define DS1621_STRT  8'hEE
`endif

    $display("--DS1621 test 01 begin-->");
    
    board_temp = 20.0;  // set board temperature

    $display("----DS1621 sending CFG=03, TH=16'h2800, TL=16'h0A00");
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_CFG, bit_status );                            if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_write( 0, 8'h63, bit_status );                                  if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_TH, bit_status );                             if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_write( 0, 8'h28, bit_status );                                  if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_write( 0, 8'h00, bit_status );                                  if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_TL, bit_status );                             if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_write( 0, 8'h0A, bit_status );                                  if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_write( 1, 8'h00, bit_status );                                  if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    $display("----DS1621 sending done");

    $display("----DS1621 reading TH");
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_TH, bit_status );                             if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_RDOP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic__read( 0, g_logic_8 );   g_logic_16[15:8]=g_logic_8;
    iic__read( 1, g_logic_8 );   g_logic_16[7:0] =g_logic_8;
    $display("----DS1621 TH = %0h", g_logic_16);

    board_temp = 25.5;  // set board temperature

    $display("----DS1621 start TMP conversion");
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 1, `DS1621_STRT, bit_status );                           if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
   #2_000_000  // conversion time is truncated on the board
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_CFG, bit_status );                            if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_RDOP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic__read( 1, g_logic_8 );                                          if ( g_logic_8[7] == 0 )  $display("--DS1621: iic__read, TCNV IS IN PROGRESS = %h", g_logic_8[7] );
    // 
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_TMP, bit_status );                            if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_RDOP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic__read( 0, g_logic_8 );   g_logic_16[15:8]=g_logic_8;
    iic__read( 1, g_logic_8 );   g_logic_16[7:0] =g_logic_8;
    $display("----DS1621 T=25.5*C, expecting 1980, TMP = %0h", g_logic_16);

    board_temp = -13.0;  // set board temperature

    $display("----DS1621 start TMP conversion");
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 1, `DS1621_STRT, bit_status );                           if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
   #2_000_000  // conversion time is truncated on the board
    // 
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_TMP, bit_status );                            if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_RDOP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic__read( 0, g_logic_8 );   g_logic_16[15:8]=g_logic_8;
    iic__read( 1, g_logic_8 );   g_logic_16[7:0] =g_logic_8;
    $display("----DS1621 T=-13.0*C, expecting F300, TMP = %0h", g_logic_16);

    board_temp = -13.5;  // set board temperature

    $display("----DS1621 start TMP conversion");
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 1, `DS1621_STRT, bit_status );                           if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
   #2_000_000  // conversion time is truncated on the board
    // 
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_TMP, bit_status );                            if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_RDOP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic__read( 0, g_logic_8 );   g_logic_16[15:8]=g_logic_8;
    iic__read( 1, g_logic_8 );   g_logic_16[7:0] =g_logic_8;
    $display("----DS1621 T=-13.5*C, expecting F380, TMP = %0h", g_logic_16);

    board_temp = 130.0;  // set board temperature

    $display("----DS1621 start TMP conversion");
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 1, `DS1621_STRT, bit_status );                           if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
   #2_000_000  // conversion time is truncated on the board
    // 
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_TMP, bit_status );                            if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_RDOP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic__read( 0, g_logic_8 );   g_logic_16[15:8]=g_logic_8;
    iic__read( 1, g_logic_8 );   g_logic_16[7:0] =g_logic_8;
    $display("----DS1621 T=130.0*C, expecting 7D00, TMP = %0h", g_logic_16);

    board_temp = -60.0;  // set board temperature

    $display("----DS1621 start TMP conversion");
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 1, `DS1621_STRT, bit_status );                           if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
   #2_000_000  // conversion time is truncated on the board
    // 
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_TMP, bit_status );                            if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_RDOP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic__read( 0, g_logic_8 );   g_logic_16[15:8]=g_logic_8;
    iic__read( 1, g_logic_8 );   g_logic_16[7:0] =g_logic_8;
    $display("----DS1621 T=-60.0*C, expecting C900, TMP = %0h", g_logic_16);
    // THF, TLF reset
    iic_ctlop( `DS1621_CODE, `DS1621_ADDR, `DS1621_WROP, bit_status );  if ( bit_status != 0 ) $display("--DS1621: iic_ctlop, WRONG ACK = %h", bit_status);
    iic_write( 0, `DS1621_CFG, bit_status );                            if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);
    iic_write( 1, 8'h03, bit_status );                                  if ( bit_status != 0 ) $display("--DS1621: iic_write, WRONG ACK = %h", bit_status);

   $display("--DS1621 test 01 end--<\n");
