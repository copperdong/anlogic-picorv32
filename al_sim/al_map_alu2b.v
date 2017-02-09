///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//              alu2b
//   Filename : al_map_alu2b.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
module AL_MAP_ALU2B (
   cin,
   a0, b0, c0, d0,
   a1, b1, c1, d1,
   s0, s1, cout
);

input cin;
input a0, b0, c0, d0;
input a1, b1, c1, d1;

tri0 cina0,b0,c0,d0,a1,b1,c1,d1;

output s0, s1, cout;

parameter [15:0] INIT0 = 16'h0000;
parameter [15:0] INIT1 = 16'h0000;
parameter FUNC0 = "NO";
parameter FUNC1 = "NO";

wire y3_0, y2_0, y1_0, y0_0; 
wire y3_1, y2_1, y1_1, y0_1; 

// First Half
lut_mux4 (y3_0, INIT0[15], INIT0[14], INIT0[13], INIT0[12], b0, a0);
lut_mux4 (y2_0, INIT0[11], INIT0[10], INIT0[9], INIT0[8], b0, a0);
lut_mux4 (y1_0, INIT0[7], INIT0[6], INIT0[5], INIT0[4], b0, a0);
lut_mux4 (y0_0, INIT0[3], INIT0[2], INIT0[1], INIT0[0], b0, a0);
lut_mux4 (prop_0, y3_0, y2_0, y1_0, y0_0, d0, c0);

wire gen_0 = (FUNC0 == "YES" )? 1'b0 : y0_0;
wire pass_cin_0 = (FUNC0 == "YES" )? 1'b0 : 1'b1;
wire cout_0 = (~prop_0 & gen_0) | (prop_0 & cin);
wire sum_0 = prop_0 ^ (pass_cin_0 & cin);

//Second Half
lut_mux4 (y3_1, INIT1[15], INIT1[14], INIT1[13], INIT1[12], b1, a1);
lut_mux4 (y2_1, INIT1[11], INIT1[10], INIT1[9], INIT1[8], b1, a1);
lut_mux4 (y1_1, INIT1[7], INIT1[6], INIT1[5], INIT1[4], b1, a1);
lut_mux4 (y0_1, INIT1[3], INIT1[2], INIT1[1], INIT1[0], b1, a1);
lut_mux4 (prop_1, y3_1, y2_1, y1_1, y0_1, d1, c1);

wire gen_1 = (FUNC1 == "YES" )? 1'b0 : y0_1;
wire pass_cin_1 = (FUNC1 == "YES" )? 1'b0 : 1'b1;
wire cout_1 = (~prop_1 & gen_1) | (prop_1 & cout_0);
wire sum_1 = prop_1 ^ (pass_cin_1 & cout_0); 
//------------------------------------

buf (cout, cout_1);
buf (s0, sum_0);
buf (s1, sum_1);

endmodule

