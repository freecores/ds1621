// Timing with undefined `DS1621_STANDARD ( more than 100kHz)

// for Opencores users:
// Delays are system bus specific. Adapt them to your system bus timing.
// Tasks are acceptable by both 24LC16B and DS1621S devices.
// "bus.write/read" are the tasks from the bus interface
// (create your own interface or change the write read just to be the tasks).
// "bus.data" is the value returned by the interface task.
// Format: Bit  7,      6,      5,      4,      3,      2,      1,      0
//             SDA                                      WP     SCL     SDA
//            readback                              if EEPROM
//                                                  is present
//

task  iic__stop();
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b000} );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b010} );
 #500 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
endtask

task  iic_ctlop( bit [3:0] EE_or_DS, bit [2:0] blk_adr, bit op, output bit ACK );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b010} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b000} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, EE_or_DS[3]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, EE_or_DS[3]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, EE_or_DS[3]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, EE_or_DS[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, EE_or_DS[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, EE_or_DS[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, EE_or_DS[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, EE_or_DS[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, EE_or_DS[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, EE_or_DS[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, EE_or_DS[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, EE_or_DS[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, blk_adr[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, blk_adr[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, blk_adr[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, blk_adr[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, blk_adr[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, blk_adr[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, blk_adr[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, blk_adr[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, blk_adr[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, op} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, op} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b001} );  // ACK check
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );  //
 #100 bus.read( `SYS_REG_01 );
      ACK = bus.data[7];
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b000} );  // ACK end with SCL=0 & SDA=0 (hold time is 0 for both devices on IIC)
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
endtask

task  iic_write( bit stop, bit [7:0] data, output bit ACK );
 #200 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[7]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, data[7]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[7]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[6]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, data[6]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[6]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[5]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, data[5]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[5]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[4]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, data[4]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[4]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[3]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, data[3]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[3]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, data[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[2]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, data[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[1]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b01, data[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 2'b00, data[0]} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b001} );  // ACK check
 #500 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );  //
 #100 bus.read( `SYS_REG_01 );
      ACK = bus.data[7];
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b000} );  // ACK end with SCL=0 & SDA=0 (hold time is 0 for both devices on IIC)
    if ( stop )  iic__stop;
    else
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
endtask

task  iic__read( bit stop, output bit [7:0] data );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      bus.read( `SYS_REG_01 );  data = {data[6:0], bus.data[7]};
      bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      bus.read( `SYS_REG_01 );  data = {data[6:0], bus.data[7]};
      bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      bus.read( `SYS_REG_01 );  data = {data[6:0], bus.data[7]};
      bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      bus.read( `SYS_REG_01 );  data = {data[6:0], bus.data[7]};
      bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      bus.read( `SYS_REG_01 );  data = {data[6:0], bus.data[7]};
      bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      bus.read( `SYS_REG_01 );  data = {data[6:0], bus.data[7]};
      bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      bus.read( `SYS_REG_01 );  data = {data[6:0], bus.data[7]};
      bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      bus.read( `SYS_REG_01 );  data = {data[6:0], bus.data[7]};
    if ( stop ) begin
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b001} ); // NO ACK
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b011} );
      iic__stop;
    end
    else begin
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b000} ); // ACK
 #700 bus.write( `SYS_REG_01, {13'h0000, 3'b010} );
 #500 bus.write( `SYS_REG_01, {13'h0000, 3'b000} );
 #100 bus.write( `SYS_REG_01, {13'h0000, 3'b001} );
    end
endtask
