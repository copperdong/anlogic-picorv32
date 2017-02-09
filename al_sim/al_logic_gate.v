///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            basic gates for user instantiation 
//   Filename : al_logic_gate.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////

`timescale  1 ns / 1 ps

module  AL_LOGIC_BUF(o,i);     // user instantiated logic BUF
output o;
input i;

	buf lbuf (o, i);

endmodule

module  AL_LOGIC_GSRN(gsrn);   // user controllable GSRN
input gsrn;

assign  glbl.gsrn = gsrn;

endmodule

