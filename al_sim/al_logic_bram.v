///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            bram
//   Filename : al_bram.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps
module AL_LOGIC_BRAM (
  dia,
  addra, cea, ocea, clka, wea, rsta,
  dib,
  addrb, ceb, oceb, clkb, web, rstb,
  doa,
  dob);
  // 1kx9
  parameter DATA_WIDTH_A = 9;
  parameter DATA_WIDTH_B = DATA_WIDTH_A;
  parameter ADDR_WIDTH_A = 10;
  parameter ADDR_WIDTH_B = ADDR_WIDTH_A;
  parameter DATA_DEPTH_A = 2 ** ADDR_WIDTH_A;
  parameter DATA_DEPTH_B = 2 ** ADDR_WIDTH_B;
  output  [DATA_WIDTH_A-1:0] doa;
  output  [DATA_WIDTH_B-1:0] dob;
  input   [DATA_WIDTH_A-1:0] dia; //DEFAULT := (others => '0')
  input   [DATA_WIDTH_B-1:0] dib; //DEFAULT := (others => '0')
  input   cea, ocea, clka, wea, rsta; //DEFAULT := '0'
  input   ceb, oceb, clkb, web, rstb; //DEFAULT := '0'
  input   [ADDR_WIDTH_A-1:0] addra; //DEFAULT := (others => '0')
  input   [ADDR_WIDTH_B-1:0] addrb; //DEFAULT := (others => '0')
  parameter MODE = "DP";                 // DP,SP,PDPW,FIFO
  parameter REGMODE_A = "NOREG";         // "NOREG", "OUTREG"
  parameter REGMODE_B = "NOREG";         // "NOREG", "OUTREG"
  parameter WRITEMODE_A = "NORMAL";      // "NORMAL", "READBEFOREWRITE", "WRITETHROUGH"
  parameter WRITEMODE_B = "NORMAL";      // "NORMAL", "READBEFOREWRITE", "WRITETHROUGH"
  parameter RESETMODE = "SYNC";          // "SYNC", "ASYNC"
  parameter DEBUGGABLE = "NO";           // "YES", "NO"
  parameter FORCE_KEEP = "OFF";          // "ON", "OFF"
  parameter INIT_FILE = "NONE";
  parameter IMPLEMENT = "9K";            // 9K | 9K(FAST) | 32K (all capitalized)

// TO BE FILLED

endmodule
