///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            lslice
//   Filename : al_phy_lslice.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//  
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//    04/08/14 - add distribute ram support
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module AL_PHY_LSLICE
  (
  a,
  b,
  c,
  ce,
  clk,
  d,
  e,
  mi,
  sr,
  fci,
  f,
  fx,
  q,
  fco,
  dpram_mode,
  dpram_di,
  dpram_we,
  dpram_waddr,
  dpram_wclk    
  );
  input [1:0] a,b,c,d,e,mi;
  input clk;
  input ce;
  input sr;
  input fci;
  output [1:0] f,fx,q;
  output fco;    

  output [3:0] dpram_di;
  output [3:0] dpram_waddr;
  output dpram_wclk;
  output dpram_we;
  output dpram_mode;

    
tri1 [1:0] a,b,c,d,e,mi;
tri1 clk;
tri1 ce;
tri1 sr;
tri0 fci;  
parameter INIT_LUTF0 = 16'h0000 ;
parameter INIT_LUTG0 = 16'h0000 ;
parameter INIT_LUTF1 = 16'h0000 ;
parameter INIT_LUTG1 = 16'h0000 ;
parameter MODE = "LOGIC" ;
//parameter MSFXMUX = "OFF" ;  //
parameter GSR = "DISABLE" ;
parameter TESTMODE = "OFF";   //;
parameter CEMUX = "1" ;
parameter SRMUX = "SR" ; //
parameter CLKMUX = "CLK" ;
parameter SRMODE = "ASYNC" ;
parameter DFFMODE = "FF" ;
parameter REG0_SD = "MI" ;
parameter REG1_SD = "MI" ;
parameter REG0_REGSET = "SET" ;
parameter REG1_REGSET = "SET" ;

parameter DEMUX0 = "D" ;
parameter DEMUX1 = "D" ;
parameter CMIMUX0 = "C" ;
parameter CMIMUX1 = "C" ;
parameter LSFMUX0 = "LUTF";
parameter LSFXMUX0 = "LUTG";
parameter LSFMUX1 = "LUTF";
parameter LSFXMUX1 = "LUTG";

wire gsrn = glbl.gsrn;
wire done_gwe = glbl.done_gwe;

reg mc1_rp0, mc1_rp1, mc1_testsh, latchmode ;
reg mc1_syncmode, mc1_disgsr ;
reg [1:0]mc1_di,mc1_fx ,mc1_sr;
reg mc1_f0muxlut5,mc1_f1muxlut5;
reg mc1_fx0muxlut4g,mc1_fx1muxlut4g;
reg mc1_fx0muxrip_n,mc1_fx1muxrip_n;
reg [1:0]mc1_desel;
reg [1:0]mc1_cmisel;
reg dpram_mode ;

// distribute ram interface
and (dpram_di[0] ,a[1], dpram_mode);
and (dpram_di[1] ,b[1], dpram_mode);
and (dpram_di[2] ,c[1], dpram_mode);
and (dpram_di[3] ,d[1], dpram_mode);
and (dpram_waddr[0] ,a[0], dpram_mode);
and (dpram_waddr[1] ,b[0], dpram_mode);
and (dpram_waddr[2] ,c[0], dpram_mode);
and (dpram_waddr[3] ,d[0], dpram_mode);
and (dpram_we,e[0],dpram_mode,done_gwe);
and (dpram_wclk,clk,dpram_mode);
// distribute ram end
 
initial begin

//LSFXMUX0: LUTG, FUNC6, SUM
//LSFXMUX1: LUTG, FUNC7, SUM
//LSFMUX0: LUTF, FUNC5, SUM
//LSFMUX1: LUTF, FUNC5, SUM


	case (LSFMUX0)
		"LUTF"    : begin 
				mc1_rp0 = 0 ;
				mc1_f0muxlut5 = 0 ;
				end
		"FUNC5"   : begin 
				mc1_rp0 = 0 ;
				mc1_f0muxlut5 = 1 ;
				end
		"SUM"	   : begin 
				mc1_rp0 = 1 ;
				mc1_f0muxlut5 = 0 ;
				end		
   		default    : begin 
				mc1_rp0 = 0 ;
				mc1_f0muxlut5 = 0 ;
				end
   	endcase
	case (LSFXMUX0)
		"LUTG"    : begin 
				mc1_fx0muxlut4g = 0 ;
				mc1_fx0muxrip_n = 1 ;
				end
		"FUNC6"   : begin 
				mc1_fx0muxlut4g = 1 ;
				mc1_fx0muxrip_n = 1 ;
				end
		"SUM"	   : begin 
				mc1_fx0muxlut4g = 1 ;
				mc1_fx0muxrip_n = 0 ;
				end		
   		default : begin 
				mc1_fx0muxlut4g = 0 ;
				mc1_fx0muxrip_n = 0 ;
				end
   	endcase
   	
	case (LSFMUX1)
		"LUTF"    : begin 
				mc1_rp1 = 0 ;
				mc1_f1muxlut5 = 0 ;
				end
		"FUNC5"   : begin 
				mc1_rp1 = 0 ;
				mc1_f1muxlut5 = 1 ;
				end
		"SUM"	   : begin 
				mc1_rp1 = 1 ;
				mc1_f1muxlut5 = 0 ;
				end		
   		default    : begin 
				mc1_rp1 = 0 ;
				mc1_f1muxlut5 = 0 ;
				end
   	endcase
	case (LSFXMUX1)
		"LUTG"    : begin 
				mc1_fx1muxlut4g = 0 ;
				mc1_fx1muxrip_n = 1 ;
				end
		"FUNC7"   : begin 
				mc1_fx1muxlut4g = 1 ;
				mc1_fx1muxrip_n = 1 ;
				end
		"SUM"	   : begin 
				mc1_fx1muxlut4g = 1 ;
				mc1_fx1muxrip_n = 0 ;
				end		
   		default : begin 
				mc1_fx1muxlut4g = 0 ;
				mc1_fx1muxrip_n = 0 ;
				end
   	endcase   	
   	
   	
	case (DEMUX0)
		"D"    : mc1_desel[0] = 0 ;
		"E"    : mc1_desel[0] = 1 ;		
   		default : mc1_desel[0] = 0 ;
   	endcase

	case (DEMUX1)
		"D"    : mc1_desel[1] = 0 ;
		"E"    : mc1_desel[1] = 1 ;		
   		default : mc1_desel[1] = 0 ;
   	endcase
   	   	
	case (CMIMUX0)
		"C"    : mc1_cmisel[0] = 0 ;
		"MI"   : mc1_cmisel[0] = 1 ;		
   		default : mc1_cmisel[0] = 0 ;
   	endcase   	
   	
	case (CMIMUX1)
		"C"    : mc1_cmisel[1] = 0 ;
		"MI"   : mc1_cmisel[1] = 1 ;		
   		default : mc1_cmisel[1] = 0 ;
   	endcase   
   	
	case (MODE)
   		"LOGIC"  : begin 
   				mc1_rp0 = 0;
   				mc1_rp1 = 0;
   				dpram_mode = 1'b0;
   			    end	
   		"ADDER"  : begin 
   				mc1_rp0 = 1;
   				mc1_rp1 = 1;
   				dpram_mode = 1'b0;
   			    end	
   		"RAMW"	 : begin 
   				mc1_rp0 = 0;
   				mc1_rp1 = 0;
   				dpram_mode = 1'b1;
   			    end	   
   		default  : begin 
   				mc1_rp0 = 0;
   				mc1_rp1 = 0;
   				dpram_mode = 1'b0;
   			    end
   	endcase

// SLICE DFF CONFIG
	case (REG0_SD)
   		"MI"  :    begin 
   				mc1_di[0] = 0;
   				mc1_fx[0] = 0;
   			    end	
   		"F"  :     begin 
   				mc1_di[0] = 1;
   				mc1_fx[0] = 0;
   			    end
   		"FX"  :    begin 
   				mc1_di[0] = 0;
   				mc1_fx[0] = 1;
   			    end   			    	 
   		default :   begin 
   				mc1_di[0] = 0;
   				mc1_fx[0] = 0;
   			    end
   	endcase 
 
	case (REG1_SD)
   		"MI"  :    begin 
   				mc1_di[1] = 0;
   				mc1_fx[1] = 0;
   			    end	
   		"F"  :     begin 
   				mc1_di[1] = 1;
   				mc1_fx[1] = 0;
   			    end
   		"FX"  :    begin 
   				mc1_di[1] = 0;
   				mc1_fx[1] = 1;
   			    end   			    	 
   		default :   begin 
   				mc1_di[1] = 0;
   				mc1_fx[1] = 0;
   			    end
   	endcase 

   	case (TESTMODE)
   		"OFF"  : mc1_testsh = 0;
   		"ON"   : mc1_testsh = 1;
   		default : mc1_testsh = 0;
   	endcase	 

	case (DFFMODE)
   		"FF"      : latchmode = 0;
   		"LATCH"   : latchmode = 1;
   		default : latchmode = 0;
   	endcase	 
	
	case (REG0_REGSET)
   		"RESET"   : mc1_sr[0] = 1;
   		"SET"     : mc1_sr[0] = 0;
   		default : mc1_sr[0] = 0;
   	endcase	

	case (REG1_REGSET)
   		"RESET"   : mc1_sr[1] = 1;
   		"SET"     : mc1_sr[1] = 0;
   		default : mc1_sr[1] = 0;
   	endcase	

	case (SRMODE)
   		"ASYNC"   : mc1_syncmode = 0;
   		"SYNC"    : mc1_syncmode = 1;
   		default : mc1_syncmode = 0;
   	endcase

	case (GSR)
   		"DISABLE"   : mc1_disgsr = 1;
   		"ENABLE"    : mc1_disgsr = 0;
   		default : mc1_disgsr = 0;
   	endcase
   	   		
end // initial




   	
reg ce_in, sr_in,clk_in ;   	
	 
	// CEMUX/SRMUX/CLKMUX
	always @(ce or CEMUX)
  		begin
    		case(CEMUX)
  			"CE"  : ce_in = ce ;
  			"INV" : ce_in = ~ce ;
  			"1"   : ce_in = 1'b1;
  			"0"   : ce_in = 1'b0;
  			default: ce_in = 1'b1;    	
		endcase
		end
	always @(sr or SRMUX)
  		begin
    		case(SRMUX)
  			"SR"  : sr_in = sr ;
  			"INV" : sr_in = ~sr ;
  			"1"   : sr_in = 1'b1;
  			"0"   : sr_in = 1'b0;
  			default: sr_in = sr;   	
		endcase
		end

	always @(clk or CLKMUX)
  		begin
    		case(CLKMUX)
  			"CLK"  	: clk_in = clk ;
  			"INV" 		: clk_in = ~clk ;
  			"1"   : clk_in = 1'b1;
  			"0"   : clk_in = 1'b0;
  			default: clk_in = clk;    	
		endcase
		end
		
wire [1:0] in3,in4;
assign in3[0] = mc1_cmisel[0]? mi[0] : c[0] ;
assign in3[1] = mc1_cmisel[1]? mi[1] : c[1] ;
assign in4[0] = mc1_desel[0]? e[0] : d[0] ; //
assign in4[1] = mc1_desel[1]? e[1] : d[1] ; //
wire [1:0] lut4f,lut4g,lut4f_n,lut4g_n;
wire [3:0] sum;
wire [1:0] f_n = ~f[1:0];
assign lut4f_n = ~lut4f ;
assign lut4g_n = ~lut4g ;
pfb_slice23_lut4 #(INIT_LUTF0) lut4f_0(.lut4_o(lut4f[0]) , .gen(genf_0) , .mc1_ripmode(mc1_rp0), .I0(a[0]), .I1(b[0]), .I2(in3[0]), .I3(d[0])); 
pfb_slice23_lut4 #(INIT_LUTG0) lut4g_0(.lut4_o(lut4g[0]) , .gen(geng_0) , .mc1_ripmode(mc1_rp0), .I0(a[0]), .I1(b[0]), .I2(c[0]), .I3(in4[0]));

pfb_slice23_lut4 #(INIT_LUTF1) lut4f_1(.lut4_o(lut4f[1]) , .gen(genf_1) , .mc1_ripmode(mc1_rp1), .I0(a[1]), .I1(b[1]), .I2(in3[1]), .I3(d[1])); 
pfb_slice23_lut4 #(INIT_LUTG1) lut4g_1(.lut4_o(lut4g[1]) , .gen(geng_1) , .mc1_ripmode(mc1_rp1), .I0(a[1]), .I1(b[1]), .I2(c[1]), .I3(in4[1]));

wire other_f6 = 1'b0; // from another lslice func6 output
wire func6 = mi[0]? f[1]:f[0];
wire func7 = mi[1]? other_f6 : func6 ;

pfb_lsliceomux lsliceomux0( .f(f[0]),.fx(fx[0]),.f_n(f_n[0]), .sum0(sum[0]), .sum1(sum[1]), .lut4f(lut4f[0]), .lut4g(lut4g[0]), .func6(func6),
		 .mc1_fxmuxlut4g(mc1_fx0muxlut4g), .mc1_fxmuxrip_n(mc1_fx0muxrip_n), .mc1_fmuxrip(mc1_rp0), .mc1_fmuxlut5(mc1_f0muxlut5), .in5(e[0]));
pfb_lsliceomux lsliceomux1( .f(f[1]),.fx(fx[1]),.f_n(f_n[1]), .sum0(sum[2]), .sum1(sum[3]), .lut4f(lut4f[1]), .lut4g(lut4g[1]), .func6(func7),
		 .mc1_fxmuxlut4g(mc1_fx1muxlut4g), .mc1_fxmuxrip_n(mc1_fx1muxrip_n), .mc1_fmuxrip(mc1_rp1), .mc1_fmuxlut5(mc1_f1muxlut5), .in5(e[1]));


pfb_carrysum_s2 carrychain0( .fco_n(fco1_n), .sum1(sum[1]) , .sum0(sum[0]), .f1_b(lut4g_n[0]), .gen1(geng_0), .f0_b(lut4f_n[0]), .gen0(genf_0), .ci0(fci), .mc1_ripmode(mc1_rp0));
pfb_carrysum_s3 carrychain1( .fco(fco), .sum1(sum[3]) , .sum0(sum[2]), .f1_b(lut4g_n[1]), .gen1(geng_1), .f0_b(lut4f_n[1]), .gen0(genf_1), .ci0_n(fco1_n), .mc1_ripmode(mc1_rp1));

dff_slice dff_slice( .q0(q[0]), .q1(q[1]), .ce(ce_in), .sr(sr_in), .clk(clk_in), .gsrn(gsrn), .gsrforce_n(done_gwe), .mc1_syncmode(mc1_syncmode),
									 .mc1_disgsr(mc1_disgsr), .mc1_testsh(mc1_testsh), .di(mi[1:0]), .f(f[1:0]),.fx(fx[1:0]),.mc1_sr(mc1_sr[1:0]),.mc1_di(mc1_di[1:0]),.mc1_fx(mc1_fx[1:0]),.latchmode(latchmode));
endmodule


module pfb_slice23_lut4 (lut4_o , gen , mc1_ripmode, I0, I1, I2, I3); 
output lut4_o;
output gen;
input mc1_ripmode;
input I0,I1,I2,I3;
parameter INIT=16'h0000 ;


wire      lut00 = INIT[{1'b0,1'b0,I1,I0}];
wire      lut01 = INIT[{1'b0,1'b1,I1,I0}];
wire      lut10 = INIT[{1'b1,1'b0,I1,I0}];
wire      lut11 = INIT[{1'b1,1'b1,I1,I0}];
reg lut4_o;
      always @(lut00 or lut01 or lut10 or lut11 or I3 or I2)
      begin
      case({I3,I2})
      	2'b00 : lut4_o = lut00;
      	2'b01 : lut4_o = lut01;
      	2'b10 : lut4_o = lut10;
      	2'b11 : lut4_o = lut11;
      endcase
      
      end
      
      wire lut00_n = ~lut00;
      wire mc1_rpn = ~mc1_ripmode;                   
      nor (gen, mc1_rpn, lut00_n);
      
      
endmodule


module pfb_carrysum_s2( fco_n, sum1 , sum0, f1_b, gen1, f0_b, gen0, ci0, mc1_ripmode);
output fco_n, sum1, sum0 ;
input f1_b, gen1, f0_b, gen0, ci0;
input mc1_ripmode ;
wire prog1,prog0,co0,co1,sum0,sum1,net31,fco_n;

assign prog1 = mc1_ripmode ? ~f1_b: 1'b0;
assign co1   = prog1 ? co0 : gen1;
assign prog0 = mc1_ripmode ? ~f0_b: 1'b0;
assign net31 = prog0 ? ci0 : gen0 ;
assign co0   = mc1_ripmode & net31;
assign sum1  = prog1 ? ~co0 : co0;
assign sum0  = prog0 ? ~ci0 : ci0;
assign fco_n = (prog1&prog0)? ~ci0 : ~co1;
endmodule


module pfb_carrysum_s3( fco, sum1 , sum0, f1_b, gen1, f0_b, gen0, ci0_n, mc1_ripmode);
output fco, sum1, sum0 ;
input f1_b, gen1, f0_b, gen0, ci0_n;
input mc1_ripmode ;
wire ci0,prog1,prog0,co0,co1_n,sum0,sum1,net70,fco,co0_n;

assign ci0 = ~ci0_n;
assign prog1 = mc1_ripmode ? ~f1_b: 1'b0;
assign co1_n   = prog1 ? co0_n : ~gen1;
assign prog0 = mc1_ripmode ? ~f0_b: 1'b0;
assign net70 = prog0 ? ci0 : gen0 ;
assign co0   = mc1_ripmode & net70;
assign co0_n = ~co0;
assign sum1  = prog1 ? ~co0 : ~co0_n;
assign sum0  = prog0 ? ci0_n : ~ci0;

assign fco = (prog1&prog0) ?  ~ci0_n : ~co1_n ;
endmodule

module pfb_lsliceomux( f,fx,f_n, sum0, sum1, lut4f, lut4g, func6, mc1_fxmuxlut4g, mc1_fxmuxrip_n, mc1_fmuxrip, mc1_fmuxlut5,in5);
output f, fx, f_n;
input sum0, sum1, lut4f, lut4g, func6, mc1_fxmuxlut4g, mc1_fxmuxrip_n,mc1_fmuxrip, mc1_fmuxlut5;
input in5;
reg f,fx;
wire f_n;
always @(mc1_fxmuxlut4g,mc1_fxmuxrip_n,sum1,lut4g,func6)
	begin
	case({mc1_fxmuxlut4g,mc1_fxmuxrip_n})
	   2'b00:  fx = 1'b0;
	   2'b10:  fx = sum1;
	   2'b01:  fx = lut4g ;
	   2'b11:  fx = func6 ;
	endcase
	end
///
// begin
//wire in5__mc1_fmuxlut5 = (in5 === 1'bx)?mc1_fmuxlut5:(in5&mc1_fmuxlut5);
//wire sg = mc1_fmuxrip? 1'b0 : (in5__mc1_fmuxlut5);
//wire sf = mc1_fmuxrip? 1'b0 : ~(in5__mc1_fmuxlut5);
// end
///
wire sg = mc1_fmuxrip? 1'b0 : (in5&mc1_fmuxlut5);
wire sf = mc1_fmuxrip? 1'b0 : ~(in5&mc1_fmuxlut5);

wire [2:0]fsel={sg,sf,mc1_fmuxrip};	
always @(fsel,sum0,lut4f,lut4g)
	begin
	case(fsel)
	   3'b100:  f = lut4g;
	   3'b010:  f = lut4f;
	   3'b001:  f = sum0 ;
	   default: f = 1'bx ; //$display("maybe circuit Error : LSLICE FMUX select signal non ONE-HOT %b", fsel);
	endcase
	end
assign f_n = ~f;
endmodule
	
