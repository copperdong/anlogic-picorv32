///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Synthesis Library Component
//            fifo 
//   Filename : al_syn_fifo.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//    03/28/14 - update
///////////////////////////////////////////////////////////////////////////////
module AL_SYN_FIFO (
		rst, 
            // write port
            dia,dib, csw, we, clkw, 
            // read port
            dob,doa, csr, re, clkr, rprst, orea,oreb,
            // output flag
            empty_flag, aempty_flag, afull_flag, full_flag);



input    [8:0] dia,dib;
input    [2:0] csr;
input    [2:0] csw;
input    we, re, clkw, clkr, rst, rprst,orea,oreb;
output   [8:0] dob,doa;
output   empty_flag, aempty_flag, afull_flag, full_flag;

   parameter  MODE = "FIFO8K";
   parameter  DATA_WIDTH_W = "18"; // 1,2,4,9,18
   parameter  DATA_WIDTH_R = "18"; // 1,2,4,9,18
   parameter  REGMODE   = "NOREG"; //NOREG, OUTREG
   parameter  AE_POINTER   = "0b00000001110000";  
   parameter  AF_POINTER   = "0b01111110000000";
   parameter  FULL_POINTER = "0b01111111110000";
   parameter  GSR = "ENABLE";  //DISABLE, ENABLE
   parameter  RESETMODE = "ASYNC"; //SYNC, ASYNC
   parameter  ASYNC_RESET_RELEASE = "SYNC";  //SYNC, ASYNC
   
// INPUT INV MUX PARAMETER : "0","1","INV","SIG"
   parameter WE    = "SIG";    
   parameter RE    = "SIG";    
   parameter OREA  = "SIG";  
   parameter OREB  = "SIG";  
   parameter RST   = "SIG";  
   parameter RPRST = "SIG";
   parameter CLKW  = "SIG"; 
   parameter CLKR  = "SIG"; 
   parameter CSW0  = "SIG"; 
   parameter CSW1  = "SIG"; 
   parameter CSW2  = "SIG"; 
   parameter CSR0  = "SIG"; 
   parameter CSR1  = "SIG"; 
   parameter CSR2  = "SIG"; 
	   
function [14:1] str2bin_14 (input [(14+2)*8-1:0] binstr);
   integer i, j;
   reg [1:8] ch;
   begin
      for (i=14; i>=1; i=i-1)
      begin
      for (j=1; j<=8; j=j+1)
         ch[j] = binstr[i*8-j];
      case (ch)
         "0" : str2bin_14[i] = 1'b0;
         "1" : str2bin_14[i] = 1'b1;
         default: str2bin_14[i] = 1'bx;
      endcase
      end
    end
  endfunction

localparam [13:0] AE = str2bin_14(AE_POINTER);
localparam [13:0] AF = str2bin_14(AF_POINTER);
localparam [13:0] F = str2bin_14(FULL_POINTER);


   localparam [13:0] AEP1 = 	(DATA_WIDTH_R == "1") ?  (AE + 5'b00001): 
   			(DATA_WIDTH_R == "2") ?  (AE + 5'b00010):
   			(DATA_WIDTH_R == "4") ?  (AE + 5'b00100):
   			(DATA_WIDTH_R == "9") ?  (AE + 5'b01000):
   			(DATA_WIDTH_R == "18") ? (AE + 5'b10000): 14'b0;
			
   localparam [13:0] AFM1 = 	(DATA_WIDTH_W == "1") ?  (AF - 5'b00001): 
   			(DATA_WIDTH_W == "2") ?  (AF - 5'b00010):
   			(DATA_WIDTH_W == "4") ?  (AF - 5'b00100):
   			(DATA_WIDTH_W == "9") ?  (AF - 5'b01000):
   			(DATA_WIDTH_W == "18") ? (AF - 5'b10000): 14'b0;
      			
   localparam [13:0] FM1 = 	(DATA_WIDTH_W == "1") ?  (F - 5'b00001): 
   			(DATA_WIDTH_W == "2") ?  (F - 5'b00010):
   			(DATA_WIDTH_W == "4") ?  (F - 5'b00100):
   			(DATA_WIDTH_W == "9") ?  (F - 5'b01000):
   			(DATA_WIDTH_W == "18") ? (F - 5'b10000): 14'b0;   
   localparam [4:0] E = 5'b00000;   			
   localparam [5:0] EP1 = (DATA_WIDTH_R == "1") ?  (E + 5'b00001): 
   			(DATA_WIDTH_R == "2") ?  (E + 5'b00010):
   			(DATA_WIDTH_R == "4") ?  (E + 5'b00100):
   			(DATA_WIDTH_R == "9") ?  (E + 5'b01000):
   			(DATA_WIDTH_R == "18") ? (E + 5'b10000): 6'b0;    





      
   AL_PHY_FIFO #(
   	.MODE("FIFO8K"),
   	.GSR(GSR),
   	.RESETMODE(RESETMODE),  
        .ASYNC_RESET_RELEASE(ASYNC_RESET_RELEASE), 
        .REGMODE_A(REGMODE),
        .REGMODE_B(REGMODE),
        .DATA_WIDTH_A(DATA_WIDTH_W),
        .DATA_WIDTH_B(DATA_WIDTH_R),
        .AE(AE),
        .AEP1(AEP1),
        .AF(AF),
        .AFM1(AFM1),
        .F(F),
        .FM1(FM1),
        .E(E),
        .EP1(EP1),
        .CEA(WE),
	.CEB(RE),
	.OCEA(OREA),
	.OCEB(OREB),
	.RSTA(RST),
	.RSTB(RPRST),
	.CLKA(CLKW),
	.CLKB(CLKR),
	.WEA ("SIG"),
	.WEB ("SIG"),
	.CSA0(CSW0),
	.CSA1(CSW1),
	.CSA2(CSW2),
	.CSB0(CSR0),
	.CSB1(CSR1),
	.CSB2(CSR2) 
        ) 

        AL_PHY_FIFO_phymap(
        	.rst(rst), 
            // write port
            .dia(dia),
            .dib(dib), 
            .csw(csw), 
            .we(we), 
            .clkw(clkw), 
            // read port
            .dob(dob),
            .doa(doa), 
            .csr(csr), 
            .re(re), 
            .clkr(clkr), 
            .rprst(rprst), 
            .orea(orea), 
            .oreb(oreb),
            // output flag
            .empty_flag(empty_flag), 
            .aempty_flag(aempty_flag), 
            .afull_flag(afull_flag), 
            .full_flag(full_flag)               
        );

endmodule
