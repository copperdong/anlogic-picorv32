///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            idelay, iddr, oddr 
//   Filename : al_logic_io.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//    21/05/15 - update oddr module 
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps
module  AL_LOGIC_IDELAY(o,i);
output o;
input i;

parameter INDEL = 0;  // 0-31

localparam SIM_TAPDELAY_VALUE = 0.08;
reg [4:0] delay_count ;
reg o_out;

initial begin
  delay_count = INDEL;
end

    wire delay_chain_0,  delay_chain_1,  delay_chain_2,  delay_chain_3,
         delay_chain_4,  delay_chain_5,  delay_chain_6,  delay_chain_7,
         delay_chain_8,  delay_chain_9,  delay_chain_10, delay_chain_11,
         delay_chain_12, delay_chain_13, delay_chain_14, delay_chain_15,
         delay_chain_16, delay_chain_17, delay_chain_18, delay_chain_19,
         delay_chain_20, delay_chain_21, delay_chain_22, delay_chain_23,
         delay_chain_24, delay_chain_25, delay_chain_26, delay_chain_27,
         delay_chain_28, delay_chain_29, delay_chain_30, delay_chain_31;


// delay chain

    assign #0.24               delay_chain_0  = i;
    assign #SIM_TAPDELAY_VALUE delay_chain_1  = delay_chain_0;
    assign #SIM_TAPDELAY_VALUE delay_chain_2  = delay_chain_1;
    assign #SIM_TAPDELAY_VALUE delay_chain_3  = delay_chain_2;
    assign #SIM_TAPDELAY_VALUE delay_chain_4  = delay_chain_3;
    assign #SIM_TAPDELAY_VALUE delay_chain_5  = delay_chain_4;
    assign #SIM_TAPDELAY_VALUE delay_chain_6  = delay_chain_5;
    assign #SIM_TAPDELAY_VALUE delay_chain_7  = delay_chain_6;
    assign #SIM_TAPDELAY_VALUE delay_chain_8  = delay_chain_7;
    assign #SIM_TAPDELAY_VALUE delay_chain_9  = delay_chain_8;
    assign #SIM_TAPDELAY_VALUE delay_chain_10 = delay_chain_9;
    assign #SIM_TAPDELAY_VALUE delay_chain_11 = delay_chain_10;
    assign #SIM_TAPDELAY_VALUE delay_chain_12 = delay_chain_11;
    assign #SIM_TAPDELAY_VALUE delay_chain_13 = delay_chain_12;
    assign #SIM_TAPDELAY_VALUE delay_chain_14 = delay_chain_13;
    assign #SIM_TAPDELAY_VALUE delay_chain_15 = delay_chain_14;
    assign #SIM_TAPDELAY_VALUE delay_chain_16 = delay_chain_15;
    assign #SIM_TAPDELAY_VALUE delay_chain_17 = delay_chain_16;
    assign #SIM_TAPDELAY_VALUE delay_chain_18 = delay_chain_17;
    assign #SIM_TAPDELAY_VALUE delay_chain_19 = delay_chain_18;
    assign #SIM_TAPDELAY_VALUE delay_chain_20 = delay_chain_19;
    assign #SIM_TAPDELAY_VALUE delay_chain_21 = delay_chain_20;
    assign #SIM_TAPDELAY_VALUE delay_chain_22 = delay_chain_21;
    assign #SIM_TAPDELAY_VALUE delay_chain_23 = delay_chain_22;
    assign #SIM_TAPDELAY_VALUE delay_chain_24 = delay_chain_23;
    assign #SIM_TAPDELAY_VALUE delay_chain_25 = delay_chain_24;
    assign #SIM_TAPDELAY_VALUE delay_chain_26 = delay_chain_25;
    assign #SIM_TAPDELAY_VALUE delay_chain_27 = delay_chain_26;
    assign #SIM_TAPDELAY_VALUE delay_chain_28 = delay_chain_27;
    assign #SIM_TAPDELAY_VALUE delay_chain_29 = delay_chain_28;
    assign #SIM_TAPDELAY_VALUE delay_chain_30 = delay_chain_29;
    assign #SIM_TAPDELAY_VALUE delay_chain_31 = delay_chain_30;
    assign #SIM_TAPDELAY_VALUE delay_chain_32 = delay_chain_31;
    assign #SIM_TAPDELAY_VALUE delay_chain_33 = delay_chain_32;


    always @(delay_count) begin

	case (delay_count)
            0:  assign o_out = delay_chain_0;
            1:  assign o_out = delay_chain_1;
            2:  assign o_out = delay_chain_2;
            3:  assign o_out = delay_chain_3;
            4:  assign o_out = delay_chain_4;
            5:  assign o_out = delay_chain_5;
            6:  assign o_out = delay_chain_6;
            7:  assign o_out = delay_chain_7;
            8:  assign o_out = delay_chain_8;
            9:  assign o_out = delay_chain_9;
            10: assign o_out = delay_chain_10;
            11: assign o_out = delay_chain_11;
            12: assign o_out = delay_chain_12;
            13: assign o_out = delay_chain_13;
            14: assign o_out = delay_chain_14;
            15: assign o_out = delay_chain_15;
            16: assign o_out = delay_chain_16;
            17: assign o_out = delay_chain_17;
            18: assign o_out = delay_chain_18;
            19: assign o_out = delay_chain_19;
            20: assign o_out = delay_chain_20;
            21: assign o_out = delay_chain_21;
            22: assign o_out = delay_chain_22;
            23: assign o_out = delay_chain_23;
            24: assign o_out = delay_chain_24;
            25: assign o_out = delay_chain_25;
            26: assign o_out = delay_chain_26;
            27: assign o_out = delay_chain_27;
            28: assign o_out = delay_chain_28;
            29: assign o_out = delay_chain_29;
            30: assign o_out = delay_chain_30;
            31: assign o_out = delay_chain_31;
            default:
		assign o_out = delay_chain_0;

	endcase
    end 

  buf(o,o_out);

endmodule


module AL_LOGIC_IDDR (q1, q2, clk, d, rst);
    output q1;
    output q2;
    input clk;
    input d;
    input rst;

    parameter SRMODE = "SYNC"; //SYNC, ASYNC

    tri1 gsr_n = glbl.gsrn;
    wire rst_node = rst;
    wire async_rst = ~gsr_n | (SRMODE=="ASYNC")&&rst_node ;
    wire clk_node = clk; 
    reg [1:0] comp_reg,true_reg;

    
    always @(negedge clk_node or posedge async_rst)
    begin
     if(async_rst)
     comp_reg[0] <= 1'b1 ;
     else
     comp_reg[0] <= d ;
    end
    always @(posedge clk_node or posedge async_rst)
    begin
     if(async_rst)
     comp_reg[1] = 1'b0 ;
     else
     comp_reg[1] <= comp_reg[0] ;
    end
    
    always @(posedge clk_node or posedge async_rst)
    begin
     if(async_rst)
     true_reg[0] <= 1'b1 ;
     else
     true_reg[0] <= d ;
    end
    always @(posedge clk_node or posedge async_rst)
    begin
     if(async_rst)
     true_reg[1] = 1'b0 ;
     else
     true_reg[1] <= true_reg[0] ;
    end    
    
    buf (q2, comp_reg[1]);
    buf (q1, true_reg[1]);          	

endmodule

module AL_LOGIC_ODDR (q, clk, d1, d2, rst);
    output q;
    input clk;
    input d1;
    input d2;
    input rst;
    
    parameter SRMODE = "SYNC"; //SYNC, ASYNC

    wire rst_node = rst;
    tri1 gsr_n = glbl.gsrn;
    wire async_rst = ~gsr_n | (SRMODE=="ASYNC")&& rst_node ;   
    wire clk_node = clk;
    reg [1:0] comp_reg;
    reg true_reg;   
    wire ddr;
    buf (d_comp,d2);
    buf (d_true,d1);
    buf (q,ddr);
    always @(posedge clk_node or posedge async_rst)
    begin
     if(async_rst)
     comp_reg[0] = 1'b0 ;
     else
     comp_reg[0] = d_comp ;
    end
    always @(negedge clk_node or posedge async_rst)
    begin
     if(async_rst)
     comp_reg[1] = 1'b0 ;
     else
     comp_reg[1] = comp_reg[0] ;
    end

    always @(posedge clk_node or posedge async_rst)
    begin
     if(async_rst)
     true_reg = 1'b0 ;
     else
     true_reg = d_true ;
    end

    reg clk_mux;
    always @(clk_node)  clk_mux <= #0.1 clk_node; 
    assign   ddr = clk_mux ? true_reg : comp_reg[1] ;    

endmodule

module AL_LOGIC_PROGRAMN(programn);  // user programn in AL3A10LG144
input programn;

endmodule

