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
//   Filename : al_phy_mult18.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//    06/20/14 - update INVMUX parameter
///////////////////////////////////////////////////////////////////////////////

`timescale  1 ns / 10 ps

module AL_PHY_MULT18 (acout, bcout, p, signeda, signedb, a, b, acin, bcin, cea, ceb, cepd, clk, rstan, rstbn, rstpdn,
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
    input rstan;
    input rstbn;
    input rstpdn;
    input sourcea;
    input sourceb;


    tri1 sourcea, sourceb;
    tri1 signeda, signedb;
    tri1 cea, ceb;
    tri1 cepd, rstan, rstbn, rstpdn;
    tri1 [17:0] a,b,acin,bcin;

    tri1 gsrn = glbl.gsrn;
    parameter INPUTREGA = "ENABLE"; // ENABLE/DISABLE
    parameter INPUTREGB = "ENABLE"; // ENABLE/DISABLE
    parameter OUTPUTREG = "ENABLE"; // ENABLE/DISABLE
    parameter SRMODE    = "ASYNC";  // ASYNC/SYNC
    parameter MODE      = "MULT18X18C"; //MULT9X9C/MULT18X18C
    
    parameter CEAMUX = "SIG"; //0, 1, INV, SIG
    parameter CEBMUX = "SIG"; //0, 1, INV, SIG
    parameter CEPDMUX = "SIG"; //0, 1, INV, SIG
    parameter RSTANMUX = "SIG"; //0, 1, INV, SIG
    parameter RSTBNMUX = "SIG"; //0, 1, INV, SIG
    parameter RSTPDNMUX = "SIG"; //0, 1, INV, SIG
    parameter CLKMUX = "SIG"; //0, 1, INV, SIG
    parameter SIGNEDAMUX = "SIG"; //0, 1, INV, SIG
    parameter SIGNEDBMUX = "SIG"; //0, 1, INV, SIG
    parameter SOURCEAMUX = "SIG"; //0, 1, INV, SIG
    parameter SOURCEBMUX = "SIG"; //0, 1, INV, SIG


    reg [35:0] p;
    reg [17:0] ir_a;
    reg [17:0] ir_b;

    reg [35:0] pd_r;
    reg [35:0] mux_pt;
    reg [17:0] multi_a;
    reg [17:0] multi_b;

    reg [17:0] a_se;
    reg [17:0] b_se;
    reg [17:0] imux_a;
    reg [17:0] imux_b;

    reg rsta_asyn_n;
    reg rstb_asyn_n;
    reg rstp_asyn_n;
    reg rsta_sync_n;
    reg rstb_sync_n;
    reg rstp_sync_n;

    wire [17:0] m9_a0;
    wire [17:0] m9_b0;
    wire [17:0] m9_a1;
    wire [17:0] m9_b1;
    wire [17:0] m9_pt0;
    wire [17:0] m9_pt1;
    wire [35:0] m18_a;
    wire [35:0] m18_b;
    wire [35:0] m18_pt;

    reg rstan_node,rstbn_node,rstpdn_node;
    reg cea_node,ceb_node,cepd_node;
    reg sourcea_node,sourceb_node;
    reg signeda_node,signedb_node;
    reg clk_node;
    
reg param_trig;
initial begin
param_trig=0;
param_trig=1;
end

   always @(param_trig)
   begin
        case (RSTANMUX)
            "SIG"   	: assign rstan_node = rstan;
            "0" 	: assign rstan_node = 0;
            "1" 	: assign rstan_node = 1;
            "INV"   	: assign rstan_node = ~rstan;
            default 	: assign rstan_node = rstan;
        endcase
        case (RSTBNMUX)
            "SIG"   	: assign rstbn_node = rstbn;
            "0" 	: assign rstbn_node = 0;
            "1" 	: assign rstbn_node = 1;
            "INV"   	: assign rstbn_node = ~rstbn;
            default 	: assign rstbn_node = rstbn;
        endcase          
        case (RSTPDNMUX)
            "SIG"   	: assign rstpdn_node = rstpdn;
            "0" 	: assign rstpdn_node = 0;
            "1" 	: assign rstpdn_node = 1;
            "INV"   	: assign rstpdn_node = ~rstpdn;
            default 	: assign rstpdn_node = rstpdn;
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
        case (CEPDMUX)
            "SIG"   	: assign cepd_node = cepd;
            "0" 	: assign cepd_node = 0;
            "1" 	: assign cepd_node = 1;
            "INV"   	: assign cepd_node = ~cepd;
            default 	: assign cepd_node = cepd;
        endcase
        case (SOURCEAMUX)
            "SIG"   	: assign sourcea_node = sourcea;
            "0" 	: assign sourcea_node = 0;
            "1" 	: assign sourcea_node = 1;
            "INV"   	: assign sourcea_node = ~sourcea;
            default 	: assign sourcea_node = sourcea;
        endcase
        case (SOURCEBMUX)
            "SIG"   	: assign sourceb_node = sourceb; 
            "0" 	: assign sourceb_node = 0;       
            "1" 	: assign sourceb_node = 1;       
            "INV"   	: assign sourceb_node = ~sourceb;
            default 	: assign sourceb_node = sourceb; 
        endcase        
        case (SIGNEDAMUX)
            "SIG"   	: assign signeda_node = signeda;
            "0" 	: assign signeda_node = 0;
            "1" 	: assign signeda_node = 1;
            "INV"   	: assign signeda_node = ~signeda;
            default 	: assign signeda_node = signeda;
        endcase
        case (SIGNEDBMUX)
            "SIG"   	: assign signedb_node = signedb; 
            "0" 	: assign signedb_node = 0;       
            "1" 	: assign signedb_node = 1;       
            "INV"   	: assign signedb_node = ~signedb;
            default 	: assign signedb_node = signedb; 
        endcase        
        case (CLKMUX)
            "SIG"   	: assign clk_node = clk;
            "0" 	: assign clk_node = 0;
            "1" 	: assign clk_node = 1;
            "INV"   	: assign clk_node = ~clk;
            default 	: assign clk_node = clk;
        endcase
       
   end // always



//*** GSRN pin
    always @(gsrn) begin
        if (!gsrn) begin
            assign ir_a = 18'b0;
            assign ir_b = 18'b0;
            assign pd_r = 36'b0;
        end
        else begin
            deassign ir_a;
            deassign ir_b;
            deassign pd_r;
        end
    end

    always @(rstan_node or rstbn_node or rstpdn_node) begin
      case(SRMODE)
        "ASYNC": begin
               rsta_asyn_n <= rstan_node;
               rstb_asyn_n <= rstbn_node;
               rstp_asyn_n <= rstpdn_node;
               rsta_sync_n <= rstan_node;
               rstb_sync_n <= rstbn_node;
               rstp_sync_n <= rstpdn_node;
          end
        "SYNC": begin
               rsta_asyn_n <= 1'b1;
               rstb_asyn_n <= 1'b1;
               rstp_asyn_n <= 1'b1;
               rsta_sync_n <= rstan_node;
               rstb_sync_n <= rstbn_node;
               rstp_sync_n <= rstpdn_node;
          end
        default: begin
              $display("attribute syntax error : the attribute SRMODE on dsp instance %m is set to %s. legal values for this attribute are ASYNC or SYNC.", SRMODE);
	      $finish;
          end
      endcase
    end

    always @(a or acin or sourcea_node) begin
      case(sourcea_node)
         0: imux_a <= acin;
         1: imux_a <= a;
      endcase
    end

    always @(b or bcin or sourceb_node) begin
      case(sourceb_node)
         0: imux_b <= bcin;
         1: imux_b <= b;
      endcase
    end

// Latch data
    always @(posedge clk_node or negedge rsta_asyn_n) begin
      if(!rsta_asyn_n) ir_a <= 18'b0;
      else if(!rsta_sync_n) ir_a <= 18'b0;
      else if(cea) ir_a <= imux_a;
    end
       
    always @(posedge clk_node or negedge rstb_asyn_n) begin
      if(!rstb_asyn_n) ir_b <= 18'b0;
      else if(!rstb_sync_n) ir_b <= 18'b0;
      else if(ceb) ir_b <= imux_b;
    end

    always @(posedge clk_node or negedge rstp_asyn_n) begin
      if(!rstp_asyn_n) pd_r <= 36'b0;
      else if(!rstp_sync_n) pd_r <= 36'b0;
      else if(cepd) pd_r <= mux_pt;
    end

// Bypass Register
   always @(ir_a or imux_a) begin
     case(INPUTREGA)
         "ENABLE": multi_a <= ir_a;
         "DISABLE": multi_a <= imux_a;
         default: begin
              $display("attribute syntax error : the attribute INPUTREGA on dsp instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", INPUTREGA);
	      $finish;
          end
     endcase
   end

   always @(ir_b or imux_b) begin
     case(INPUTREGB)
         "ENABLE": multi_b <= ir_b;
         "DISABLE": multi_b <= imux_b;
         default: begin
              $display("attribute syntax error : the attribute INPUTREGB on dsp instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", INPUTREGB);
	      $finish;
          end
     endcase
   end

   always @(pd_r or mux_pt) begin
     case(OUTPUTREG)
         "ENABLE": p <= pd_r;
         "DISABLE": p <= mux_pt;
         default: begin
              $display("attribute syntax error : the attribute OUTPUTREG on dsp instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", OUTPUTREG);
	      $finish;
          end
     endcase
   end

// Sign extention   
   
     assign m9_a0 = {{9{signeda_node&multi_a[8]}},multi_a[8:0]};
     assign m9_b0 = {{9{signedb_node&multi_b[8]}},multi_b[8:0]};

     assign m9_a1 = {{9{signeda_node&multi_a[17]}},multi_a[17:9]};
     assign m9_b1 = {{9{signedb_node&multi_b[17]}},multi_b[17:9]};

     assign m18_a = {{18{signeda_node&multi_a[17]}},multi_a[17:0]};
     assign m18_b = {{18{signedb_node&multi_b[17]}},multi_b[17:0]};

     assign m9_pt0 = m9_a0 * m9_b0;
     assign m9_pt1 = m9_a1 * m9_b1;

     assign m18_pt = m18_a * m18_b;
   
     assign acout = ir_a;
     assign bcout = ir_b;

// M18x18/M9x9
   always @(m9_pt0 or m9_pt1 or m18_pt) begin
     case(MODE)
       "MULT9X9C":   mux_pt = {m9_pt1[17:0],m9_pt0[17:0]};
       "MULT18X18C": mux_pt = m18_pt;
       default: begin
            $display("attribute syntax error : the attribute MODE on dsp instance %m is set to %s. legal values for this attribute are MULT9X9C or mult18x18.", MODE); $finish;
          end
     endcase
   end

//   specify
//
//      (clk *> p) = (100, 100);
//      (clk *> acout) = (100, 100);
//      (clk *> bcout) = (100, 100);
//      specparam pathpulse$ = 0;
//
//   endspecify

endmodule // dsp
