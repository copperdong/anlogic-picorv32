///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            global clk,  io clock, clk div
//   Filename : al_phy_clk.v
//   Timestamp : Thu Apr  24 09:30:30 CST 2014
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    4/24/14 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module AL_PHY_GCLK (clki, clko);
    input clki;
    output clko;

    assign clko = clki;

endmodule

module AL_PHY_IOCLK (clki, stop, clko);
    input clki;
    input stop;
    output clko;

    parameter  STOPCLK = "DISABLE"; // ENABLE,DISABLE

    reg ck_en1,ck_en2;
    reg stop_en;

    initial begin
        ck_en1 = 1'b0;
        ck_en2 = 1'b0;
    end

    initial begin
        case (STOPCLK)
            "DISABLE" : stop_en = 1'b0;
            "ENABLE"  : stop_en = 1'b1;
            default   : begin
                            $display("Parameter Warning : The attribute STOPCLK on ECLK instance %m is set to %s.  Legal values for this attribute are ENABLE or DISABLE.", STOPCLK);
                            //$finish;
                        end
        endcase
    end

    assign clksel = ~(stop & stop_en);

    always @(negedge clki)
        if(clksel==1'b0) begin
            ck_en1 <= 1'b0;
            ck_en2 <= ck_en1;
        end
        else begin
            ck_en1 <= 1'b1;
            ck_en2 <= ck_en1;
        end

    assign clko = stop_en ? (clki & ck_en2) : clki;

endmodule
 
module AL_PHY_CLKDIV (clki, rst, rls, clkdiv1, clkdivx);

    output clkdiv1, clkdivx;
    input clki;
    input rst;
    input rls;

    tri1 gsrn = glbl.gsrn;
    //tri1 gsrn;

    parameter GSR = "DISABLE";     //  DISABLE/ENABLE 
    parameter DIV = "2";  //  2/4

//check parameter
    initial begin
        if (DIV != "2" && DIV != "4") begin
        $display("attribute syntax error : the attribute DIV on clkdiv instance %m is set to %s. legal values for this attribute are 2 or 4.", DIV);
        $finish;
        end
    end

    reg sr_reg1, sr_reg2, SRN, rst_d1, set;
    wire clkdiv1_val, clkdiv1_buf, sr;
    reg [2:0] count_dn;
    reg clki_buf;

    buf inst_buf0 (clkdiv1, clkdiv1_buf);
    assign clkdivx = (DIV == "2") ? count_dn[0] : count_dn[1];

    initial 
    begin
        count_dn = 2'b00;
    end

    always @ (gsrn) begin
        if (GSR == "ENABLE") begin
            SRN = gsrn;
        end
        else if (GSR == "DISABLE")
            SRN = 1'b1;
    end

    not (SR1, SRN);
    or (sr, rst, SR1);

    always @ (posedge clki)
    begin
        sr_reg1 <= sr;
    end

    always @ (posedge clki)
    begin
        sr_reg2 <= sr_reg1;
    end

    always @ (clki)
    begin
        clki_buf <= clki;
    end

    and (clkdiv1_val, clki_buf, ~sr_reg1);
    and (clkdiv1_buf, clkdiv1_val, ~sr_reg2);

    always @ (posedge clki or posedge sr)
    begin
        if (sr == 1'b1)
            rst_d1 <= 1'b0;
        else
            rst_d1 <= 1'b1;
    end

    and (setn, rst_d1, rls);
    always @ (posedge clki or negedge setn)
    begin
        if (setn == 1'b0)
            count_dn <= 2'b00;
        else
            count_dn <= count_dn - 1;
    end

endmodule

