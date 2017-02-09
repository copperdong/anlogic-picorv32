///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            dram
//   Filename : al_logic_dram.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    16/03/14 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
// simulation model for DRA4
`timescale 1 ns / 1 ps
module AL_LOGIC_DRAM (di, waddr, we, wclk, do, raddr);
parameter DATA_WIDTH_W = 9;
parameter ADDR_WIDTH_W = 10;
parameter DATA_DEPTH_W = 2 ** ADDR_WIDTH_W;
parameter DATA_WIDTH_R = 9;
parameter ADDR_WIDTH_R = 10;
parameter DATA_DEPTH_R = 2 ** ADDR_WIDTH_R;

input [DATA_WIDTH_W-1:0]di;
input [ADDR_WIDTH_W-1:0]waddr;
input wclk;
input we;
output [DATA_WIDTH_R-1:0]do;
input [ADDR_WIDTH_R-1:0]raddr;

parameter INIT_FILE = "NONE";

// TO BE FILLED

endmodule
