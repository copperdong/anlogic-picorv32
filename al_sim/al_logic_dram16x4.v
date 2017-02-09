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
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
// simulation model for DRAM16X4
`timescale 1 ns / 1 ps
module AL_LOGIC_DRAM16X4 ( di, waddr, we, wclk, raddr, do);
parameter INIT_D0=16'h0000;
parameter INIT_D1=16'h0000;
parameter INIT_D2=16'h0000;
parameter INIT_D3=16'h0000;
  input [3:0]di;
  input [3:0]waddr;
  input wclk;
  input we;
  input [3:0]raddr;
  output [3:0]do;

wire dpram_mode,dpram_we;
wire [3:0]dpram_di;
wire [3:0]dpram_waddr;
wire dpram_wclk;  
// PLB MSLICE0
	AL_PHY_MSLICE 
	  #(
	  .MODE("DPRAM"),
	  .INIT_LUT0(INIT_D0),
	  .INIT_LUT1(INIT_D1)
	  )
	  	MSLICE_0  (
	  .a({raddr[0],raddr[0]}),
	  .b({raddr[1],raddr[1]}),
	  .c({raddr[2],raddr[2]}),
	  .d({raddr[3],raddr[3]}),
	  .ce(),
	  .clk(),
	  .mi(),
	  .sr(),
	  .fci(),
	  .f({do[1],do[0]}),
	  .fx(),
	  .q(),
	  .fco(),
	  .dpram_mode(dpram_mode),
	  .dpram_di(dpram_di[1:0]),
	  .dpram_we(dpram_we),
	  .dpram_waddr(dpram_waddr[3:0]),
	  .dpram_wclk(dpram_wclk)     
	  );
	
	AL_PHY_MSLICE 
	  #(
	  .MODE("DPRAM"),
	  .INIT_LUT0(INIT_D2),
	  .INIT_LUT1(INIT_D3)
	   )
	  	MSLICE_1 (
	  .a({raddr[0],raddr[0]}),
	  .b({raddr[1],raddr[1]}),
	  .c({raddr[2],raddr[2]}),
	  .d({raddr[3],raddr[3]}),
	  .ce(),
	  .clk(),
	  .mi(),
	  .sr(),
	  .fci(),
	  .f({do[3],do[2]}),
	  .fx(),
	  .q(),
	  .fco(),
	  .dpram_mode(dpram_mode),
	  .dpram_di(dpram_di[3:2]),
	  .dpram_we(dpram_we),
	  .dpram_waddr(dpram_waddr[3:0]),
	  .dpram_wclk(dpram_wclk)       
	  );
	
	AL_PHY_LSLICE 
	  #(
	  .MODE("RAMW")
	  )	  
	  	LSLICE_2 (
	  .a({di[0],waddr[0]}),
	  .b({di[1],waddr[1]}),
	  .c({di[2],waddr[2]}),
	  .ce(),
	  .clk(wclk),
	  .d({di[3],waddr[3]}),
	  .e({1'b1,we}),
	  .mi(),
	  .sr(),
	  .fci(),
	  .f(),
	  .fx(),
	  .q(),
	  .fco(),
	  // special disram internal interface
	  .dpram_mode(dpram_mode),
	  .dpram_di(dpram_di[3:0]),
	  .dpram_we(dpram_we),
	  .dpram_waddr(dpram_waddr[3:0]),
	  .dpram_wclk(dpram_wclk)   
	  );
endmodule

