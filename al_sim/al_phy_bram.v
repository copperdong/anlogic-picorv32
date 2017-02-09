///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            block RAM
//   Filename : al_phy_bram.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//    04/04/14 - Update RAM initial parameter.	
//    04/23/14 - Update parameter : GSRMODE to GSR
//    06/20/14 - update INVMUX parameter
//    01/14/15 - update Aport:18bit Bport:2bit function error at dinb[1];
//    03/04/15 - update wea/web autoset to 1/0 when 18bit RAM and FIFO mode 
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module AL_PHY_BRAM (
  dia, csa,
  addra, cea, ocea, clka, wea, rsta,
  dib, csb,
  addrb, ceb, oceb, clkb, web, rstb,
  doa,
  dob);

output  [8:0] doa;
output  [8:0] dob;
input   [8:0] dia;
input   [8:0] dib;
input   [2:0] csa;
input   [2:0] csb;
input   cea, ocea, clka, wea, rsta;
input   ceb, oceb, clkb, web, rstb;
input   [12:0] addra;
input   [12:0] addrb;

tri1 	[8:0] dia;
tri1 	[8:0] dib;
tri1 	[2:0] csa; 
tri1 	[2:0] csb; 
tri1    cea, ocea, clka, wea;
tri1    ceb, oceb, clkb, web;
tri0  	rsta,rstb;         
tri1 	[12:0] addra;
tri1 	[12:0] addrb;

parameter MODE = "DP8K";               // DP8K,SP8K,PDPW8K,FIFO8K : for DATA_WIDTH = 18, MODE must be "PDPW8K" or "FIFO8K" 
parameter DATA_WIDTH_A = "9";          // 1, 2, 4, 9, 18
parameter DATA_WIDTH_B = "9";          // 1, 2, 4, 9, 18

parameter REGMODE_A = "NOREG";         // "NOREG", "OUTREG"
parameter REGMODE_B = "NOREG";         // "NOREG", "OUTREG"
parameter WRITEMODE_A = "NORMAL";      // "NORMAL", "READBEFOREWRITE", "WRITETHROUGH"
parameter WRITEMODE_B = "NORMAL";      // "NORMAL", "READBEFOREWRITE", "WRITETHROUGH"
parameter GSR = "ENABLE";              // "DISABLE", "ENABLE"
parameter RESETMODE = "SYNC";          // "SYNC", "ASYNC"
parameter ASYNC_RESET_RELEASE = "SYNC";          // "SYNC", "ASYNC"
// 
parameter CEAMUX = "SIG"; //0, 1, INV, SIG
parameter CEBMUX = "SIG"; //0, 1, INV, SIG
parameter OCEAMUX = "SIG"; //0, 1, INV, SIG
parameter OCEBMUX = "SIG"; //0, 1, INV, SIG
parameter RSTAMUX = "SIG"; //0, 1, INV, SIG
parameter RSTBMUX = "SIG"; //0, 1, INV, SIG
parameter CLKAMUX = "SIG"; //0, 1, INV, SIG
parameter CLKBMUX = "SIG"; //0, 1, INV, SIG
parameter WEAMUX = "SIG"; //0, 1, INV, SIG
parameter WEBMUX = "SIG"; //0, 1, INV, SIG
parameter CSA0 = "SIG" ; //1,0,INV,SIG
parameter CSA1 = "SIG" ;
parameter CSA2 = "SIG" ;
parameter CSB0 = "SIG" ;
parameter CSB1 = "SIG" ;
parameter CSB2 = "SIG" ;
parameter READBACK = "OFF"; // ON, OFF


    parameter INIT_FILE = "NONE";
    parameter INITP_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INITP_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_00 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_01 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_02 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_03 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_04 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_05 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_06 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_07 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_08 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_09 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_0F = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_10 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_11 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_12 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_13 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_14 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_15 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_16 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_17 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_18 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_19 = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1A = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1B = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1C = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1D = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1E = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    parameter INIT_1F = 256'h0000000000000000000000000000000000000000000000000000000000000000;


         

   localparam  array_size = 9216;

   localparam addr_width_a = (DATA_WIDTH_A == "1") ? 13 : (DATA_WIDTH_A == "2") ? 12 :
                       (DATA_WIDTH_A == "4") ? 11 : (DATA_WIDTH_A == "9") ? 10 : 
                       (DATA_WIDTH_A == "18") ? 9 : 8 ;
   localparam addr_width_b = (DATA_WIDTH_B == "1") ? 13 : (DATA_WIDTH_B == "2") ? 12 :
                       (DATA_WIDTH_B == "4") ? 11 : (DATA_WIDTH_B == "9") ? 10 : 
                       (DATA_WIDTH_B == "18") ? 9 : 8;
   localparam data_width__a = (DATA_WIDTH_A == "1") ? 1 : (DATA_WIDTH_A == "2") ? 2 :
                       (DATA_WIDTH_A == "4") ? 4 : (DATA_WIDTH_A == "9") ? 9 : 9 ;
   localparam data_width__b = (DATA_WIDTH_B == "1") ? 1 : (DATA_WIDTH_B == "2") ? 2 :
                       (DATA_WIDTH_B == "4") ? 4 : (DATA_WIDTH_B == "9") ? 9 : 9;

   localparam div_a = (DATA_WIDTH_A == "1") ? 8 : (DATA_WIDTH_A == "2") ? 4 :
                       (DATA_WIDTH_A == "4") ? 2 : (DATA_WIDTH_A == "9") ? 9216 : 9216 ;
   localparam div_b = (DATA_WIDTH_B == "1") ? 8 : (DATA_WIDTH_B == "2") ? 4 :
                       (DATA_WIDTH_B == "4") ? 2 : (DATA_WIDTH_B == "9") ? 9216 : 9216;
                       
   integer DWA_VALUE, DWB_VALUE;

reg cea_node;
reg ocea_node;
reg ceb_node;
reg oceb_node;
reg clka_node;
reg clkb_node;
reg wrea_node_tmp;
reg wreb_node_tmp;
reg rsta_node;
reg rstb_node;


reg csa0_node, csa1_node, csa2_node;
reg csb0_node, csb1_node, csb2_node;
reg param_trig;
initial begin
param_trig=0;
param_trig=1;
end
 
   always @(param_trig)
   begin
        case (CSA0)
            "SIG"   	: assign csa0_node = csa[0];
            "0" 	: assign csa0_node = 0;
            "1" 	: assign csa0_node = 1;
            "INV"   	: assign csa0_node = ~csa[0];
            default 	: assign csa0_node = 1;
        endcase

        case (CSA1)
            "SIG"   	: assign csa1_node = csa[1];
            "0" 	: assign csa1_node = 0;
            "1" 	: assign csa1_node = 1;
            "INV"   	: assign csa1_node = ~csa[1];
            default 	: assign csa1_node = 1;
        endcase

        case (CSA2)
            "SIG"   	: assign csa2_node = csa[2];
            "0" 	: assign csa2_node = 0;
            "1" 	: assign csa2_node = 1;
            "INV"   	: assign csa2_node = ~csa[2];
            default 	: assign csa2_node = 1;
        endcase

        case (CSB0)
            "SIG"   	: assign csb0_node = csb[0];
            "0" 	: assign csb0_node = 0;
            "1" 	: assign csb0_node = 1;
            "INV"   	: assign csb0_node = ~csb[0];
            default 	: assign csb0_node = 1;
        endcase

        case (CSB1)
            "SIG"   	: assign csb1_node = csb[1];
            "0" 	: assign csb1_node = 0;
            "1" 	: assign csb1_node = 1;
            "INV"   	: assign csb1_node = ~csb[1];
            default 	: assign csb1_node = 1;
        endcase

        case (CSB2)
            "SIG"   	: assign csb2_node = csb[2];
            "0" 	: assign csb2_node = 0;
            "1" 	: assign csb2_node = 1;
            "INV"   	: assign csb2_node = ~csb[2];
            default 	: assign csb2_node = 1;
        endcase

        case (RSTAMUX)
            "SIG"   	: assign rsta_node = rsta;
            "0" 	: assign rsta_node = 0;
            "1" 	: assign rsta_node = 1;
            "INV"   	: assign rsta_node = ~rsta;
            default 	: assign rsta_node = rsta;
        endcase
    
        case (RSTBMUX)
            "SIG"   	: assign rstb_node = rstb;
            "0" 	: assign rstb_node = 0;
            "1" 	: assign rstb_node = 1;
            "INV"   	: assign rstb_node = ~rstb;
            default 	: assign rstb_node = rstb;
        endcase 
              
        case (CEAMUX)
            "SIG"   	: assign cea_node = cea;
            "0" 	: assign cea_node = 0;
            "1" 	: assign cea_node = 1;
            "INV"   	: assign cea_node = ~cea;
            default 	: assign cea_node = cea;
        endcase
     
        case (CEBMUX)
            "SIG"   	: assign ceb_node = ceb;
            "0" 	: assign ceb_node = 0;
            "1" 	: assign ceb_node = 1;
            "INV"   	: assign ceb_node = ~ceb;
            default 	: assign ceb_node = ceb;
        endcase        
    
        case (OCEAMUX)
            "SIG"   	: assign ocea_node = ocea;
            "0" 	: assign ocea_node = 0;
            "1" 	: assign ocea_node = 1;
            "INV"   	: assign ocea_node = ~ocea;
            default 	: assign ocea_node = ocea;
        endcase
     
        case (OCEBMUX)
            "SIG"   	: assign oceb_node = oceb;
            "0" 	: assign oceb_node = 0;
            "1" 	: assign oceb_node = 1;
            "INV"   	: assign oceb_node = ~oceb;
            default 	: assign oceb_node = oceb;
        endcase        
     
        case (WEAMUX)
            "SIG"   	: assign wrea_node_tmp = wea;
            "0" 	: assign wrea_node_tmp = 0;
            "1" 	: assign wrea_node_tmp = 1;
            "INV"   	: assign wrea_node_tmp = ~wea;
            default 	: assign wrea_node_tmp = wea;
        endcase

        case (WEBMUX)
            "SIG"   	: assign wreb_node_tmp = web;
            "0" 	: assign wreb_node_tmp = 0;
            "1" 	: assign wreb_node_tmp = 1;
            "INV"   	: assign wreb_node_tmp = ~web;
            default 	: assign wreb_node_tmp = web;
        endcase          

        case (CLKAMUX)
            "SIG"   	: assign clka_node = clka;
            "0" 	: assign clka_node = 0;
            "1" 	: assign clka_node = 1;
            "INV"   	: assign clka_node = ~clka;
            default 	: assign clka_node = clka;
        endcase

        case (CLKBMUX)
            "SIG"   	: assign clkb_node = clkb;
            "0" 	: assign clkb_node = 0;
            "1" 	: assign clkb_node = 1;
            "INV"   	: assign clkb_node = ~clkb;
            default 	: assign clkb_node = clkb;
        endcase                     
   end // always
   
   initial begin
   case(DATA_WIDTH_A)
    "1" : DWA_VALUE = 1;
    "2" : DWA_VALUE = 2;
    "4" : DWA_VALUE = 4;
    "9" : DWA_VALUE = 9;    
    "18" : DWA_VALUE = 18;
    default : $display("Parameter Error : The attribute DATA_WIDTH_A on bram instance is set to %s. it's not Legal value.", DATA_WIDTH_A);                   
   endcase
   
   case(DATA_WIDTH_B)
    "1" : DWB_VALUE = 1;
    "2" : DWB_VALUE = 2;
    "4" : DWB_VALUE = 4;
    "9" : DWB_VALUE = 9;    
    "18" : DWB_VALUE = 18;
    default : $display("Parameter Error : The attribute DATA_WIDTH_B on bram instance is set to %s. it's not Legal value.", DATA_WIDTH_B);                   
   endcase     

   if(DATA_WIDTH_A == "18" && MODE !="PDPW8K" && MODE !="FIFO8K" )
     $display("Parameter Error : For bram 18bit width. The attribute MODE must be set to PDPW8K or FIFO8K ");                   
     
   if(DATA_WIDTH_B == "18" && MODE !="PDPW8K" && MODE !="FIFO8K" )
     $display("Parameter Error : For bram 18bit width. The attribute MODE must be set to PDPW8K or FIFO8K ");      
   end                    

//tri1 gsr_sig = ~ glbl.gsr; //gsr_sig = 0 , reset 
tri1 gsrn_sig =  glbl.gsrn; //gsr_sig = 0 , reset// 
tri1 done_sig =  glbl.done_gwe;

wire wrea_node;
wire wreb_node;
assign wrea_node = (DATA_WIDTH_A == "18" | MODE =="FIFO8K" ) ? 1'b1 : wrea_node_tmp ;
assign wreb_node = (DATA_WIDTH_B == "18" | MODE =="FIFO8K" ) ? 1'b0 : wreb_node_tmp ;

reg v_mem[array_size - 1:0];
integer i, j;
wire [8:0] dina;
wire [8:0] dinb;
wire [8:0] dina_node;
wire [8:0] dinb_node;
wire [8:0] dinb_dob;
wire [8:0] doa;
wire [8:0] dob;


reg  srn, srn_pur;
reg [8:0] doa_node;
reg [8:0] doa_node_tr;
reg [8:0] doa_node_wt;
reg [8:0] doa_node_rbr;
reg [8:0] dob_node;
reg [8:0] dob_node_tr;
reg [8:0] dob_node_wt;
reg [8:0] dob_node_rbr;
reg [17:0] do_node_tr;
reg [17:0] do_node_wt;
reg [17:0] do_node_rbr;
reg csa_en_reg;
reg csb_en_reg;
wire [12:0] adabuf;
wire [12:0] adbbuf;
wire [addr_width_a-1:0] addra_node;
wire [addr_width_b-1:0] addrb_node;
assign addra_node = adabuf[12:(13 - addr_width_a)];
assign addrb_node = adbbuf[12:(13 - addr_width_b)];
wire [17:0] dinab_node;
reg [17:0] dinab_reg;
reg [17:0] dinab_reg_sync;
reg [data_width__a-1:0] dina_reg;
reg [data_width__a-1:0] dina_reg_sync;
reg [data_width__b-1:0] dinb_reg;
reg [data_width__b-1:0] dinb_reg_sync;
reg [data_width__b-1:0] dinb_dob_reg;
reg [addr_width_a-1:0] addra_reg;
reg [addr_width_a-1:0] addra_reg_sync;
reg [addr_width_b-1:0] addrb_reg;
reg [addr_width_b-1:0] addrb_reg_sync;
reg [addr_width_a-1:0] addra_out;
reg [addr_width_b-1:0] addrb_out;
reg bwa0_reg;
reg bwa0_reg_sync;
reg bwa1_reg;
reg bwa1_reg_sync;
reg bwb_reg;
reg bwb_reg_sync;
wire bwa0_node;
wire bwa1_node;
wire bwb_node;
reg [8:0] doab_reg;
reg [8:0] doab_reg_sync, doab_reg_async;
reg [8:0] doa_reg;
reg [8:0] doa_reg_sync, doa_reg_async;
reg [8:0] dob_reg;
reg [8:0] dob_reg_sync, dob_reg_async;
reg [8:0] doa_out;
reg [8:0] dob_out;
reg wrena_reg;
reg wrena_reg_sync;
reg wrenb_reg;
reg wrenb_reg_sync;
reg [addr_width_b-1:0] addrb_read_reg;
reg rena_reg;
reg rena_reg_sync;
reg renb_reg;
reg renb_reg_sync;
reg clka_valid;
reg clka_valid_new1;
reg clka_valid_new2;
reg clka_valid_new3;
reg last_clka_valid;
reg last_clka_valid1;
reg clkb_valid;
reg clkb_valid_new1;
reg clkb_valid_new2;
reg clkb_valid_new3;
reg last_clkb_valid;
reg last_clkb_valid1;
reg memchg0;
reg memchg1;
reg memchga;
reg memchgb;
reg rsta_sig, rsta_node2, rstb_sig, rstb_node2;
reg rsta_nogsr, rsta_nogsr2, rstb_nogsr, rstb_nogsr2;
integer v_waddr_a,v_raddr_a,v_waddr_b,v_raddr_b, v_raddr_rbr_a, v_raddr_rbr_b;
integer addr_a, addr_b, dn_addr_a, up_addr_a, dn_addr_b, up_addr_b;
wire dina_0, dinb_0;

reg wr_a_wr_b_coll, wr_a_rd_b_coll, rd_a_wr_b_coll; 
integer dn_coll_addr, up_coll_addr; 


  buf (dina[0], dia_0);
  buf (dina[1], dia_1);
  buf (dina[2], dia[2]);
  buf (dina[3], dia[3]);
  buf (dina[4], dia[4]);
  buf (dina[5], dia[5]);
  buf (dina[6], dia[6]);
  buf (dina[7], dia[7]);
  buf (dina[8], dia[8]);
  buf (dinb[0], dib_0);
  buf (dinb[1], dib_1);
  buf (dinb[2], dib[2]);
  buf (dinb[3], dib[3]);
  buf (dinb[4], dib[4]);
  buf (dinb[5], dib[5]);
  buf (dinb[6], dib[6]);
  buf (dinb[7], dib[7]);
  buf (dinb[8], dib[8]);
  buf (adabuf[0], addra[0]);
  buf (adabuf[1], addra[1]);
  buf (adabuf[2], addra[2]);
  buf (adabuf[3], addra[3]);
  buf (adabuf[4], addra[4]);
  buf (adabuf[5], addra[5]);
  buf (adabuf[6], addra[6]);
  buf (adabuf[7], addra[7]);
  buf (adabuf[8], addra[8]);
  buf (adabuf[9], addra[9]);
  buf (adabuf[10], addra[10]);
  buf (adabuf[11], addra[11]);
  buf (adabuf[12], addra[12]);
  buf (adbbuf[0],  addrb[0]);
  buf (adbbuf[1],  addrb[1]);
  buf (adbbuf[2],  addrb[2]);
  buf (adbbuf[3],  addrb[3]);
  buf (adbbuf[4],  addrb[4]);
  buf (adbbuf[5],  addrb[5]);
  buf (adbbuf[6],  addrb[6]);
  buf (adbbuf[7],  addrb[7]);
  buf (adbbuf[8],  addrb[8]);
  buf (adbbuf[9],  addrb[9]);
  buf (adbbuf[10], addrb[10]);
  buf (adbbuf[11], addrb[11]);
  buf (adbbuf[12], addrb[12]);

  buf (doa[0], doa_out[0]);
  buf (doa[1], doa_out[1]);
  buf (doa[2], doa_out[2]);
  buf (doa[3], doa_out[3]);
  buf (doa[4], doa_out[4]);
  buf (doa[5], doa_out[5]);
  buf (doa[6], doa_out[6]);
  buf (doa[7], doa_out[7]);
  buf (doa[8], doa_out[8]);
  buf (dob[0], dob_out[0]);
  buf (dob[1], dob_out[1]);
  buf (dob[2], dob_out[2]);
  buf (dob[3], dob_out[3]);
  buf (dob[4], dob_out[4]);
  buf (dob[5], dob_out[5]);
  buf (dob[6], dob_out[6]);
  buf (dob[7], dob_out[7]);
  buf (dob[8], dob_out[8]);




integer ia,ib,ic;
  initial
  begin
  
  	for (ia = 0; ia < 256; ia=ia+1) begin
  	    ib=ia/8;
  	    ic=ia%8;
	    v_mem[ib*9+ic]	    	<= INIT_00[ia];
	    v_mem[288 * 1 +  ib*9+ic]  	<= INIT_01[ia];
	    v_mem[288 * 2 +  ib*9+ic]  	<= INIT_02[ia];
	    v_mem[288 * 3 +  ib*9+ic]  	<= INIT_03[ia];
	    v_mem[288 * 4 +  ib*9+ic]  	<= INIT_04[ia];
	    v_mem[288 * 5 +  ib*9+ic]  	<= INIT_05[ia];
	    v_mem[288 * 6 +  ib*9+ic]  	<= INIT_06[ia];
	    v_mem[288 * 7 +  ib*9+ic]  	<= INIT_07[ia];
	    v_mem[288 * 8 +  ib*9+ic]  	<= INIT_08[ia];
	    v_mem[288 * 9 +  ib*9+ic]  	<= INIT_09[ia];
	    v_mem[288 * 10 + ib*9+ic] 	<= INIT_0A[ia];
	    v_mem[288 * 11 + ib*9+ic] 	<= INIT_0B[ia];
	    v_mem[288 * 12 + ib*9+ic] 	<= INIT_0C[ia];
	    v_mem[288 * 13 + ib*9+ic] 	<= INIT_0D[ia];
	    v_mem[288 * 14 + ib*9+ic] 	<= INIT_0E[ia];
	    v_mem[288 * 15 + ib*9+ic] 	<= INIT_0F[ia];
	    v_mem[288 * 16 + ib*9+ic] 	<= INIT_10[ia];
	    v_mem[288 * 17 + ib*9+ic] 	<= INIT_11[ia];
	    v_mem[288 * 18 + ib*9+ic] 	<= INIT_12[ia];
	    v_mem[288 * 19 + ib*9+ic] 	<= INIT_13[ia];
	    v_mem[288 * 20 + ib*9+ic] 	<= INIT_14[ia];
	    v_mem[288 * 21 + ib*9+ic] 	<= INIT_15[ia];
	    v_mem[288 * 22 + ib*9+ic] 	<= INIT_16[ia];
	    v_mem[288 * 23 + ib*9+ic] 	<= INIT_17[ia];
	    v_mem[288 * 24 + ib*9+ic] 	<= INIT_18[ia];
	    v_mem[288 * 25 + ib*9+ic] 	<= INIT_19[ia];
	    v_mem[288 * 26 + ib*9+ic] 	<= INIT_1A[ia];
	    v_mem[288 * 27 + ib*9+ic] 	<= INIT_1B[ia];
	    v_mem[288 * 28 + ib*9+ic] 	<= INIT_1C[ia];
	    v_mem[288 * 29 + ib*9+ic] 	<= INIT_1D[ia];
	    v_mem[288 * 30 + ib*9+ic] 	<= INIT_1E[ia];
	    v_mem[288 * 31 + ib*9+ic] 	<= INIT_1F[ia];
	    v_mem[(ia+1)*9-1] 	    	<= INITP_00[ia];
	    v_mem[256 * 9 + ia*9+8] 	<= INITP_01[ia];
	    v_mem[512 * 9 + ia*9+8] 	<= INITP_02[ia];
	    v_mem[768 * 9 + ia*9+8] 	<= INITP_03[ia];
	
	end
  
  

  	  	  	  	


  end

  initial
  begin
     rsta_sig = 0;
     rsta_node2 = 0;
     rstb_sig = 0;
     rstb_node2 = 0;
     rsta_nogsr = 0;
     rsta_nogsr2 = 0;
     rstb_nogsr = 0;
     rstb_nogsr2 = 0;
  end

  initial
  begin
     doa_node = 0;
     doa_node_tr = 0;
     doa_node_wt = 0;
     doa_node_rbr = 0;
     dob_node = 0;
     dob_node_tr = 0;
     dob_node_wt = 0;
     dob_node_rbr = 0;
     do_node_tr = 0;
     do_node_wt = 0;
     do_node_rbr = 0;

     dina_reg = 0;
     dinab_reg = 0;
     bwa0_reg_sync = 0;
     bwa0_reg = 0;
     bwa1_reg_sync = 0;
     bwa1_reg = 0;
     addra_reg = 0;
     wrena_reg = 0;
     rena_reg = 0;
     csa_en_reg = 0;
     dinb_reg = 0;
     bwb_reg_sync = 0;
     bwb_reg = 0;
     addrb_reg = 0;
     wrenb_reg = 0;
     renb_reg = 0;
     csb_en_reg = 0;
     
  end

  initial
  begin
     wr_a_wr_b_coll = 1'b0;
     wr_a_rd_b_coll = 1'b0;
     rd_a_wr_b_coll = 1'b0;
     memchg0 = 1'b0;
     memchg1 = 1'b0;
     memchga = 1'b0;
     memchgb = 1'b0;
     clka_valid = 1'b0;
	  clka_valid_new1 = 1'b0;
	  clka_valid_new2 = 1'b0;
	  clka_valid_new3 = 1'b0;
     clkb_valid = 1'b0;
	  clkb_valid_new1 = 1'b0;
	  clkb_valid_new2 = 1'b0;
	  clkb_valid_new3 = 1'b0;
     last_clka_valid = 1'b0;
     last_clka_valid1 = 1'b0;
     last_clkb_valid = 1'b0;
     last_clkb_valid1 = 1'b0;
  end

//always @ (clka_valid, clkb_valid, last_clka_valid1, last_clkb_valid1)
always @ (clka_valid, clkb_valid) //
begin
   last_clka_valid1 <= clka_valid;
   last_clkb_valid1 <= clkb_valid;
   last_clka_valid <= last_clka_valid1;
   last_clkb_valid <= last_clkb_valid1;
end

  assign dia_0 = (DWA_VALUE == 1) ? dia[1] : (DWA_VALUE == 2) ? dia[2] : dia[0];
  assign dia_1 = (DWA_VALUE == 2) ? dia[5] : dia[1];
  assign dib_0 = (DWA_VALUE < 18 & DWB_VALUE == 1) ? dib[1] : (DWA_VALUE < 18 & DWB_VALUE == 2) ? dib[2] : dib[0];
  assign dib_1 = (DWA_VALUE != 18 & DWB_VALUE == 2) ? dib[5] : dib[1];

  always @ (gsrn_sig or done_sig ) begin
    if (GSR == "ENABLE")
      srn = gsrn_sig & done_sig ;
    else if (GSR == "DISABLE")
      srn = done_sig;

    srn_pur = done_sig;
  end

  
wire  csa_en = csa0_node & csa1_node & csa2_node;
wire  csb_en = csb0_node & csb1_node & csb2_node;
  

assign dina_node = (data_width__a == 1) ? dina[0] :
             (data_width__a == 2) ? dina[1:0] :
             (data_width__a == 4) ? dina[3:0] : dina[8:0];
assign dinb_node = (data_width__b == 1) ? dinb[0] :
             (data_width__b == 2) ? dinb[1:0] :
             (data_width__b == 4) ? dinb[3:0] : dinb[8:0];
assign dinb_dob = (data_width__a == 1) ? dinb[0] :
             (data_width__a == 2) ? dinb[1:0] :
             (data_width__a == 4) ? dinb[3:0] : dinb[8:0];

assign dinab_node = {dinb, dina};

assign bwa0_node = adabuf[0];
assign bwa1_node = adabuf[1];
assign bwb_node = adbbuf[0];

   not (sr1, srn);
   or inst1 (rsta_node1, rsta_node, sr1);
   or inst2 (rstb_node1, rstb_node, sr1);

   always @ (rsta_node1 or rsta_node2)
   begin
      if ((ASYNC_RESET_RELEASE == "SYNC") && (RESETMODE == "ASYNC"))
      begin
         rsta_sig <= rsta_node2;
      end
      else
      begin
         rsta_sig <= rsta_node1;
      end
   end

   always @ (posedge clka_node or posedge rsta_node1)
   begin
      if (rsta_node1 == 1'b1)
         rsta_node2 <= 1'b1;
      else
         rsta_node2 <= 1'b0;
   end

   always @ (rstb_node1 or rstb_node2)
   begin
      if ((ASYNC_RESET_RELEASE == "SYNC") && (RESETMODE == "ASYNC"))
      begin
         rstb_sig <= rstb_node2;
      end
      else
      begin
         rstb_sig <= rstb_node1;
      end
   end

   always @ (posedge clkb_node or posedge rstb_node1)
   begin
      if (rstb_node1 == 1'b1)
         rstb_node2 <= 1'b1;
      else
         rstb_node2 <= 1'b0;
   end

   assign rsta_node_sync = (RESETMODE == "SYNC") ? rsta_node : 1'b0;
   assign rstb_node_sync = (RESETMODE == "SYNC") ? rstb_node : 1'b0;

   not (sr_pur, srn_pur);
   or inst3 (rsta_nogsr1, rsta_node_sync, sr_pur);
   or inst4 (rstb_nogsr1, rstb_node_sync, sr_pur);

   always @ (rsta_nogsr1 or rsta_nogsr2)
   begin
      if ((ASYNC_RESET_RELEASE == "SYNC") && (RESETMODE == "ASYNC"))
      begin
         rsta_nogsr <= rsta_nogsr1;
      end
      else
      begin
         rsta_nogsr <= rsta_nogsr1;
      end
   end
                                                                                              
   always @ (posedge clka_node or posedge rsta_nogsr1)
   begin
      if (rsta_nogsr1 == 1'b1)
         rsta_nogsr2 <= 1'b1;
      else
         rsta_nogsr2 <= 1'b0;
   end

   always @ (rstb_nogsr1 or rstb_nogsr2)
   begin
      if ((ASYNC_RESET_RELEASE == "SYNC") && (RESETMODE == "ASYNC"))
      begin
         rstb_nogsr <= rstb_nogsr1;
      end
      else
      begin
         rstb_nogsr <= rstb_nogsr1;
      end
   end
                                                                                              
   always @ (posedge clkb_node or posedge rstb_nogsr1)
   begin
      if (rstb_nogsr1 == 1'b1)
         rstb_nogsr2 <= 1'b1;
      else
         rstb_nogsr2 <= 1'b0;
   end

   always @ (sr_pur or dina_node or adabuf or wrea_node or csa_en) 
   begin
      if (sr_pur == 1)
      begin
         assign dina_reg = 0;
         assign dinab_reg = 0;
         assign bwa0_reg = 0;
         assign bwa1_reg = 0;
         assign addra_reg = 0;
         assign wrena_reg = 0;
         assign rena_reg = 0;
         assign csa_en_reg = 0;
      end
      else
      begin
         deassign dina_reg;
         deassign dinab_reg;
         deassign bwa0_reg;
         deassign bwa1_reg;
         deassign addra_reg;
         deassign wrena_reg;
         deassign rena_reg;
         deassign csa_en_reg;
      end
   end

   always @(posedge clka_node)
   begin
      if (rsta_nogsr == 1)
      begin
         csa_en_reg <= 0;
      end
      else
      begin
         if (cea_node == 1)
         begin
            csa_en_reg <= csa_en;
         end
      end
   end

   always @(posedge clka_node)
   begin
         if (cea_node == 1)
         begin
            dina_reg_sync <= dina_node[data_width__a-1:0];
            dinab_reg_sync <= dinab_node;
            bwa0_reg_sync <= bwa0_node;
            bwa1_reg_sync <= bwa1_node;
            addra_reg_sync <= addra_node;
            wrena_reg_sync <= wrea_node;
            rena_reg_sync <= ~wrea_node;
         end
   end

   always @(dina_reg_sync or dinab_reg_sync or bwa0_reg_sync or bwa1_reg_sync or addra_reg_sync or
            wrena_reg_sync or rena_reg_sync or csa_en_reg)
   begin
         dina_reg <= dina_reg_sync;
         dinab_reg <= dinab_reg_sync;
         bwa0_reg <= bwa0_reg_sync;
         bwa1_reg <= bwa1_reg_sync;
         addra_reg <= addra_reg_sync;
         wrena_reg <= wrena_reg_sync & csa_en_reg;
         rena_reg <= rena_reg_sync & csa_en_reg;
   end

   always @ (sr_pur or dinb_node or adbbuf or wreb_node or csb_en) 
   begin
      if (sr_pur == 1)
      begin
         assign dinb_reg = 0;
         assign bwb_reg = 0;
         assign addrb_reg = 0;
         assign wrenb_reg = 0;
         assign renb_reg = 0;
         assign csb_en_reg = 0;
      end
      else
      begin
         deassign dinb_reg;
         deassign bwb_reg;
         deassign addrb_reg;
         deassign wrenb_reg;
         deassign renb_reg;
         deassign csb_en_reg;
      end
   end

   always @(posedge clkb_node)
   begin
      if (rstb_nogsr == 1)
      begin
         csb_en_reg <= 0;
      end
      else
      begin
         if (ceb_node == 1)
         begin
            csb_en_reg <= csb_en;
         end
      end
   end

   always @(posedge clkb_node)
   begin
         if (ceb_node == 1)
         begin
            dinb_reg_sync <= dinb_node[data_width__b-1:0];
            bwb_reg_sync <= bwb_node;
            addrb_reg_sync <= addrb_node;
            wrenb_reg_sync <= wreb_node;
            renb_reg_sync <= ~wreb_node;
         end
   end

   always @(dinb_reg_sync or bwb_reg_sync or addrb_reg_sync or wrenb_reg_sync or renb_reg_sync or
            csb_en_reg)
   begin
         dinb_reg <= dinb_reg_sync;
         bwb_reg <= bwb_reg_sync;
         addrb_reg <= addrb_reg_sync;
         wrenb_reg <= wrenb_reg_sync & csb_en_reg;
         renb_reg <= renb_reg_sync & csb_en_reg;
   end

   always @(posedge clka_node)
   begin
      if (rsta_sig == 1 && RESETMODE == "SYNC")
         clka_valid_new1 <= 0;
      else
         begin
         if (cea_node == 1)
         begin
            if (csa_en == 1)
            begin
               clka_valid_new1 <= 1;
               #0.2 clka_valid_new1 = 0;
            end
            else
               clka_valid_new1 <= 0;
         end
         else
            clka_valid_new1 <= 0;
      end
   end

   always @(posedge clkb_node)
   begin
      if (rstb_sig == 1 && RESETMODE == "SYNC")
         clkb_valid_new1 <= 0;
      else
      begin
         if (ceb_node == 1)
         begin
            if (csb_en == 1)
            begin
               clkb_valid_new1 <= 1;
               #0.2 clkb_valid_new1 = 0;
            end
            else
               clkb_valid_new1 <= 0;
         end
         else
            clkb_valid_new1 <= 0;
      end
   end

   always @(clka_valid_new1 or clka_valid_new2 or clka_valid_new3)
   begin
      clka_valid_new2 <= clka_valid_new1;
      clka_valid_new3 <= clka_valid_new2;
      clka_valid <= clka_valid_new3;
   end

   always @(clkb_valid_new1 or clkb_valid_new2 or clkb_valid_new3)
   begin
      clkb_valid_new2 <= clkb_valid_new1;
      clkb_valid_new3 <= clkb_valid_new2;
      clkb_valid <= clkb_valid_new3;
   end

//----------------------------

   always @(addra_reg or addrb_reg or wrena_reg or wrenb_reg or clka_valid_new2 or clkb_valid_new2 or
   rena_reg or renb_reg)
   begin
      addr_a = addra_reg;
      addr_b = addrb_reg;


		dn_addr_a = (addr_a * DWA_VALUE) + (addr_a / div_a);
		up_addr_a = dn_addr_a + (DWA_VALUE - 1);
		dn_addr_b = (addr_b * DWB_VALUE) + (addr_b / div_b);
		up_addr_b = dn_addr_b + (DWB_VALUE - 1);

                if (~((up_addr_b < dn_addr_a) || (dn_addr_b > up_addr_a)))
                begin
                   if (wr_a_wr_b_coll == 1'b1)
                   begin
                      if (clka_valid_new2 == 1'b0 && clkb_valid_new2 == 1'b0)
                         wr_a_wr_b_coll = 1'b0;
                   end
                end
                else
                begin
                   wr_a_wr_b_coll = 1'b0;
                end

                if (~((up_addr_b < dn_addr_a) || (dn_addr_b > up_addr_a)))
                begin
                   if (wr_a_rd_b_coll == 1'b1)
                   begin
                      if (clka_valid_new2 == 1'b0 && clkb_valid_new2 == 1'b0)
                         wr_a_rd_b_coll = 1'b0;
                   end
                end
                else
                begin
                   wr_a_rd_b_coll = 1'b0;
                end

                if (~((up_addr_a < dn_addr_b) || (dn_addr_a > up_addr_b)))
                begin
                   if (rd_a_wr_b_coll == 1'b1)
                   begin
                      if (clka_valid_new2 == 1'b0 && clkb_valid_new2 == 1'b0)
                         rd_a_wr_b_coll = 1'b0;
                   end
                end
                else
                begin
                   rd_a_wr_b_coll = 1'b0;
                end

		if (~((up_addr_b < dn_addr_a) || (dn_addr_b > up_addr_a)))
		begin
			if ((dn_addr_a > dn_addr_b) && (up_addr_a < up_addr_b))
			begin
				dn_coll_addr = dn_addr_a;
				up_coll_addr = up_addr_a;
			end
			else if ((dn_addr_b > dn_addr_a) && (up_addr_b < up_addr_a))
			begin
				dn_coll_addr = dn_addr_b;
				up_coll_addr = up_addr_b;
			end
			else if ((up_addr_a - dn_addr_b) <= (up_addr_b - dn_addr_a))
			begin
				dn_coll_addr = dn_addr_b;
				up_coll_addr = up_addr_a;
			end
			else
			begin
				dn_coll_addr = dn_addr_a;
				up_coll_addr = up_addr_b;
			end
		end


      if ((wrena_reg == 1 && clka_valid_new2 == 1) && (wrenb_reg == 1 && clkb_valid_new2 == 1))
      begin
         if (~((up_addr_b < dn_addr_a) || (dn_addr_b > up_addr_a)))
         begin
				wr_a_wr_b_coll = 1;
         end
      end

      if ((wrena_reg == 1 && clka_valid_new2 == 1) && (renb_reg == 1 && clkb_valid_new2 == 1))
      begin
         if (~((up_addr_b < dn_addr_a) || (dn_addr_b > up_addr_a)))
         begin
				wr_a_rd_b_coll = 1;
         end
      end

      if ((rena_reg == 1 && clka_valid_new2 == 1) && (wrenb_reg == 1 && clkb_valid_new2 == 1))
      begin
         if (~((up_addr_a < dn_addr_b) || (dn_addr_a > up_addr_b)))
         begin
				rd_a_wr_b_coll = 1;
         end
      end

   end

//----------------------------

   always @(posedge clka_valid or posedge clkb_valid)
   begin
      v_waddr_a = addra_reg;
      v_waddr_b = addrb_reg;
      memchg0 <= ~memchg0;
 
      if (DWA_VALUE == 18)
      begin
         if (wrena_reg == 1 && clka_valid == 1)
         begin
            for (i = 0; i < DWA_VALUE; i = i+1)
            begin
                 do_node_rbr[i] = v_mem[v_waddr_a * DWA_VALUE + i];
            end
            doa_node_rbr = do_node_rbr[8:0];
            dob_node_rbr = do_node_rbr[17:9];

            if (bwa0_reg == 1'b1)
            for (i = 0; i < 9; i = i+1)
                 begin
                      v_mem[v_waddr_a * DWA_VALUE + i] = dinab_reg[i];
                 end
            if (bwa1_reg == 1'b1)
               for (i = 0; i < 9; i = i+1)
               begin
                    v_mem[v_waddr_a * DWA_VALUE + i + 9] = dinab_reg[i + 9];
               end
            memchga <= ~memchga;
         end
      end
      else
      begin
         if (DWA_VALUE == 9)
         begin
            if (bwa0_reg == 1'b1 && wrena_reg == 1 && clka_valid == 1)
            begin
               for (i = 0; i < DWA_VALUE; i = i+1)
               begin
                  doa_node_rbr[i] = v_mem[(v_waddr_a * DWA_VALUE) + (v_waddr_a / div_a) + i];
               end

               for (i = 0; i < data_width__a; i = i+1)
                 begin
                      v_mem[(v_waddr_a * data_width__a) + i] = dina_reg[i];
							 if ( (wr_a_wr_b_coll == 1) &&
							      (((v_waddr_a * data_width__a) + i) >= dn_coll_addr) &&
							      (((v_waddr_a * data_width__a) + i) <= up_coll_addr) &&
									( (DWB_VALUE < 9) ||
									  ( (DWB_VALUE == 9) &&
									    ( ((bwb_reg == 1'b1) && (((v_waddr_a * DWA_VALUE) % 9) == 0))
                         ) ) ) ) 
							    v_mem[(v_waddr_a * data_width__a) + i] = 1'bx;
                 end
               memchga <= ~memchga;
            end
         end
         else
         begin
            if (wrena_reg == 1 && clka_valid == 1)
            begin
               for (i = 0; i < DWA_VALUE; i = i+1)
               begin
                  doa_node_rbr[i] = v_mem[(v_waddr_a * DWA_VALUE) + (v_waddr_a / div_a) + i];
               end
               for (i = 0; i < data_width__a; i = i+1)
                 begin
                      v_mem[(v_waddr_a * data_width__a) + (v_waddr_a / div_a) + i] = dina_reg[i];
							 if ( (wr_a_wr_b_coll == 1) &&
							      (((v_waddr_a * data_width__a) + (v_waddr_a / div_a) + i) >= dn_coll_addr) &&
							      (((v_waddr_a * data_width__a) + (v_waddr_a / div_a) + i) <= up_coll_addr) &&
									( (DWB_VALUE < 9) ||
									  ( (DWB_VALUE == 9) &&
									    ( ((bwb_reg == 1'b1) && ((((v_waddr_a * DWA_VALUE) + (v_waddr_a / div_a)) % 9) == 0)) 
										 ) ) ) )
							    v_mem[(v_waddr_a * data_width__a) + (v_waddr_a / div_a) + i] = 1'bx;
                 end
               memchga <= ~memchga;
            end
         end

         if (DWB_VALUE == 9)
         begin
            if (bwb_reg == 1'b1 && wrenb_reg == 1 && clkb_valid == 1)
            begin
               for (i = 0; i < DWB_VALUE; i = i+1)
               begin
                  dob_node_rbr[i] = v_mem[(v_waddr_b * DWB_VALUE) + (v_waddr_b / div_b) + i];
               end

               for (i = 0; i < data_width__b; i = i+1)
                 begin
                      v_mem[(v_waddr_b * data_width__b) + i] = dinb_reg[i];
							 if ( (wr_a_wr_b_coll == 1) &&
							      (((v_waddr_b * data_width__b) + i) >= dn_coll_addr) &&
							      (((v_waddr_b * data_width__b) + i) <= up_coll_addr) &&
									( (DWA_VALUE < 9) ||
									  ( (DWA_VALUE == 9) &&
									    ( ((bwa0_reg == 1'b1) && (((v_waddr_b * DWB_VALUE) % 9) == 0)) 
                          ))))
							    v_mem[(v_waddr_b * data_width__b) + i] = 1'bx;
                 end
               memchgb <= ~memchgb;
            end
         end
         else
         begin
            if (wrenb_reg == 1 && clkb_valid == 1)
            begin
               for (i = 0; i < DWB_VALUE; i = i+1)
               begin
                  dob_node_rbr[i] = v_mem[(v_waddr_b * DWB_VALUE) + (v_waddr_b / div_b) + i];
               end

               for (i = 0; i < data_width__b; i = i+1)
               begin
                    v_mem[(v_waddr_b * data_width__b) + (v_waddr_b / div_b) + i] = dinb_reg[i];
						  if ( (wr_a_wr_b_coll == 1) &&
							    (((v_waddr_b * data_width__b) + (v_waddr_b / div_b) + i) >= dn_coll_addr) &&
							    (((v_waddr_b * data_width__b) + (v_waddr_b / div_b) + i) <= up_coll_addr) &&
								 ( (DWA_VALUE < 9) ||
									( (DWA_VALUE == 9) &&
									  ( ((bwa0_reg == 1'b1) && ((((v_waddr_b * DWB_VALUE) + (v_waddr_b / div_b)) % 9) == 0)) 
									  ) ) ) )
							    v_mem[(v_waddr_b * data_width__b) + (v_waddr_b / div_b) + i] = 1'bx;
               end
               memchgb <= ~memchgb;
            end
         end
      end
   end

// read operation
   always @(rena_reg or renb_reg or addra_reg or addrb_reg or memchg0 or clka_valid or clkb_valid or 
   posedge rsta_sig or posedge rstb_sig or
	wr_a_rd_b_coll or rd_a_wr_b_coll) 
   begin
      v_raddr_a = addra_reg;
      v_raddr_b = addrb_reg;

      if (DWB_VALUE == 18)
      begin
         if (rstb_sig == 1'b1)
         begin
            if (RESETMODE == "SYNC")
            begin
               if (clkb_node ==  1'b1)
               begin
                  doa_node <= 0;
                  dob_node <= 0;
               end
            end
            else
            begin
               doa_node <= 0;
               dob_node <= 0;
            end
         end
         else if (clkb_valid === 1'b1 && last_clkb_valid === 1'b0)
         begin
            if (renb_reg == 1)
            begin

               for (i = 0; i < DWB_VALUE; i = i+1)
               begin
                    do_node_tr[i] = v_mem[v_raddr_b * DWB_VALUE + i];
						  if ( (wr_a_rd_b_coll == 1) &&
							    ((v_raddr_b * DWB_VALUE + i) >= dn_coll_addr) &&
							    ((v_raddr_b * DWB_VALUE + i) <= up_coll_addr) &&
								 ( (DWA_VALUE < 9) ||
									( (DWA_VALUE == 9) &&
									  ( ((bwa0_reg == 1'b1) && (((v_raddr_b * DWB_VALUE) + i) % 9) < 9))) ||
									( (DWA_VALUE == 18) &&
									  ( ((bwa0_reg == 1'b1) && ((((v_raddr_b * DWB_VALUE) + i) % 18) < 9)) ||
									    ((bwa1_reg == 1'b1) && ((((v_raddr_b * DWB_VALUE) + i) % 18) >= 9))
								 ))) )
							  do_node_tr[i] = 1'bx;
               end
               dob_node <= do_node_tr[17:9];
               doa_node <= do_node_tr[8:0];
            end
            else if (renb_reg == 0)
            begin
               if (WRITEMODE_B == "WRITETHROUGH")
               begin
                  for (i = 0; i < DWB_VALUE; i = i+1)
                  begin
                     do_node_wt[i] = v_mem[v_raddr_b * DWB_VALUE + i];
                  end
                  dob_node <= do_node_wt[17:9];
                  doa_node <= do_node_wt[8:0];
               end
               else if (WRITEMODE_B == "READBEFOREWRITE")
               begin
                  dob_node <= do_node_rbr[17:9];
                  doa_node <= do_node_rbr[8:0];
               end
            end
         end
      end
      else
      begin
         if (rsta_sig == 1'b1)
         begin
            if (RESETMODE == "SYNC")
            begin
               if (clka_node ==  1'b1)
               begin
                  doa_node <= 0;
               end
            end
            else
            begin
               doa_node <= 0;
            end
         end
         else if (clka_valid == 1'b1)
         begin
            if (rena_reg == 1)
            begin
               if (last_clka_valid == 1'b0)
               begin
                  for (i = 0; i < DWA_VALUE; i = i+1)
                  begin
 
						if ( (rd_a_wr_b_coll == 1) &&
							  (((v_raddr_a * DWA_VALUE) + (v_raddr_a / div_a) + i) >= dn_coll_addr) &&
							  (((v_raddr_a * DWA_VALUE) + (v_raddr_a / div_a) + i) <= up_coll_addr) &&
							  ( (DWB_VALUE < 9) ||
								 ( (DWB_VALUE == 9) &&
									( ((bwb_reg == 1'b1) && ((((v_raddr_a * DWA_VALUE) + (v_raddr_a / div_a) + i) % 9) == 0)) 
									) ) ) )
							doa_node[i] <= 1'bx;
						else
							doa_node[i] <= v_mem[(v_raddr_a * DWA_VALUE) + (v_raddr_a / div_a) + i];
                  end
               end
            end
            else if (rena_reg == 0)
            begin
               if (WRITEMODE_A == "WRITETHROUGH")
               begin
                  if (DWA_VALUE <= 9)
                  begin
                     for (i = 0; i < DWA_VALUE; i = i+1)
                     begin
                        doa_node[i] <= v_mem[(v_raddr_a * DWA_VALUE) + (v_raddr_a / div_a) + i];
                     end
                  end
               end
               else if (WRITEMODE_A == "READBEFOREWRITE")
               begin
                  if (last_clka_valid == 1'b0)
                  begin
                     doa_node <= doa_node_rbr;
                  end
               end
            end
         end

         if (rstb_sig == 1'b1)
         begin
            if (RESETMODE == "SYNC")
            begin
               if (clkb_node ==  1'b1)
               begin
                  dob_node <= 0;
               end
            end
            else
            begin
               dob_node <= 0;
            end
         end
         else if (clkb_valid == 1'b1)
         begin
            if (renb_reg == 1)
            begin
               if (last_clkb_valid == 1'b0)
               begin
                  for (i = 0; i < DWB_VALUE; i = i+1)
                  begin
 
						if ( (wr_a_rd_b_coll == 1) &&
							  (((v_raddr_b * DWB_VALUE) + (v_raddr_b / div_b) + i) >= dn_coll_addr) &&
							  (((v_raddr_b * DWB_VALUE) + (v_raddr_b / div_b) + i) <= up_coll_addr) &&
							  ( (DWA_VALUE < 9) ||
								 ( (DWA_VALUE == 9) &&
									( ((bwa0_reg == 1'b1) && ((((v_raddr_b * DWB_VALUE) + (v_raddr_b / div_b) + i) % 9) < 9)) 
									) ) ||
								 ( (DWA_VALUE == 18) &&
									( ((bwa0_reg == 1'b1) && ((((v_raddr_b * DWB_VALUE) + (v_raddr_b / div_b) + i) % 18) < 9)) ||
									  ((bwa0_reg == 1'b1) && ((((v_raddr_b * DWB_VALUE) + (v_raddr_b / div_b) + i) % 18) >= 9))
									) ) ) )
							dob_node[i] <= 1'bx;
						else
							dob_node[i] <= v_mem[(v_raddr_b * DWB_VALUE) + (v_raddr_b / div_b) + i];
                  end
               end
            end
            else if (renb_reg == 0)
            begin
               if (WRITEMODE_B == "WRITETHROUGH")
               begin
                  if (DWB_VALUE <= 9)
                  begin
                     for (i = 0; i < DWB_VALUE; i = i+1)
                     begin
                        dob_node[i] <= v_mem[(v_raddr_b * DWB_VALUE) + (v_raddr_b / div_b) + i];
                     end
                  end
               end
               else if (WRITEMODE_B == "READBEFOREWRITE")
               begin
                  if (last_clkb_valid == 1'b0)
                  begin
                     dob_node <= dob_node_rbr;
                  end
               end
            end
         end
      end
   end

   always @ (sr1 or dob_node or doa_node)
   begin
      if (sr1 == 1)
      begin
         assign doa_reg = 0;
         assign doab_reg = 0;
         assign dob_reg = 0;
      end
      else
      begin
         deassign doa_reg;
         deassign doab_reg;
         deassign dob_reg;
      end
   end

   always @(posedge rsta_sig or posedge clka_node)
   begin
      if (rsta_sig == 1)
         doa_reg_async <= 0;
      else
      begin
         if (ocea_node == 1)
            doa_reg_async <= doa_node;
      end
   end

   always @(posedge clka_node)
   begin
      if (ocea_node == 1)
      begin
         if (rsta_sig == 1)
            doa_reg_sync <= 0;
         else
            doa_reg_sync <= doa_node;
      end
   end

   always @(posedge rstb_sig or posedge clkb_node)
   begin
      if (rstb_sig == 1)
      begin
         dob_reg_async <= 0;
         doab_reg_async <= 0;
      end
      else
      begin
         if (oceb_node == 1)
         begin
            dob_reg_async <= dob_node;
            doab_reg_async <= doa_node;
         end
      end
   end

   always @(posedge clkb_node)
   begin
      if (oceb_node == 1)
      begin
         if (rstb_sig == 1)
         begin
            dob_reg_sync <= 0;
            doab_reg_sync <= 0;
         end
         else
         begin
            dob_reg_sync <= dob_node;
            doab_reg_sync <= doa_node;
         end
      end
   end

   always @(doa_reg_sync or doa_reg_async or dob_reg_sync or dob_reg_async or doab_reg_sync or doab_reg_async)
   begin
      if (RESETMODE == "ASYNC")
      begin
         dob_reg <= dob_reg_async;
         doa_reg <= doa_reg_async;
         doab_reg <= doab_reg_async;
      end
      else
      begin
         dob_reg <= dob_reg_sync;
         doa_reg <= doa_reg_sync;
         doab_reg <= doab_reg_sync;
      end
   end

   always @(doa_reg or dob_reg or doab_reg or doa_node or dob_node)
   begin
      if (REGMODE_A == "OUTREG") 
      begin
         if (DWB_VALUE == 18)
            doa_out <= doab_reg;
         else
            doa_out <= doa_reg;
      end
      else
      begin
         doa_out <= doa_node;
      end

      if (REGMODE_B == "OUTREG") 
         dob_out <= dob_reg;
      else
         dob_out <= dob_node;
   end

endmodule

