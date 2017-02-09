///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//               mux4
//   Filename : al_map_mux4.v
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

module AL_MAP_MUX4 (o, i, s);
output o;
input [3:0] i;
input [1:0] s;

lut_mux4 (o, i[3], i[2], i[1], i[0], s[1], s[0]);

endmodule


primitive lut_mux4 (o, i3, i2, i1, i0, s1, s0);

output o;
input i3, i2, i1, i0;
input s1, s0;



table

//   i3  i2  i1  i0  s1  s0 : o;

     ?   ?   ?   1   0   0  : 1;
     ?   ?   ?   0   0   0  : 0;
     ?   ?   1   ?   0   1  : 1;
     ?   ?   0   ?   0   1  : 0;
     ?   1   ?   ?   1   0  : 1;
     ?   0   ?   ?   1   0  : 0;
     1   ?   ?   ?   1   1  : 1;
     0   ?   ?   ?   1   1  : 0;

     ?   ?   0   0   0   x  : 0;
     ?   ?   1   1   0   x  : 1;
     0   0   ?   ?   1   x  : 0;
     1   1   ?   ?   1   x  : 1;

     ?   0   ?   0   x   0  : 0;
     ?   1   ?   1   x   0  : 1;
     0   ?   0   ?   x   1  : 0;
     1   ?   1   ?   x   1  : 1;

     0   0   0   0   x   x  : 0;
     1   1   1   1   x   x  : 1;

endtable

endprimitive

