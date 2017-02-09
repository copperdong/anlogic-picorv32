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
//    05/30/16 - correct the EP1 parameter value
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps
module AL_LOGIC_FIFO (
    rst,
    di, clkw, we, csw, 
    do, clkr, re, csr, ore,
    empty_flag, aempty_flag,
    full_flag, afull_flag
);
// 1kx9 by default
parameter DATA_WIDTH_W = 9;                 // 1 ... 9*48
parameter DATA_WIDTH_R = DATA_WIDTH_W;      // 1 ... 9*48
parameter DATA_DEPTH_W = 1024;                                        // 512, 1024, 2048, 4096, 8192
parameter DATA_DEPTH_R = DATA_WIDTH_W * DATA_DEPTH_W / DATA_WIDTH_R;  // 512, 1024, 2048, 4096, 8192
input   rst;
input   [DATA_WIDTH_W-1:0] di;
output  [DATA_WIDTH_R-1:0] do;
input   clkw, we;
input   clkr, re, ore; //DEFAULT := '0'
input [2:0] csw, csr;
output  empty_flag, aempty_flag; //DEFAULT := '0'
output  full_flag, afull_flag; //DEFAULT := '0'
parameter  MODE = "FIFO8K";
parameter  REGMODE_W   = "NOREG"; //NOREG, OUTREG
parameter  REGMODE_R   = "NOREG"; //NOREG, OUTREG   
parameter  E  = 0;
parameter  AE = 6;
parameter  AF = 1017;
parameter  F  = 1023;
    
parameter  GSR = "ENABLE";  //DISABLE, ENABLE
parameter  RESETMODE = "ASYNC"; //SYNC, ASYNC
parameter  ASYNC_RESET_RELEASE = "SYNC";  //SYNC, ASYNC

// TO BE FILLED

endmodule
