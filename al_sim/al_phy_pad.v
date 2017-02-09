///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//               pad
//   Filename : al_phy_pad.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module AL_PHY_PAD (ce, clk, eninr_dyn, ipad, ocomp, otrue, rst, ts, di, icomp, itrue, opad, bpad);
    parameter DEDCLK     = "DISABLE";   //DISABLE, ENABLE
    parameter GSR        = "ENABLE";    //ENABLE, DISABLE
    parameter SRMODE     = "SYNC";      //SYNC, ASYNC
    parameter TSMUX      = "1";         //1, 0, TS, INV
    parameter INCLKMUX   = "0";         //0, 1, CLK, INV
    parameter INCEMUX    = "CE";        //CE, INV, 1
    parameter INRSTMUX   = "0";         //0, RST, INV
    parameter IDDRMODE   = "OFF";       //OFF, ON
    parameter INDELMUX   = "NODEL";     //NODEL, FIXDEL
    parameter INDEL      = 0;           // 0-31
    parameter OUTCLKMUX  = "0";         //0, 1, CLK, INV
    parameter OUTCEMUX   = "CE";        //CE, INV, 1
    parameter OUTRSTMUX  = "0";         //0, RST, INV
    parameter ODDRMODE   = "OFF";       //OFF, ON
    parameter IN_DFFMODE = "NONE";      //NONE, FF, LATCH
    parameter IN_REGSET  = "RESET";     //RESET, SET
    parameter DO_DFFMODE = "NONE";      //NONE, FF, LATCH
    parameter DO_REGSET  = "RESET";     //RESET, SET
    parameter TO_DFFMODE = "NONE";      //NONE, FF, LATCH
    parameter TO_REGSET  = "RESET";     //RESET, SET
    parameter MODE       = "IN";        //IN, OUT, BI
    parameter DRIVE      = "NONE";      //NONE, 8, 12, 16, 20 24
    parameter IOTYPE     = "LVCMOS25";  //LVCMOS25, LVCMOS12, LVCMOS18, LVCMOS33, LVDS25 ...

    reg IN_INIT = 1'b0;
    reg DO_INIT = 1'b0;
    reg TO_INIT = 1'b0;

    output opad;
    output di;
    output itrue;
    output icomp;

    input ce, clk, eninr_dyn, ipad, ocomp, otrue, rst, ts;

    inout bpad;

    reg inclk, outclk, ince, outce, inrst, outrst;
    reg ts_in;
    reg data_delay;

    reg opad, di, itrue, icomp;
    reg in_reg, do_reg, ts_reg;
    reg in_latch, do_latch, ts_latch;
    reg do_out, do_t, data_in, ts_out;
    reg inlsr, outlsr, gsr;
    reg in_ddr_reg_t2, in_ddr_reg_c1, in_ddr_reg_c2;
    reg do_ddr_reg_c1, do_ddr_reg_c2;
    wire do_ddr;

    integer delay_time = INDEL;
    
    assign bpad = ts_out ? 1'bz : do_out;

    //initial begin
    always @(*) begin
        case (MODE)
            "BI"    : begin
                           if (DRIVE == "NONE") begin
                               $display ("in BI MODE, DRIVE strength cannot be set to NONE\n");
                               //$finish;
                           end
                           //if (ts_out === 1'b1)
                               data_in <= bpad;
                       end
            "OUT"   : begin
                           if (TSMUX == "1") begin
                               $display ("in OUT MODE, TS cannot be set to 1\n");
                               $finish;
                           end
                           if (DRIVE == "NONE") begin
                               $display ("in OUT MODE, DRIVE strength cannot be set to NONE\n");
                               //$finish;
                           end
                           opad = ts_out ? 1'bz : do_out;
                       end
            "IN"    : begin
                           if (TSMUX == "0") begin
                               $display ("in IN MODE, TS cannot be set to 0\n");
                               $finish;
                           end
                           data_in = ipad;
                       end
            default  : data_in = ipad;
        endcase

        case (INCLKMUX)
            "CLK"   : inclk = clk;
            "INV"   : inclk = ~clk;
            "0"     : inclk = 1'b0;
            default : inclk = 1'b0;
        endcase

        case (OUTCLKMUX)
            "CLK"   : outclk = clk;
            "INV"   : outclk = ~clk;
            "0"     : outclk = 1'b0;
            default : outclk = 1'b0;
        endcase

        case (TSMUX)
            "TS"    : ts_in = ts;
            "INV"   : ts_in = ~ts;
            "0"     : ts_in = 1'b0;
            "1"     : ts_in = 1'b1;
            default : ts_in = 1'b1;
        endcase

        case (INCEMUX)
            "1"     : ince = 1'b1;
            "CE"    : ince = ce;
            "INV"   : ince = ~ce;
            default : ince = ce;
        endcase

        case (OUTCEMUX)
            "1"     : outce = 1'b1;
            "CE"    : outce = ce;
            "INV"   : outce = ~ce;
            default : outce = ce;
        endcase

        case (INRSTMUX)
            "RST"   : inrst = rst;
            "INV"   : inrst = ~rst;
            "0"     : inrst = 1'b0;
            default : inrst = 1'b0;
        endcase

        case (OUTRSTMUX)
            "RST"   : outrst = rst;
            "INV"   : outrst = ~rst;
            "0"     : outrst = 1'b0;
            default : outrst = 1'b0;
        endcase

        case (INDELMUX)
            "FIXDEL"   : begin
                              #delay_time;
                              data_delay = data_in;
                          end
            "NODEL"    : data_delay = data_in;
            default    : data_delay = data_in;
        endcase

        case (GSR)
            "DISABLE"  : gsr = 1'b0;
            "ENABLE"   : gsr = glbl.gsr;
            default    : gsr = glbl.gsr;
        endcase

        case (SRMODE)
            "ASYNC"    : begin
                              inlsr = gsr | inrst;
                              outlsr = gsr | outrst;
                          end
            "SYNC"     : begin
                              inlsr = gsr;
                              outlsr = gsr;
                          end
            default    : begin
                              inlsr = gsr;
                              outlsr = gsr;
                          end
        endcase

        case (IN_REGSET)
            "SET"      : begin
                              if (IDDRMODE == "ON") begin
                                  $display ("in ddr mode, register can only be set to RESET\n");
                                  $finish;
                              end
                              IN_INIT = 1'b1;
                          end
            "RESET"    : IN_INIT = 1'b0;
            default    : IN_INIT = 1'b0;
        endcase

        case (DO_REGSET)
            "SET"      : begin
                              if (IDDRMODE == "ON") begin
                                  $display ("in ddr mode, register can only be set to RESET\n");
                                  $finish;
                              end
                              DO_INIT = 1'b1;
                          end
            "RESET"    : DO_INIT = 1'b0;
            default    : DO_INIT = 1'b0;
        endcase

        case (TO_REGSET)
            "SET"      : TO_INIT = 1'b1;
            "RESET"    : TO_INIT = 1'b0;
            default    : TO_INIT = 1'b0;
        endcase

        case (IN_DFFMODE)
            "FF"       : begin
                              itrue <= in_reg;
                              di <= data_delay;
                          end
            "LATCH"    : begin
                              if (IDDRMODE == "ON") begin
                                  $display ("in ddr mode, register can only be set to FF\n");
                                  $finish;
                              end
                              itrue <= in_latch;
                              di <= data_delay;
                          end
            "NONE"     : begin
                              if (IDDRMODE == "ON") begin
                                  $display ("in ddr mode, register can only be set to FF\n");
                                  $finish;
                              end
                              di <= data_delay;
                          end
            default    : begin
                              if (IDDRMODE == "ON") begin
                                  $display ("in ddr mode, register can only be set to FF\n");
                                  $finish;
                              end
                              di <= data_delay;
                          end
        endcase

        case (DO_DFFMODE)
            "FF"       : do_t <= do_reg;
            "LATCH"    : begin
                              if (ODDRMODE == "ON") begin
                                  $display ("in ddr mode, register can only be set to FF\n");
                                  $finish;
                              end
                              do_t <= do_latch;
                          end
            "NONE"     : begin
                              if (ODDRMODE == "ON") begin
                                  $display ("in ddr mode, register can only be set to FF\n");
                                  $finish;
                              end
                              do_t <= otrue;
                          end
            default    : do_t <= otrue;
        endcase

        case (TO_DFFMODE)
            "FF"       : ts_out <= ts_reg;
            "LATCH"    : ts_out <= ts_latch;
            "NONE"     : ts_out <= ts_in;
            default    : ts_out <= ts_in;
        endcase

        case (IDDRMODE)
            "ON"       : begin
                              itrue <= in_ddr_reg_t2;
                              icomp <= in_ddr_reg_c2;
                          end
            "OFF"      : icomp <= 1'b0;
            default    : icomp <= 1'b0;
        endcase

        case (ODDRMODE)
            "ON"       : do_out <= do_ddr;
            "OFF"      : do_out <= do_t;
            default    : do_out <= do_t;
        endcase
    end

    assign do_ddr = outclk ? do_t : do_ddr_reg_c2;
      wire in_ce = ince & ~inrst;

    always @(posedge inclk or posedge inlsr) begin
        if (inlsr || inrst)
            in_reg <= IN_INIT;
        else if(in_ce)
            in_reg <= data_delay;
    end

    always @(data_delay or posedge inlsr) begin
        if (inlsr)
            in_latch <= IN_INIT;
        else if (inrst && !inclk)
            in_latch <= IN_INIT;
        else if (!inclk & in_ce)
            in_latch <= data_delay;
    end

    wire out_ce = outce & ~outrst;

    always @(posedge outclk or posedge outlsr) begin
        if (outlsr || outrst)
            do_reg <= DO_INIT;
        else if(out_ce)
            do_reg <= otrue;
    end

    always @(otrue or posedge outlsr) begin
        if (outlsr)
            do_latch <= DO_INIT;
        else if (outrst && !outclk)
            do_latch <= DO_INIT;
        else if (!outclk & out_ce)
            do_latch <= otrue;
    end

    always @(posedge outclk or posedge outlsr) begin
        if (outlsr || outrst)
            ts_reg <= TO_INIT;
        else if(out_ce)
            ts_reg <= ts_in;
    end

    always @(ts_in or posedge outlsr) begin
        if (outlsr)
            ts_latch <= TO_INIT;
        else if (outrst && !outclk)
            ts_latch <= TO_INIT;
        else if (!outclk & out_ce)
            ts_latch <= ts_in;
    end

    //for DDRMODE
    always @(negedge inclk or posedge inlsr) begin
        if (inlsr || inrst)
            in_ddr_reg_c1 <= IN_INIT;
        else
            in_ddr_reg_c1 <= data_delay;
    end

    always @(posedge inclk or posedge inlsr) begin
        if (inlsr || inrst)
            in_ddr_reg_c2 <= IN_INIT;
        else
            in_ddr_reg_c2 <= in_ddr_reg_c1;
    end

    always @(posedge inclk or posedge inlsr) begin
        if (inlsr || inrst)
            in_ddr_reg_t2 <= IN_INIT;
        else
            in_ddr_reg_t2 <= in_reg;
    end

    always @(posedge outclk or posedge outlsr) begin
        if (outlsr || outrst)
            do_ddr_reg_c1 <= DO_INIT;
        else
            do_ddr_reg_c1 <= ocomp;
    end

    always @(negedge outclk or posedge outlsr) begin
        if (outlsr || outrst)
            do_ddr_reg_c2 <= DO_INIT;
        else
            do_ddr_reg_c2 <= do_ddr_reg_c1;
    end

endmodule
