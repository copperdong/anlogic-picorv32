///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//            PLL block
//   Filename : al_phy_pll.v
//   Timestamp : Fri Nov  8 09:30:30 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/08/13 - Initial version.
//    12/25/2014 reduction IO connection  
//    2/25/2015  suport external feedback mode , align clkc to refclk
//    2016/2/14  change refclk_cycle initial value       
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 100 fs
   
module AL_PHY_PLL(clkc,ext_lock,refclk,stdby,fbclk,pllreset,scanclk,phaseupdown,phasestep,phasedone,phcntsel);
output [4:0] clkc;
output  ext_lock;
input  stdby;
input  refclk; 
input  fbclk;
input  pllreset;
input  scanclk;
input  phaseupdown; 
input  phasestep;
output phasedone;
input  [2:0] phcntsel;

wire clkcshot = 1'b0;
wire pllwakesync = 1'b0;
wire resetm      = 1'b0;
wire resetc2     = 1'b0;
wire resetc34    = 1'b0;
wire refshot     = 1'b0;
wire fbshot      = 1'b0;
wire en_pll2io   = 1'b1;
wire [4:0] enclkc= 5'b11111; 

tri1 [2:0] phcntsel; 
tri1 pllreset;
tri1 scanclk, phaseupdown, phasestep;
tri1 refclk, fbclk;

parameter REFCLK_SEL = "INTERNAL"; // INTERNAL/EXTRNAL //

parameter FIN = "100.0000"; //no use in fact  
parameter REFCLK_DIV    = 1;    //  1-128
parameter FBCLK_DIV     = 1;    //  1-128
parameter CLKC0_DIV     = 1;    //  1-128
parameter CLKC1_DIV     = 1;    //  1-128
parameter CLKC2_DIV     = 1;    //  1-128
parameter CLKC3_DIV     = 1;    //  1-128
parameter CLKC4_DIV     = 1;    //  1-128
parameter CLKC0_ENABLE  = "DISABLE";   //  ENABLE/DISABLE/SIGNAL
parameter CLKC1_ENABLE  = "DISABLE";   //  ENABLE/DISABLE/SIGNAL
parameter CLKC2_ENABLE  = "DISABLE";   //  ENABLE/DISABLE/SIGNAL
parameter CLKC3_ENABLE  = "DISABLE";   //  ENABLE/DISABLE/SIGNAL
parameter CLKC4_ENABLE  = "DISABLE";   //  ENABLE/DISABLE/SIGNAL
//parameter INPUT_PATH   = "VCO_PHASE_0";  //  pip?
parameter FEEDBK_PATH   = "VCO_PHASE_0";  
parameter INT_FEEDBK_PATH   = "VCO_PHASE_0";  
// VCO_PHASE_0   --- for vco feedback mode 
// CLKC0_INT, CLKC1_INT, CLKC2_INT, CLKC3_INT, CLKC4_INT   --- for clkc interal feedback mode
// CLKC0_EXT, CLKC1_EXT, CLKC2_EXT, CLKC3_EXT, CLKC4_EXT   --- for clkc exteral feedback mode
parameter STDBY_ENABLE  = "ENABLE";   //  ENABLE/DISABLE

parameter CLKC0_FPHASE     = "0";    //  0-7
parameter CLKC1_FPHASE     = "0";    //  0-7
parameter CLKC2_FPHASE     = "0";    //  0-7
parameter CLKC3_FPHASE     = "0";    //  0-7
parameter CLKC4_FPHASE     = "0";    //  0-7
parameter CLKC0_CPHASE     = 1;      //  1-128  ,CLKC0_CPHASE <= CLKC0_DIV
parameter CLKC1_CPHASE     = 1;      //  1-128  ,CLKC1_CPHASE <= CLKC1_DIV
parameter CLKC2_CPHASE     = 1;      //  1-128  ,CLKC2_CPHASE <= CLKC2_DIV
parameter CLKC3_CPHASE     = 1;      //  1-128  ,CLKC3_CPHASE <= CLKC3_DIV
parameter CLKC4_CPHASE     = 1;      //  1-128  ,CLKC4_CPHASE <= CLKC4_DIV

parameter GMC_GAIN         = "7";  // 0-7
parameter GMC_TEST         = "14"; // 0-15
parameter ICP_CURRENT      = 14;   // 1-32
parameter KVCO             = "7";  // 0-7
parameter LPF_CAPACITOR    = "3";  // 0-3
parameter LPF_RESISTOR     = 1;    // 1-128

parameter PLLRST_ENA       = "ENABLE";    // ENABLE/DISABLE
parameter PLLMRST_ENA      = "DISABLE";   // ENABLE/DISABLE
parameter PLLC2RST_ENA     = "DISABLE";   // ENABLE/DISABLE
parameter PLLC34RST_ENA    = "DISABLE";   // ENABLE/DISABLE

parameter PREDIV_MUXC0 = "VCO";    // VCO/CLKMINUS1/CLKPLUS1/REFCLK
parameter PREDIV_MUXC1 = "VCO";    // VCO/CLKMINUS1/CLKPLUS1/REFCLK
parameter PREDIV_MUXC2 = "VCO";    // VCO/CLKMINUS1/CLKPLUS1/REFCLK
parameter PREDIV_MUXC3 = "VCO";    // VCO/CLKMINUS1/CLKPLUS1/REFCLK
parameter PREDIV_MUXC4 = "VCO";    // VCO/CLKMINUS1/CLKPLUS1/REFCLK

parameter ODIV_MUXC0 = "DIV";    // DIV/REFCLK
parameter ODIV_MUXC1 = "DIV";    // DIV/REFCLK
parameter ODIV_MUXC2 = "DIV";    // DIV/REFCLK
parameter ODIV_MUXC3 = "DIV";    // DIV/REFCLK
parameter ODIV_MUXC4 = "DIV";    // DIV/REFCLK

parameter FREQ_LOCK_ACCURACY = "2"; // 0-3
//parameter PLL_LOCK_DELAY = "200";
parameter PLL_LOCK_MODE = "0";    // 0-7, 2 => sticky, 0 => non-sticky

parameter INTFB_WAKE      = "DISABLE";  //  ENBALE/DISABLE
parameter DPHASE_SOURCE   = "DISABLE";  //  ENABLE/DISABLE  
parameter VCO_NORESET     = "DISABLE";  //  ENABLE/DISABLE 
parameter STDBY_VCO_ENA   = "DISABLE";  //  ENABLE/DISABLE 
parameter NORESET         = "DISABLE";  //  ENABLE/DISABLE 
parameter SYNC_ENABLE     = "ENABLE";   //  ENABLE/DISABLE                      

realtime vco_half_cycle, time_refclk_1st_r, time_refclk_1st_f, fph_step, refclk_cycle;

reg refclk_1st_rise, refclk_1st_fall;
reg clkvco;
reg [4:0] clkc_en_sram;
reg [4:0] clkc_omux_sram;
reg [1:0] prediv_mux0_sram;
reg [1:0] prediv_mux1_sram;
reg [1:0] prediv_mux2_sram;
reg [1:0] prediv_mux3_sram;
reg [1:0] prediv_mux4_sram;
reg clkoen_sync;
reg rstdiv0_n_sync;
reg rstdiv2_n_sync;
reg rstdiv3_n_sync;

reg [9:0] lock_cnt;
reg [5:0] fph_sram;
reg [7:0] fphsel;
reg chk_ok;
reg [160:0] param_name;
reg ilock_rls;
reg elock_rls;
reg int_lock, ext_lock;
reg vco_st;
integer pulse_count;
integer ref_cnt,fb_cnt;

reg stdby_sync;
reg vco_st_sync;
reg [3:1] phaset;

wire [7:0] phase;
wire [4:0] clkoen;
wire [4:0] clk_prediv;
reg  [4:0] clk_prediv_delay;

wire pll2io;
wire divc4,divc3,divc2,divc1,divc0;
wire mfgouta = 1'b0;
wire mfgoutb = 1'b0;

wire [4:0] sclk, load_reg, rotate, direct;
integer fb_path_div;

// measure the refclk half cycle

  initial
   begin
     clkc_en_sram      = 5'b00000;
     clkc_omux_sram    = 5'b00000;
     prediv_mux0_sram  = 2'b00;
     prediv_mux1_sram  = 2'b00;
     prediv_mux2_sram  = 2'b00;
     prediv_mux3_sram  = 2'b00;
     prediv_mux4_sram  = 2'b00;
     clkoen_sync       = 1'b0;
     rstdiv0_n_sync    = 1'b0;
     rstdiv2_n_sync    = 1'b0;
     rstdiv3_n_sync    = 1'b0;

     lock_cnt = 10'b0000000000;
     fph_sram = 6'b000000;
     chk_ok   = 1'b0;
     clkvco   = 1'b0;
     ilock_rls = 1'b0;
     elock_rls = 1'b0;
     phaset    = 3'b0;
   end

  initial
   begin
      vco_st = 1'b0;
      fph_sram = 6'b0;
      time_refclk_1st_r    = 0.0;
      time_refclk_1st_f    = 1;
      vco_half_cycle       = 1;
      refclk_cycle         = 1; 
      refclk_1st_rise = 1'b0;
      refclk_1st_fall = 1'b0;
      pulse_count     = 0;
      ref_cnt         = 0;
      fb_cnt          = 0;  
      #1;
      refclk_1st_rise = 1'b1;
      refclk_1st_fall = 1'b1;
      #500;
//      vco_st = 1'b1;
   end

  initial
   begin
     param_name = "REFCLK_DIV";
     chk_ok = para_int_range_chk(REFCLK_DIV,  param_name,  1, 128); 
     param_name = "FBCLK_DIV";
     chk_ok = para_int_range_chk(FBCLK_DIV, param_name,  1, 128); 
     param_name = "CLKC0_DIV";
     chk_ok = para_int_range_chk(CLKC0_DIV, param_name,  1, 128); 
     param_name = "CLKC1_DIV";
     chk_ok = para_int_range_chk(CLKC1_DIV, param_name,  1, 128); 
     param_name = "CLKC2_DIV";
     chk_ok = para_int_range_chk(CLKC2_DIV, param_name,  1, 128); 
     param_name = "CLKC3_DIV";
     chk_ok = para_int_range_chk(CLKC3_DIV, param_name,  1, 128); 
     param_name = "CLKC4_DIV";
     chk_ok = para_int_range_chk(CLKC4_DIV, param_name,  1, 128); 
   end

  initial begin
    case (FEEDBK_PATH)
      "VCO_PHASE_0" : fb_path_div <= 1;
      "CLKC0_INT"   : fb_path_div <= CLKC0_DIV;
      "CLKC0_EXT"   : fb_path_div <= CLKC0_DIV;
      "CLKC1_INT"   : fb_path_div <= CLKC1_DIV;
      "CLKC1_EXT"   : fb_path_div <= CLKC1_DIV;
      "CLKC2_INT"   : fb_path_div <= CLKC2_DIV;
      "CLKC2_EXT"   : fb_path_div <= CLKC2_DIV;
      "CLKC3_INT"   : fb_path_div <= CLKC3_DIV;
      "CLKC3_EXT"   : fb_path_div <= CLKC3_DIV;
      "CLKC4_INT"   : fb_path_div <= CLKC4_DIV;   
      "CLKC4_EXT"   : fb_path_div <= CLKC4_DIV;   
      default   : begin
        $display("attribute syntax error : the attribute FEEDBK_PATH is set to %s. legal values for this attribute are one of : \
                 VCO_PHASE_0, CLKC0_INT, CLKC1_INT, CLKC2_INT, CLKC3_INT, CLKC4_INT , CLKC0_EXT, CLKC1_EXT, CLKC2_EXT, CLKC3_EXT, CLKC4_EXT", FEEDBK_PATH);
        $finish;
      end
    endcase
  end
 
  wire rstm_n   =  (PLLMRST_ENA == "ENABLE")? (~resetm & ~stdby)  : ~stdby;
  wire pllrst_n =  (PLLRST_ENA == "ENABLE")? (rstm_n & ~pllreset) : rstm_n;
  wire rstdiv2_n =  (PLLC2RST_ENA == "ENABLE")? (~resetc2 & pllrst_n) : pllrst_n;
  wire rstdiv3_n =  (PLLC34RST_ENA == "ENABLE")? (~resetc34 & pllrst_n) : pllrst_n;
                          
  always @(negedge refclk or negedge pllrst_n) 
    if(~pllrst_n) 
        pulse_count <= 0;
    else 
        pulse_count <= pulse_count + 1;    
    
  always @(posedge refclk) begin
    if (pulse_count == 23) begin
      vco_st <= 1'b1;
    end
  end

  always @(posedge refclk) begin
    if (pulse_count == 20) begin
      time_refclk_1st_r <= $realtime;
    end
  end

  always @(posedge refclk) begin
    if ((pulse_count == 21)) begin
      time_refclk_1st_f <= $realtime;
    end
  end

  always @(posedge refclk) 
  if(pulse_count == 22)begin
        vco_half_cycle <= (time_refclk_1st_f - time_refclk_1st_r)*REFCLK_DIV/FBCLK_DIV/fb_path_div/2.0;
        refclk_cycle   <= (time_refclk_1st_f - time_refclk_1st_r);    
  end  
  
  always @(posedge refclk)  fph_step <= vco_half_cycle/4;

  reg clkvco_org; 
  always @(clkvco_org or vco_st_sync or stdby_sync)  
    clkvco_org <= #(vco_half_cycle) ~clkvco_org & ~stdby_sync & vco_st_sync;
       
  always @(clkvco_org)  
    clkvco <= #(refclk_cycle - vco_half_cycle)  clkvco_org;  //align posedge of clkvco to  posedge of refclk

  always @(posedge refclk or negedge pllrst_n) begin
    if(!pllrst_n) stdby_sync <= 1'b0;
    else stdby_sync <= stdby;
  end

  always @(posedge refclk or negedge pllrst_n) begin
    if(!pllrst_n) vco_st_sync <= 1'b0;
    else vco_st_sync <= vco_st;
  end

  always @(clkvco) begin
    #(fph_step)   phaset[1] <= clkvco;
  end
  
  always @(clkvco) begin
    #(fph_step*2) phaset[2] <= clkvco;
  end
  
  always @(clkvco) begin
    #(fph_step*3) phaset[3] <= clkvco;
  end
  
  assign phase[0] = clkvco;
  assign phase[1] = phaset[1];
  assign phase[2] = phaset[2];
  assign phase[3] = phaset[3];
  assign phase[4] = ~phase[0];
  assign phase[5] = ~phase[1];
  assign phase[6] = ~phase[2];
  assign phase[7] = ~phase[3];
  wire vco_p0 = clkvco;

// Phase select
  wire [4:0] phdone;
  wire phasedone = |phdone;
  
  wire ld_reg_i     = (DPHASE_SOURCE == "ENABLE")? clkcshot : fph_sram[0];
  wire phstep_i     = (DPHASE_SOURCE == "ENABLE")? phasestep: fph_sram[1];
  wire phupdown_i = (DPHASE_SOURCE == "ENABLE")? phaseupdown : fph_sram[2];
  wire [2:0] phsel  = (DPHASE_SOURCE == "ENABLE")? phcntsel : fph_sram[5:3];

  always @(phsel) begin
    case(phsel)
      3'b000 : fphsel <= 8'b00000001;
      3'b001 : fphsel <= 8'b00000010;
      3'b010 : fphsel <= 8'b00000100;
      3'b011 : fphsel <= 8'b00001000;
      3'b100 : fphsel <= 8'b00010000;
      default: fphsel <= 8'b10000000;
    endcase
  end

  assign sclk      = fphsel[4:0] & {5{scanclk}};
  assign rotate    = fphsel[4:0] & {5{phstep_i}};
  assign direct    = fphsel[4:0] & {5{phupdown_i}};
  assign load_reg  = {5{ld_reg_i}};
  
    
  al_dphase_sel dphase_sel_0 (.clko(phc0), .phdone(phdone[0]), .rotate(rotate[0]), .direct(direct[0]),
                              .phase(phase), .scanclk(sclk[0]), .rst_n(pllrst_n));

  al_dphase_sel dphase_sel_1 (.clko(phc1), .phdone(phdone[1]), .rotate(rotate[1]), .direct(direct[1]),
                              .phase(phase), .scanclk(sclk[1]), .rst_n(pllrst_n));

  al_dphase_sel dphase_sel_2 (.clko(phc2), .phdone(phdone[2]), .rotate(rotate[2]), .direct(direct[2]),
                              .phase(phase), .scanclk(sclk[2]), .rst_n(pllrst_n));

  al_dphase_sel dphase_sel_3 (.clko(phc3), .phdone(phdone[3]), .rotate(rotate[3]), .direct(direct[3]),
                              .phase(phase), .scanclk(sclk[3]), .rst_n(pllrst_n));

  al_dphase_sel dphase_sel_4 (.clko(phc4), .phdone(phdone[4]), .rotate(rotate[4]), .direct(direct[4]),
                              .phase(phase), .scanclk(sclk[4]), .rst_n(pllrst_n));

  defparam  dphase_sel_0.PH_INIT_PARA = CLKC0_FPHASE;
  defparam  dphase_sel_1.PH_INIT_PARA = CLKC1_FPHASE;
  defparam  dphase_sel_2.PH_INIT_PARA = CLKC2_FPHASE;
  defparam  dphase_sel_3.PH_INIT_PARA = CLKC3_FPHASE;
  defparam  dphase_sel_4.PH_INIT_PARA = CLKC4_FPHASE;

  wire ph7 = phase[7];

// clkc output premux select

  initial begin
    case (PREDIV_MUXC0)
      "VCO"       : prediv_mux0_sram <= 2'b00;
      "CLKMINUS1" : prediv_mux0_sram <= 2'b01;
      "CLKPLUS1"  : prediv_mux0_sram <= 2'b10;
      "regclk"    : prediv_mux0_sram <= 2'b11;
      default   : begin
        $display("attribute syntax error : the attribute PREDIV_MUXC0 on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", PREDIV_MUXC0);
        $finish;
      end
    endcase

    case (PREDIV_MUXC1)
      "VCO"       : prediv_mux1_sram <= 2'b00;
      "CLKMINUS1" : prediv_mux1_sram <= 2'b01;
      "CLKPLUS1"  : prediv_mux1_sram <= 2'b10;
      "regclk"    : prediv_mux1_sram <= 2'b11;
      default   : begin
        $display("attribute syntax error : the attribute PREDIV_MUXC1 on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", PREDIV_MUXC1);
        $finish;
      end
    endcase

    case (PREDIV_MUXC2)
      "VCO"       : prediv_mux2_sram <= 2'b00;
      "CLKMINUS1" : prediv_mux2_sram <= 2'b01;
      "CLKPLUS1"  : prediv_mux2_sram <= 2'b10;
      "regclk"    : prediv_mux2_sram <= 2'b11;
      default   : begin
        $display("attribute syntax error : the attribute PREDIV_MUXC2 on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", PREDIV_MUXC2);
        $finish;
      end
    endcase

    case (PREDIV_MUXC3)
      "VCO"       : prediv_mux3_sram <= 2'b00;
      "CLKMINUS1" : prediv_mux3_sram <= 2'b01;
      "CLKPLUS1"  : prediv_mux3_sram <= 2'b10;
      "regclk"    : prediv_mux3_sram <= 2'b11;
      default   : begin
        $display("attribute syntax error : the attribute PREDIV_MUXC3 on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", PREDIV_MUXC3);
        $finish;
      end
    endcase

    case (PREDIV_MUXC4)
      "VCO"       : prediv_mux4_sram <= 2'b00;
      "CLKMINUS1" : prediv_mux4_sram <= 2'b01;
      "CLKPLUS1"  : prediv_mux4_sram <= 2'b10;
      "regclk"    : prediv_mux4_sram <= 2'b11;
      default   : begin
        $display("attribute syntax error : the attribute PREDIV_MUXC4 on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", PREDIV_MUXC4);
        $finish;
      end
    endcase


// clkc output en

    case (CLKC0_ENABLE)
      "ENABLE"  : clkc_en_sram[0] <= 1'b1;
      "DISABLE" : clkc_en_sram[0] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute CLKC0_ENABLE on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", CLKC0_ENABLE);
        $finish;
      end
    endcase

    case (CLKC1_ENABLE)
      "ENABLE"  : clkc_en_sram[1] <= 1'b1;
      "DISABLE" : clkc_en_sram[1] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute CLKC1_ENABLE on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", CLKC1_ENABLE);
        $finish;
      end
    endcase

    case (CLKC2_ENABLE)
      "ENABLE"  : clkc_en_sram[2] <= 1'b1;
      "DISABLE" : clkc_en_sram[2] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute CLKC2_ENABLE on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", CLKC2_ENABLE);
        $finish;
      end
    endcase

    case (CLKC3_ENABLE)
      "ENABLE"  : clkc_en_sram[3] <= 1'b1;
      "DISABLE" : clkc_en_sram[3] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute CLKC3_ENABLE on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", CLKC3_ENABLE);
        $finish;
      end
    endcase

    case (CLKC4_ENABLE)
      "ENABLE"  : clkc_en_sram[4] <= 1'b1;
      "DISABLE" : clkc_en_sram[4] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute CLKC4_ENABLE on pll instance %m is set to %s. legal values for this attribute are ENABLE or DISABLE.", CLKC4_ENABLE);
        $finish;
      end
    endcase

// omux
    case (ODIV_MUXC0)
      "DIV"     : clkc_omux_sram[0] <= 1'b1;
      "REFCLK"  : clkc_omux_sram[0] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute ODIV_MUXC0 on pll instance %m is set to %s. legal values for this attribute are DIV or REFCLK.", ODIV_MUXC0);
        $finish;
      end
    endcase

    case (ODIV_MUXC1)
      "DIV"     : clkc_omux_sram[1] <= 1'b1;
      "REFCLK"  : clkc_omux_sram[1] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute ODIV_MUXC1 on pll instance %m is set to %s. legal values for this attribute are DIV or REFCLK.", ODIV_MUXC1);
        $finish;
      end
    endcase

    case (ODIV_MUXC2)
      "DIV"     : clkc_omux_sram[2] <= 1'b1;
      "REFCLK"  : clkc_omux_sram[2] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute ODIV_MUXC2 on pll instance %m is set to %s. legal values for this attribute are DIV or REFCLK.", ODIV_MUXC2);
        $finish;
      end
    endcase

    case (ODIV_MUXC3)
      "DIV"     : clkc_omux_sram[3] <= 1'b1;
      "REFCLK"  : clkc_omux_sram[3] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute ODIV_MUXC3 on pll instance %m is set to %s. legal values for this attribute are DIV or REFCLK.", ODIV_MUXC3);
        $finish;
      end
    endcase

    case (ODIV_MUXC4)
      "DIV"     : clkc_omux_sram[4] <= 1'b1;
      "REFCLK"  : clkc_omux_sram[4] <= 1'b0;
      default   : begin
        $display("attribute syntax error : the attribute ODIV_MUXC4 on pll instance %m is set to %s. legal values for this attribute are DIV or REFCLK.", ODIV_MUXC4);
        $finish;
      end
    endcase
  end


    wire [4:0] enclkco = clkc_en_sram & enclkc;
    wire [4:0] clkc_fb = {divc4,divc3,divc2,divc1,divc0};
    wire [4:0] clkomux = clkc_omux_sram & clkc_fb | ~clkc_omux_sram & {4{refclk}};
  al_clko_premux xclko_premux_0 (.clko(clk_prediv[0]), .d({refclk,divc1,divc4,phc0}), .sd(prediv_mux0_sram[1:0]));
  al_clko_premux xclko_premux_1 (.clko(clk_prediv[1]), .d({refclk,divc2,divc0,phc1}), .sd(prediv_mux1_sram[1:0]));
  al_clko_premux xclko_premux_2 (.clko(clk_prediv[2]), .d({refclk,divc3,divc1,phc2}), .sd(prediv_mux2_sram[1:0]));
  al_clko_premux xclko_premux_3 (.clko(clk_prediv[3]), .d({refclk,divc4,divc2,phc3}), .sd(prediv_mux3_sram[1:0]));
  al_clko_premux xclko_premux_4 (.clko(clk_prediv[4]), .d({refclk,divc0,divc3,phc4}), .sd(prediv_mux4_sram[1:0]));
  al_clko_premux xclko_premux_ph7 (.clko(phase7), .d({refclk,1'b0,1'b0,ph7}), .sd({stdby,stdby}));


  always @(clk_prediv)  
  clk_prediv_delay <= #refclk_cycle  clk_prediv;  //delay one refclk cycle for align posedge of cout to  posedge of refclk


  al_pll_div128 xdivc0 (.out(divc0), .shot(load_reg[0]), .clk(clk_prediv[0]), .clk_dealy(clk_prediv_delay[0]), .rst_n(rstdiv0_n_sync));
  defparam xdivc0.DIV = CLKC0_DIV-1;
  defparam xdivc0.DIP = CLKC0_CPHASE-1;

  al_pll_div128 xdivc1 (.out(divc1), .shot(load_reg[1]), .clk(clk_prediv[1]), .clk_dealy(clk_prediv_delay[1]), .rst_n(rstdiv0_n_sync));
  defparam xdivc1.DIV = CLKC1_DIV-1;
  defparam xdivc1.DIP = CLKC1_CPHASE-1;

  al_pll_div128 xdivc2 (.out(divc2), .shot(load_reg[2]), .clk(clk_prediv[2]), .clk_dealy(clk_prediv_delay[2]), .rst_n(rstdiv2_n_sync));
  defparam xdivc2.DIV = CLKC2_DIV-1;
  defparam xdivc2.DIP = CLKC2_CPHASE-1;

  al_pll_div128 xdivc3 (.out(divc3), .shot(load_reg[3]), .clk(clk_prediv[3]), .clk_dealy(clk_prediv_delay[3]), .rst_n(rstdiv3_n_sync));
  defparam xdivc3.DIV = CLKC3_DIV-1;
  defparam xdivc3.DIP = CLKC3_CPHASE-1;

  al_pll_div128 xdivc4 (.out(divc4), .shot(load_reg[4]), .clk(clk_prediv[4]), .clk_dealy(clk_prediv_delay[4]), .rst_n(rstdiv3_n_sync));
  defparam xdivc4.DIV = CLKC4_DIV-1;
  defparam xdivc4.DIP = CLKC4_CPHASE-1;

  always @(posedge clkomux[0] or negedge rstdiv0_n_sync) begin
    if(!rstdiv0_n_sync)  clkoen_sync <= 1'b0;
    else clkoen_sync <= enclkco[0];
  end

  always @(posedge phase7 or negedge pllrst_n) begin
    if(!pllrst_n)  rstdiv0_n_sync <= 1'b0;
    else rstdiv0_n_sync <= pllrst_n;
  end

  wire rstdiv2_ni = pllrst_n & rstdiv2_n;
  always @(posedge phase7 or negedge rstdiv2_ni) begin
    if(!rstdiv2_ni)  rstdiv2_n_sync <= 1'b0;
    else rstdiv2_n_sync <= rstdiv2_ni;
  end

  wire rstdiv3_ni = pllrst_n & rstdiv3_n;
  always @(posedge phase7 or negedge rstdiv3_ni) begin
    if(!rstdiv3_ni)  rstdiv3_n_sync <= 1'b0;
    else rstdiv3_n_sync <= rstdiv3_ni;
  end

  wire sync2c0 = (SYNC_ENABLE == "ENABLE")? 1'b1 : 1'b0;
  al_clko_ctrl xclko_ctrl0 (.clko_en_o(clkoen[0]), .clko_en_i(enclkco[0]), .clko_en_sync(clkoen_sync),
                            .sync2c0(sync2c0), .clk(clkomux[0]), .rst_n(rstdiv0_n_sync));

  al_clko_ctrl xclko_ctrl1 (.clko_en_o(clkoen[1]), .clko_en_i(enclkco[1]), .clko_en_sync(clkoen_sync),
                            .sync2c0(sync2c0), .clk(clkomux[1]), .rst_n(rstdiv0_n_sync));

  al_clko_ctrl xclko_ctrl2 (.clko_en_o(clkoen[2]), .clko_en_i(enclkco[2]), .clko_en_sync(clkoen_sync),
                            .sync2c0(sync2c0), .clk(clkomux[2]), .rst_n(rstdiv0_n_sync));

  al_clko_ctrl xclko_ctrl3 (.clko_en_o(clkoen[3]), .clko_en_i(enclkco[3]), .clko_en_sync(clkoen_sync),
                            .sync2c0(sync2c0), .clk(clkomux[3]), .rst_n(rstdiv0_n_sync));

  al_clko_ctrl xclko_ctrl4 (.clko_en_o(clkoen[4]), .clko_en_i(enclkco[4]), .clko_en_sync(clkoen_sync),
                            .sync2c0(sync2c0), .clk(clkomux[4]), .rst_n(rstdiv0_n_sync));

  always @(posedge phase7 or negedge pllrst_n) begin
    if(!pllrst_n) lock_cnt <= 9'b0;
    else lock_cnt <= lock_cnt + 1;
  end

  always @(lock_cnt) begin
    case(PLL_LOCK_MODE)
      "0": begin ilock_rls <= &lock_cnt[6:0]; elock_rls <= &lock_cnt[7:0]; end
      "1": begin ilock_rls <= &lock_cnt[7:0]; elock_rls <= &lock_cnt[8:0]; end
      "2": begin ilock_rls <= &lock_cnt[8:0]; elock_rls <= &lock_cnt[9:0]; end
      default   : begin
        $display("attribute syntax error : the attribute PLL_LOCK_MODE on pll instance %m is set to %s. legal values for this attribute are 0 to 2.", PLL_LOCK_MODE);
        $finish;
      end
    endcase
  end

  always @(posedge phase7 or negedge pllrst_n) begin
    if(!pllrst_n) int_lock <= 1'b0;
    else if(ilock_rls) int_lock <= 1'b1;
  end

  always @(posedge phase7 or negedge pllrst_n) begin
    if(!pllrst_n) ext_lock <= 1'b0;
    else if(elock_rls) ext_lock <= 1'b1;
  end

  assign pll2io   = clkc[0] & en_pll2io;
  assign clkc = clkoen & clkomux;

  function  para_int_range_chk;
   input para_in; 
   input reg [160:0] para_name;
   input range_low;
   input range_high;

   integer para_in;
   integer range_low;
   integer  range_high;

   begin
        $display("******************** : The Attribute %s on pll instance %m is set to %d.  Legal values for this attribute are %d to %d.", para_name, para_in, range_low, range_high);
     if ( para_in < range_low || para_in > range_high) begin
        $display("Attribute Syntax Error : The Attribute %s on pll instance %m is set to %d.  Legal values for this attribute are %d to %d.", para_name, para_in, range_low, range_high);
        $finish;
     end
     para_int_range_chk = 1'b1;
   end
  endfunction

endmodule



// sub modules

module al_dphase_sel (clko, phdone, rotate, direct, phase, scanclk, rst_n);
  
  output clko;
  input  phdone, rotate, direct, scanclk, rst_n;
  input  [7:0] phase;
  
  reg [2:0] ph_init;
  reg [2:0] ph_sel;
  reg clko;

  initial begin
  #1;
  ph_sel = ph_init;
  end
  
  parameter PH_INIT_PARA = "0" ;
  
  initial begin    
    case(PH_INIT_PARA)
      "0" : ph_init     <= 3'b000;
      "1" : ph_init     <= 3'b001;
      "2" : ph_init     <= 3'b010;
      "3" : ph_init     <= 3'b011;
      "4" : ph_init     <= 3'b100;
      "5" : ph_init     <= 3'b101;
      "6" : ph_init     <= 3'b110;
      "7" : ph_init     <= 3'b111;
      default: ph_init  <= 3'b000;
    endcase
  end
  
  always @ (posedge scanclk or negedge rst_n) begin
    if(!rst_n) ph_sel <= ph_init;
    else if(rotate) begin
      if(direct) ph_sel <= ph_sel + 1;
      else ph_sel <= ph_sel - 1;
    end
  end

  always @(ph_sel or phase) begin
    case(ph_sel)
      3'b000: clko <= phase[0];
      3'b001: clko <= phase[1];
      3'b010: clko <= phase[2];
      3'b011: clko <= phase[3];
      3'b100: clko <= phase[4];
      3'b101: clko <= phase[5];
      3'b110: clko <= phase[6];
      3'b111: clko <= phase[7];
    endcase
  end
endmodule


module al_clko_premux (clko, d, sd);

  output clko;
  input [3:0] d;
  input [1:0] sd;

  reg clko;

  always @(sd or d) begin
    case (sd)
      2'b00: clko <= d[0];
      2'b01: clko <= d[1];
      2'b10: clko <= d[2];
      2'b11: clko <= d[3];
    endcase
  end

endmodule

module al_clko_ctrl (clko_en_o, clko_en_i, clko_en_sync, sync2c0, clk, rst_n);

  output clko_en_o;  // Synced
  input  clko_en_i;  // local
  input  clko_en_sync;  // clko_en of c0
  input  sync2c0, clk, rst_n;

  reg clko_en_o;
  
  wire clko_en = sync2c0? (clko_en_sync & clko_en_i) : clko_en_i;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)  clko_en_o <= 1'b0;
    else clko_en_o <= clko_en;
  end

endmodule


module al_pll_div128 (out, shot, clk, clk_dealy, rst_n);

output out;
input shot, clk, rst_n;
input clk_dealy;

reg [2:0] lsf_q;
reg rst_n_sync;
reg  [6:0] m_half;
reg [7:0] m_prd;

reg [7:0] count;
 
  parameter DIV = 7'b0000000;
  parameter DIP = 7'b0000000;

  wire lsf_rst_n = rst_n & ~shot;
  wire lsf_pls   = lsf_q[1] & ~lsf_q[0];
  wire [6:0] divp = lsf_pls? DIP:DIV;

  wire md = divp[0];

  always @ (negedge out or negedge lsf_rst_n) begin
    if(!lsf_rst_n) lsf_q <= 3'b0;
    else lsf_q <={1'b1, lsf_q[2:1]};
  end


 wire out=(count<=m_half); 

  initial begin
    m_half = 7'b0;
    rst_n_sync = 1'b1;
    count = 8'b0000_0000;
    m_prd = 8'b0000_0000;
  end 

 always @(negedge clk)
   #0.1 rst_n_sync <= rst_n;

 always @(posedge clk_dealy or negedge clk_dealy or negedge rst_n_sync)
   begin
     if(~rst_n_sync) begin
       count<=m_prd; m_half<=divp[6:0];
       m_prd <= divp*2+1;
      end
     else if(count==m_prd) begin
       count <=0; m_half<=divp[6:0];
       m_prd <= divp*2+1;
      end
     else count<=count+1;
  end

endmodule

