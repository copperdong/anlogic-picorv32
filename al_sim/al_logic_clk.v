///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            bufg, bufio for clock, 
//            bufgmux as clock switch mux,
//            cclk as config clock 
//   Filename : al_logic_clock.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////

`timescale  1 ps / 1 ps

module  AL_LOGIC_BUFG(o,i);  // driver for global clk resource
output o;
input i;

	buf bufg (o, i);

endmodule

module  AL_LOGIC_BUFIO(o,i);  // driver for IO clk resource
output o;
input i;

	buf bufio (o, i);

endmodule

module  AL_LOGIC_BUFGMUX(o,i0,i1,s); // global clk switch mux
output o;
input i0;
input i1;
input s;

parameter INIT_OUT = "0";
parameter PRESELECT_I0 = "TRUE";
parameter PRESELECT_I1 = "FALSE";

   localparam INITOUT = (INIT_OUT=="1")? "1" : "0" ;
   localparam PRESELECT = ((PRESELECT_I0 == "TRUE")&&(PRESELECT_I1 == "FALSE"))? "CLK0" :  ((PRESELECT_I0 == "FALSE")&&(PRESELECT_I1 == "TRUE"))? "CLK1" : "NONE" ;

    wire clko;
    wire [1:0] ce = 2'b11;
    wire [1:0] clki = {i1,i0};
    wire [1:0] drct = 2'b00;
    wire [1:0] sel = {s,~s};
AL_PHY_CSB #(.CSBHOLD("YES"),.CSBINITOUT(INITOUT),.CSBPRESELECT(PRESELECT)) bufgmux(.clko(clko), .ce(ce), .clki(clki), .drct(drct), .sel(sel));
buf (o,clko);

endmodule

module AL_LOGIC_CCLK(cclk);  // config clk
output cclk;

endmodule

