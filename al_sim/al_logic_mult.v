///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            mult
//   Filename : al_mult.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps
module AL_LOGIC_MULT (p, a, b, cea, ceb, cepd, clk, rstan, rstbn, rstpdn); 
    parameter INPUT_WIDTH_A = 18;
    parameter INPUT_WIDTH_B = 18;
    parameter OUTPUT_WIDTH = 36;
    output [OUTPUT_WIDTH-1:0] p;
    input [INPUT_WIDTH_A-1:0] a;
    input [INPUT_WIDTH_B-1:0] b;
    input cea; //DEFAULT := '0'
    input ceb; //DEFAULT := '0'
    input cepd; //DEFAULT := '0'
    input clk; //DEFAULT := '0'
    input rstan; //DEFAULT := '0'
    input rstbn; //DEFAULT := '0'
    input rstpdn; //DEFAULT := '0'
    parameter INPUTFORMAT = "SIGNED"; // SIGNED, UNSIGNED
    parameter INPUTREGA = "ENABLE";   // ENABLE, DISABLE
    parameter INPUTREGB = "ENABLE";   // ENABLE, DISABLE
    parameter OUTPUTREG = "ENABLE";   // ENABLE, DISABLE
    parameter SRMODE    = "ASYNC";    // ASYNC, SYNC
    parameter IMPLEMENT = "AUTO";    // AUTO, DSP, GATE

// TO BE FILLED

endmodule

