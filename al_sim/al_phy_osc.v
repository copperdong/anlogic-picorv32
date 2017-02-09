///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            OSC block 
//   Filename : al_phy_osc.v
//   Timestamp : Wed Nov  2 17:27:07 CST 2016
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/02/16 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////

`timescale  1 ns / 1 ps

module AL_PHY_OSC (osc_dis, osc_clk);		// osc clk

    input osc_dis;
    output osc_clk;

    parameter STDBY = "DISABLE"; 	// DISABLE/ENABLE 

    reg osc_reg, int_osc_clk;
    reg osc_dis_reg;

    initial
    begin
        int_osc_clk = 1'b0;
    end

    always @(*) begin
        if (STDBY == "ENABLE")
            osc_dis_reg = osc_dis;
        else
            osc_dis_reg = 0;
    end

    always
        #1.9 int_osc_clk = ~int_osc_clk;

    always @ (osc_dis_reg or int_osc_clk) begin
        if (osc_dis_reg == 1'b1)
            osc_reg = 1'b0;
        else
            osc_reg = int_osc_clk;
    end

    buf (osc_clk, osc_reg);

endmodule
