///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            mslice
//   Filename : al_phy_mslice.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//    04/02/14 - add dpram interface and function , modify lut4 code for disram function
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module AL_PHY_MSLICE
  (
  a,
  b,
  c,
  ce,
  clk,
  d,
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
  input [1:0] a,b,c,d,mi;
  input clk;
  input ce;
  input sr;
  input fci;
  output [1:0] f,fx,q;
  output fco;    
// dpram special interface
  input dpram_mode;
  input [1:0] dpram_di;
  input dpram_we;
  input dpram_wclk;
  input [3:0]dpram_waddr;
      
tri1 [1:0] a,b,c,d,mi;
tri1 clk;
tri1 ce;
tri1 sr;
tri0 fci; 
tri0 dpram_mode;
tri0 [1:0] dpram_di;
tri0 dpram_we;
tri0 dpram_wclk;
tri0 [3:0]dpram_waddr;
   
parameter INIT_LUT0 = 16'h0000 ;
parameter INIT_LUT1 = 16'h0000 ;
parameter MODE = "LOGIC" ;
parameter MSFXMUX = "OFF" ;
parameter GSR = "DISABLE" ;
parameter TESTMODE = "OFF" ;
//parameter CEMUX = "1" ;
//parameter SRMUX = "1" ;
parameter CEMUX = "CE" ;
parameter SRMUX = "SR" ;
parameter CLKMUX = "CLK" ;
parameter SRMODE = "ASYNC" ;
parameter DFFMODE = "FF" ;
parameter REG0_SD = "MI" ;
parameter REG1_SD = "MI" ;
parameter REG0_REGSET = "SET" ;
parameter REG1_REGSET = "SET" ;

// global control signs
wire gsrn = glbl.gsrn;
wire done_gwe = glbl.done_gwe;

reg mc1_fxmuxon, mc1_rp0, mc1_rp1,  mc1_testsh, latchmode ;
reg [1:0]mc1_sr,mc1_di,mc1_fx;
reg  mc1_syncmode, mc1_disgsr ;
reg mc1_disram;  
initial begin

   	case (MSFXMUX)
   		"OFF"  : mc1_fxmuxon = 0;
   		"ON"   : mc1_fxmuxon = 1;
   		default : mc1_fxmuxon = 0;
   	endcase	 
   	
	case (MODE)
   		"LOGIC"  : begin 
   				mc1_rp0 = 0;
   				mc1_rp1 = 0;
   				mc1_disram = 0;
   			    end	
   		"RIPPLE"  : begin // begin
   				mc1_rp0 = 1;   //
   				mc1_rp1 = 1;   //
   				mc1_disram = 0;
   			    end	         // end
   		"DPRAM"   : begin
   				mc1_rp0 = 0;
   				mc1_rp1 = 0;
   			        mc1_disram = 1 ;
   			    end	    
      // begin 
   		// "ADDER2"  : begin 
   		// 		mc1_rp0 = 1;
   		// 		mc1_rp1 = 1;
   		// 	    end	 
   		// "ADDER0"  : begin 
   		// 		mc1_rp0 = 1;
   		// 		mc1_rp1 = 0;
   		// 	    end
   		// "ADDER1"  : begin 
   		// 		mc1_rp0 = 0;
   		// 		mc1_rp1 = 1;
   		// 	    end	 	    	 	    
      // end
   		default :   begin 
   				mc1_rp0 = 0;
   				mc1_rp1 = 0;
   				mc1_disram = 0;
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
  			//default: ce_in = 1'b1;    	
  			default: ce_in = ce;  //
		endcase
		end
	always @(sr or SRMUX)
  		begin
    		case(SRMUX)
  			"SR"  : sr_in = sr ;
  			"INV" : sr_in = ~sr ;
  			"1"   : sr_in = 1'b1;
  			"0"   : sr_in = 1'b0;
  			//default: sr_in = 1'b1;    	
  			default: sr_in = sr; //   	
		endcase
		end

	always @(clk or CLKMUX)
  		begin
    		case(CLKMUX)
  			"CLK"  	: clk_in = clk ;
  			"INV" 		: clk_in = ~clk ;  			
  			"1"   		: clk_in = 1'b1;
  			"0"   		: clk_in = 1'b0;
  			default		: clk_in = clk ;    	
		endcase
		end

wire fxina_n = 1'b0;
wire fxinb_n = 1'b0;		
wire cyout = mc1_rp0 & mc1_fxmuxon ;
wire disram_mode = mc1_disram | dpram_mode ;
pfb_slice01_lut4 #(.INIT(INIT_LUT0)) lut4_0(.lut4_o(f0j) , .lut00_n(gen0_n) , .mc1_ripmode(mc1_rp0), .I0(a[0]), .I1(b[0]), .I2(c[0]), .I3(d[0]),
		.dpram_mode(disram_mode),.dpram_di(dpram_di[0]),.dpram_we(dpram_we),.dpram_wclk(dpram_wclk),.dpram_waddr(dpram_waddr)
		); 
pfb_slice01_lut4 #(.INIT(INIT_LUT1)) lut4_1(.lut4_o(f1j) , .lut00_n(gen1_n) , .mc1_ripmode(mc1_rp1), .I0(a[1]), .I1(b[1]), .I2(c[1]), .I3(d[1]),
		.dpram_mode(disram_mode),.dpram_di(dpram_di[1]),.dpram_we(dpram_we),.dpram_wclk(dpram_wclk),.dpram_waddr(dpram_waddr)
);

wire [1:0]f_nn,f_n,fx_nn;
pfb_slice01_fmux fmux0( .f(f[0]), .f_nn(f_nn[0]), .f_n(f_n[0]), .fin(f0j), .ci(fci), .mc1_rp(mc1_rp0) );
pfb_slice01_fmux fmux1( .f(f[1]), .f_nn(f_nn[1]), .f_n(f_n[1]), .fin(f1j), .ci(co0), .mc1_rp(mc1_rp1) );

pfb_msfxmux0 fxmux0( .fx(fx[0]), .fx_nn(fx_nn[0]), .f5_n(f5_n), .mc1_fxmuxon(mc1_fxmuxon), .cyout(cyout), .f0_n(f_n[0]), .f1_n(f_n[1]), .mi(mi[0]), .co(co0));
pfb_msfxmux0 fxmux1( .fx(fx[1]), .fx_nn(fx_nn[1]), .f5_n(dummy_f5_n), .mc1_fxmuxon(mc1_fxmuxon), .cyout(cyout), .f0_n(fxina_n), .f1_n(fxinb_n), .mi(mi[1]), .co(co1));
// fxina,fxinb in this simulation mode now is no used for lut6






pfb_carrysum_s0 carrychain( .fco(fco), .co1(co1), .co0(co0) , .co0_n(dummy_co0n), .f1_b(f_n[1]), .gen1_n(gen1_n), 
				.f0_b(f_n[0]), .gen0_n(gen0_n), .ci0(fci), .ci0_n(dummy_ci0n), .mc1_ripmode1(mc1_rp1), .mc1_ripmode0(mc1_rp0));

dff_slice dff_slice( .q0(q[0]), .q1(q[1]), .ce(ce_in), .sr(sr_in), .clk(clk_in), .gsrn(gsrn), .gsrforce_n(done_gwe), .mc1_syncmode(mc1_syncmode),
									 .mc1_disgsr(mc1_disgsr), .mc1_testsh(mc1_testsh), .di(mi[1:0]), .f(f[1:0]),.fx(fx[1:0]),.mc1_sr(mc1_sr[1:0]),.mc1_di(mc1_di[1:0]),.mc1_fx(mc1_fx[1:0]),.latchmode(latchmode));

endmodule


module pfb_slice01_lut4 (lut4_o , lut00_n , mc1_ripmode, I0, I1, I2, I3, dpram_mode,dpram_di,dpram_we,dpram_wclk,dpram_waddr); 
output lut4_o;
output lut00_n;
input mc1_ripmode;
input I0,I1,I2,I3;
parameter INIT=16'h0000 ;

//dpram interface
input dpram_mode;
input dpram_di,dpram_we,dpram_wclk;
input [3:0] dpram_waddr;

reg [15:0] value_lut4;
reg lut4_o;
reg lut00,lut01,lut10,lut11;
initial begin
	value_lut4 = INIT ;
end

wire dpram_weclk = dpram_mode & dpram_wclk ;
	always @(posedge dpram_weclk)
	begin
	   if(dpram_we) 
	   begin
	   value_lut4[dpram_waddr]= dpram_di ;
	   end  
	end

      always @(I1 or I0 or value_lut4[3:0])
      begin
      case({I1,I0})
      	2'b00 : lut00 = value_lut4[0];
      	2'b01 : lut00 = value_lut4[1];
      	2'b10 : lut00 = value_lut4[2];
      	2'b11 : lut00 = value_lut4[3];
      endcase
      end	
      always @(I1 or I0 or value_lut4[7:4])
      begin
      case({I1,I0})
      	2'b00 : lut01 = value_lut4[4];
      	2'b01 : lut01 = value_lut4[5];
      	2'b10 : lut01 = value_lut4[6];
      	2'b11 : lut01 = value_lut4[7];
      endcase
      end
      always @(I1 or I0 or value_lut4[11:8])
      begin
      case({I1,I0})
      	2'b00 : lut10 = value_lut4[8];
      	2'b01 : lut10 = value_lut4[9];
      	2'b10 : lut10 = value_lut4[10];
      	2'b11 : lut10 = value_lut4[11];
      endcase
	end
      always @(I1 or I0 or value_lut4[15:12])
      begin
      case({I1,I0})
      	2'b00 : lut11 = value_lut4[12];
      	2'b01 : lut11 = value_lut4[13];
      	2'b10 : lut11 = value_lut4[14];
      	2'b11 : lut11 = value_lut4[15];
      endcase      
	end	
      always @(lut00 or lut01 or lut10 or lut11 or I3 or I2)
      begin
      case({I3,I2})
      	2'b00 : lut4_o = lut00;
      	2'b01 : lut4_o = lut01;
      	2'b10 : lut4_o = lut10;
      	2'b11 : lut4_o = lut11;
      endcase     
      end
                         
      nand (lut00_n, mc1_ripmode, lut00);
   

      
endmodule


module pfb_carrysum_s0( fco, co1, co0 , co0_n, f1_b, gen1_n, f0_b, gen0_n, ci0, ci0_n, mc1_ripmode1, mc1_ripmode0);
output fco, co1, co0, co0_n, ci0_n ;
input f1_b, gen1_n, f0_b, gen0_n, ci0;
input mc1_ripmode1, mc1_ripmode0 ;

wire prog1 = mc1_ripmode1 ? ~f1_b: 1'b0;
wire co1 = prog1 ? ~co0_n : ~gen1_n;
wire prog0 = mc1_ripmode0 ? ~f0_b: 1'b0;
wire co0_n = prog0 ? ~ci0 : gen0_n ;
wire co0 = ~co0_n;
wire fco = (prog1&prog0) ? ci0 : co1 ;
wire fco_n = ~fco ;
wire ci0_n = ~ci0 ;


endmodule

module pfb_slice01_fmux ( f, f_nn, f_n, fin, ci, mc1_rp );
output f , f_nn, f_n ;
input fin, ci, mc1_rp ;

  and ( s, ci, mc1_rp);
  
  wire f = s? ~fin : fin ;
  wire f_nn = f ;
  wire f_n = ~fin ;
endmodule

module pfb_msfxmux0( fx, fx_nn, f5_n, mc1_fxmuxon, cyout, f0_n, f1_n, mi, co);
output fx,fx_nn,f5_n;
input mc1_fxmuxon, cyout, f0_n, f1_n, mi, co ;

wire mi_nn = mi & mc1_fxmuxon ;
wire fxmux = mi_nn ? f1_n : f0_n ;
wire gate_fxmux = ~( mc1_fxmuxon & fxmux );
wire f5_n = ~gate_fxmux ;
wire net34 = cyout ? co : gate_fxmux ;
wire fx = net34 ;
wire fx_nn = net34 ;

endmodule

	
