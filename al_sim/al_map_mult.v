///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            18X18/9x9 Signed Multiplier
//   Filename : al_map_mult.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
`timescale  1 ns / 10 ps

module AL_MAP_BLE_MULT18X18 (acout, bcout, p, signeda, signedb, a, b, acin, bcin, cea, ceb, cepd, clk, rsta_n, rstb_n, rstpd_n,
            sourcea, sourceb); 

    output [17:0] acout; 
    output [17:0] bcout; 
    output [35:0] p; 

    input signeda;
    input signedb;
    input [17:0] a;
    input [17:0] b;
    input [17:0] acin;
    input [17:0] bcin;
    input cea;
    input ceb;
    input cepd;
    input clk;
    input rsta_n;
    input rstb_n;
    input rstpd_n;
    input sourcea;
    input sourceb;


    tri1 sourcea, sourceb;
    tri1 signeda, signedb;
    tri1 cea, ceb;
    tri1 cepd, rsta_n, rstb_n, rstpd_n;
    tri1 [17:0] a,b,acin,bcin;

    tri1 gsrn = glbl.gsrn;
    parameter INPUTREGA = "ENABLE"; // ENABLE/DISABLE
    parameter INPUTREGB = "ENABLE"; // ENABLE/DISABLE
    parameter OUTPUTREG = "ENABLE"; // ENABLE/DISABLE
    parameter SRMODE    = "ASYNC";  // ASYNC/SYNC
    //parameter MODE      = "MULT18X18C"; //MULT9X9C/MULT18X18C
    

    AL_PHY_MULT18 #(.INPUTREGA(INPUTREGA),
                    .INPUTREGB(INPUTREGB),
                    .OUTPUTREG(OUTPUTREG),
                    .SRMODE(SRMODE),
                    .MODE("MULT18X18C"))
    al_phy_mult18(.acout(acout), .bcout(bout), .p(p), .signeda(signeda), .signedb(signedb), .a(a), .b(b), .acin(acin), .bcin(bcin), .cea(cea), .ceb(ceb), .cepd(cepd), .clk(clk), .rsta_n(rsta_n), .rstb_n(rstb_n), .rstpd_n(rstpd_n));

endmodule

module AL_MAP_BLE_MULT9X9 (acout, bcout, p, signeda, signedb, a, b, acin, bcin, cea, ceb, cepd, clk, rsta_n, rstb_n, rstpd_n,
            sourcea, sourceb); 

    output [8:0] acout; 
    output [8:0] bcout; 
    output [17:0] p; 

    input signeda;
    input signedb;
    input [8:0] a;
    input [8:0] b;
    input [8:0] acin;
    input [8:0] bcin;
    input cea;
    input ceb;
    input cepd;
    input clk;
    input rsta_n;
    input rstb_n;
    input rstpd_n;
    input sourcea;
    input sourceb;


    tri1 sourcea, sourceb;
    tri1 signeda, signedb;
    tri1 cea, ceb;
    tri1 cepd, rsta_n, rstb_n, rstpd_n;
    tri1 [8:0] a,b,acin,bcin;

    tri1 gsrn = glbl.gsrn;
    parameter INPUTREGA = "ENABLE"; // ENABLE/DISABLE
    parameter INPUTREGB = "ENABLE"; // ENABLE/DISABLE
    parameter OUTPUTREG = "ENABLE"; // ENABLE/DISABLE
    parameter SRMODE    = "ASYNC";  // ASYNC/SYNC
    //parameter MODE      = "MULT18X18C"; //MULT9X9C/MULT18X18C
    

    wire [8:0] a_dummy,b_dummy,acin_dummy,bcin_dummy;
    wire [8:0] acout_dummy; 
    wire [8:0] bcout_dummy; 
    wire [17:0] p_dummy; 

    AL_PHY_MULT18 #(.INPUTREGA(INPUTREGA),
                    .INPUTREGB(INPUTREGB),
                    .OUTPUTREG(OUTPUTREG),
                    .SRMODE(SRMODE),
                    .MODE("MULT9X9C"))
    al_phy_mult18(.acout({acout_dummy,acout}), .bcout({bcout_dummy,bout}), .p({p_dummy,p}), .signeda(signeda), .signedb(signedb), .a({a_dummy,a}), .b({b_dummy,b}), .acin({acin_dummy,acin}), .bcin({bcin_dummy,bcin}), .cea(cea), .ceb(ceb), .cepd(cepd), .clk(clk), .rsta_n(rsta_n), .rstb_n(rstb_n), .rstpd_n(rstpd_n));

endmodule

