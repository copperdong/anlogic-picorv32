///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            clock switch block
//   Filename : al_phy_csb.v
//   Timestamp : Thu Nov  7 15:11:35 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////

`timescale  1 ns / 1ps 

module AL_PHY_CSB (clko, ce, clki, drct, sel, ignr);

    output clko;
    input [1:0] ce;
    input [1:0] clki;
    input [1:0] drct;
    input [1:0] sel;
    input [1:0] ignr;

    tri1 gsrn = glbl.gsrn;
    parameter HOLD      = "YES";     //  YES/NO 
    parameter INITOUT   = "0";       //  0/1
    parameter PRESELECT = "NONE";    //  CLK0/CLK1/NONE
    parameter TESTMODE  = "DISABLE";  //  ENABLE/DISABLE

    reg clko;
    reg q0, q1;
    reg q0_en, q1_en;
    reg preslct_0, preslct_1;
    reg task_input_ce0, task_input_ce1, task_input_i0;
    reg task_input_i1, task_input_drct0, task_input_drct1;
    reg task_input_gsr, task_input_s0, task_input_s1;

    wire clk0t, clk1t;
    wire initvalue;
// *** parameter checking

//        always @(*) begin
        initial begin
	  case (PRESELECT)
            "CLK0"  : begin preslct_0 = 1'b1; preslct_1 = 1'b0; end
            "CLK1"  : begin preslct_0 = 1'b0; preslct_1 = 1'b1; end
            "NONE"  : begin preslct_0 = 1'b0; preslct_1 = 1'b0; end
            default : begin
              $display("attribute syntax error: the attribute PRESELECT on csb instance %m is set to %s. legal values for this attribute are CLK0 or CLK0 or NONE.", PRESELECT);
              $finish;
            end
	  endcase
	end

//        always @(*) begin



// *** start here
	assign clk0t = (INITOUT=="1") ? ~clki[0] : clki[0];
	assign clk1t = (INITOUT=="0") ? ~clki[1] : clki[1];
	assign initvalue = (INITOUT=="1") ? 1'b1 : 1'b0;
// *** input ENABLE for clki1
	always @(drct[1] or clk1t or sel[1] or gsrn or q0) begin
	  if (gsrn == 0)
            #1 q1_en <= preslct_1;
	  else if (gsrn == 1) begin
            if ((clk1t == 0) && (drct[1] == 0))
             #1 q1_en <= q1_en;
	    else if ((clk1t == 1) || (drct[1] == 1))
             #1 q1_en <= (~q0 && sel[1]);
	  end
        end

// *** output q1 for i1
	always @(q1_en or ce[1] or clk1t or drct[1] or gsrn) begin
	  if (gsrn == 0)
            #1 q1 <= preslct_1;
	  else if (gsrn == 1) begin
	    if ((clk1t == 1)&& (drct[1] == 0))
             #1 q1 <= q1;
	    else if ((clk1t == 0) || (drct[1] == 1))
             #1 q1 <= (ce[1] && q1_en);
	  end
	end

// *** input ENABLE for clki0
	always @(drct[0] or clk0t or sel[0] or gsrn or q1) begin
	  if (gsrn == 0)
            #1 q0_en <= preslct_0;
	  else if (gsrn == 1) begin
	    if ((clk0t == 0) && (drct[0] == 0))
              #1 q0_en <= q0_en;
	    else if ((clk0t == 1) || (drct[0] == 1))
              #1 q0_en <= (~q1 && sel[0]);
	  end
	end

// *** output q0 for clki0
	always @(q0_en or ce[0] or clk0t or drct[0] or gsrn) begin
	  if (gsrn == 0)
            #1 q0 <= preslct_0;
	  else if (gsrn == 1) begin 
	    if ((clk0t == 1) && (drct[0] == 0))
             #1 q0 <= q0;
	    else if ((clk0t == 0) || (drct[0] == 1))
             #1 q0 <= (ce[0] && q0_en);
	  end
	end

	always @(q0 or q1 or clk0t or clk1t) begin 
	  case ({q1, q0})
            2'b01: clko = clki[0];
            2'b10: clko = clki[1]; 
            2'b00: clko = initvalue;
	    2'b11: begin
	           q0 = 1'bx;
		   q1 = 1'bx;
		   q0_en = 1'bx;
		   q1_en = 1'bx;
		   clko = 1'bx;
	    end
          endcase
	end

endmodule


