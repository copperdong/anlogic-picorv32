///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//               map_adder
//   Filename : al_map_adder.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////

`resetall
`timescale 1 ns / 1 ps

module AL_MAP_ADDER
  (
  a,
  b,
  c,
  o
  );

  input a;
  input b;
  input c;
  output [1:0] o;

    tri0 a,b,c;
    initial begin
      o = 2'b00;
    end
    parameter ALUTYPE = "ADD";
    reg [1:0] o;
    always @(*) begin
      case(ALUTYPE)
        "ADD"            :  begin o[1] = (a==b)?a:c; o[0] = a^b^c; end
        "ADD_CARRY"      :  begin o[1] = a; end
        "SUB"            :  begin o[1] = (a!=b)?a:c; o[0] = ~(a^b^c); end
        "SUB_CARRY"      :  begin o[1] = ~a; end
        "A_LE_B"         :  begin o[1] = (a!=b)?b:c; o[0] = ~(a^b^c); end
        "A_LE_B_CARRY"   :  begin o[1] = a; end
      endcase
    end

endmodule

