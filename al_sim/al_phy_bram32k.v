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
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module AL_PHY_BRAM32K ( 
  doa, dia, addra, bytea, cena, wena, clka, rsta, ocea,
  dob, dib, addrb, byteb, cenb, wenb, clkb, rstb, oceb
  );

output  [15:0] doa;
output  [15:0] dob;
input   [15:0] dia;
input   [15:0] dib;
input   [10:0] addra;
input   [10:0] addrb;
input   bytea; // port a byte mode, lowest address
input   byteb; // port b byte mode, lowest address
input   cena,wena; // 0 is valid
input   clka,rsta;
input   cenb,wenb; // 0 is valid
input   clkb,rstb;
input   ocea;  // port a output register ce input when REGMODE_A=="OUTREG"
input   oceb;  // port B output register ce input when REGMODE_B=="OUTREG"

tri1 	[15:0] dia;
tri1 	[15:0] dib;
tri1    cena, ocea, clka, wena;
tri1    cenb, oceb, clkb, wenb;
tri1  	rsta,rstb;         
tri1 	[10:0] addra;
tri1 	[10:0] addrb;
tri1 	bytea;
tri1 	byteb;


parameter MODE = "DP16K";               // 
parameter DATA_WIDTH_A = "16";          // 8, 16
parameter DATA_WIDTH_B = "16";          // 8, 16

parameter REGMODE_A = "NOREG";         // "NOREG", "OUTREG"
parameter REGMODE_B = "NOREG";         // "NOREG", "OUTREG"
parameter WRITEMODE_A = "NORMAL";      // "NORMAL", "WRITETHROUGH"
parameter WRITEMODE_B = "NORMAL";      // "NORMAL", "WRITETHROUGH"
parameter SRMODE = "SYNC";          // "SYNC", "ASYNC"

parameter CENAMUX = "SIG"; //0, 1, INV, SIG
parameter CENBMUX = "SIG"; //0, 1, INV, SIG
parameter OCEAMUX = "SIG"; //0, 1, INV, SIG
parameter OCEBMUX = "SIG"; //0, 1, INV, SIG
parameter RSTAMUX = "SIG"; //0, 1, INV, SIG
parameter RSTBMUX = "SIG"; //0, 1, INV, SIG
parameter CLKAMUX = "SIG"; //0, 1, INV, SIG
parameter CLKBMUX = "SIG"; //0, 1, INV, SIG
parameter WENAMUX = "SIG"; //0, 1, INV, SIG
parameter WENBMUX = "SIG"; //0, 1, INV, SIG
parameter READBACK = "OFF"; // ON, OFF

  reg rbyte1_reg_a,rbyte1_reg_b;
  wire asyncrst_a,asyncrst_b;
  wire syncrst_a,syncrst_b;
  reg [15:0] doa_reg, dob_reg;
  reg rd_reg_a, rd_reg_b; 
  reg bytemode_a, bytemode_b;
  reg oregmode_a, oregmode_b;
  reg syncrst;
         
  wire  bwena_odd;
  wire  bwena_even; 
  wire  [15:0]  BWENAMUX ;
  wire  bwenb_odd ;
  wire  bwenb_even;    
  wire  [15:0]  BWENBMUX;  
  reg [15:0] bramdi_a,bramdi_b;  
  wire [15:0] doa_tmp,dob_tmp;
  reg  CLKAMUX_int;
  reg  CLKBMUX_int;
  reg  CENAMUX_int;
  reg  CENBMUX_int;
  reg  WENAMUX_int;
  reg  WENBMUX_int;
  reg  OCEAMUX_int;
  reg  OCEBMUX_int;  
  reg  rsta_int;
  reg  rstb_int; 
  reg  f_wta;
  reg  f_wtb;
  localparam	Bits = 16;
  localparam	Word_Depth = 2048;
  localparam	Add_Width = 11;
  localparam    Wen_Width = 16;
  localparam    Word_Pt = 1;
  reg [Bits-1:0] 	QA_slip;
  reg [Bits-1:0] 	QB_slip; 
  wire [Bits-1:0] 	QA_int;
  wire [Bits-1:0] 	QB_int;
  wire [Add_Width-1:0] 	AA_int;
  wire [Add_Width-1:0] 	AB_int;

  wire [Wen_Width-1:0]  BWENAMUX_int;
  wire [Wen_Width-1:0]  BWENBMUX_int;
  wire [Bits-1:0] 	DA_int;
  wire [Bits-1:0] 	DB_int;

  reg  [Bits-1:0] 	QA_latched;
  reg  [Bits-1:0] 	QB_latched;
  reg  [Add_Width-1:0] 	AA_latched;
  reg  [Add_Width-1:0] 	AB_latched;
  reg  [Bits-1:0] 	DA_latched;
  reg  [Bits-1:0] 	DB_latched;
  reg                  	CENAMUX_latched;
  reg                  	CENBMUX_latched;
  reg                  	LAST_CLKAMUX;
  reg                  	LAST_CLKBMUX;
  reg                  	WENAMUX_latched;
  reg                  	WENBMUX_latched;
  reg [Wen_Width-1:0]  BWENAMUX_latched;
  reg [Wen_Width-1:0]  BWENBMUX_latched;

  reg [Bits-1:0]        data_tmpa;
  reg [Bits-1:0]        data_tmpb;
  reg [Bits-1:0] 	mem_array[Word_Depth-1:0];

  integer      i,j,wenn,lb,hb;
  integer      n;

   reg param_trig;
   initial begin
   param_trig=0;
   param_trig=1;
   end
 
   always @(param_trig)
   begin
        case (CENAMUX)
            "SIG"   	: assign CENAMUX_int = cena;
            "0" 	: assign CENAMUX_int = 0;
            "1" 	: assign CENAMUX_int = 1;
            "INV"   	: assign CENAMUX_int = ~cena;
            default 	: assign CENAMUX_int = 1;
        endcase

        case (CENBMUX)
            "SIG"   	: assign CENBMUX_int = cenb;
            "0" 	: assign CENBMUX_int = 0;
            "1" 	: assign CENBMUX_int = 1;
            "INV"   	: assign CENBMUX_int = ~cenb;
            default 	: assign CENBMUX_int = 1;
        endcase

        case (WENAMUX)
            "SIG"   	: assign WENAMUX_int = wena;
            "0" 	: assign WENAMUX_int = 0;
            "1" 	: assign WENAMUX_int = 1;
            "INV"   	: assign WENAMUX_int = ~wena;
            default 	: assign WENAMUX_int = 1;
        endcase

        case (WENBMUX)
            "SIG"   	: assign WENBMUX_int = wenb;
            "0" 	: assign WENBMUX_int = 0;
            "1" 	: assign WENBMUX_int = 1;
            "INV"   	: assign WENBMUX_int = ~wenb;
            default 	: assign WENBMUX_int = 1;
        endcase

        case (OCEAMUX)
            "SIG"   	: assign OCEAMUX_int = ocea;
            "0" 	: assign OCEAMUX_int = 0;
            "1" 	: assign OCEAMUX_int = 1;
            "INV"   	: assign OCEAMUX_int = ~ocea;
            default 	: assign OCEAMUX_int = 1;
        endcase

        case (OCEBMUX)
            "SIG"   	: assign OCEBMUX_int = oceb;
            "0" 	: assign OCEBMUX_int = 0;
            "1" 	: assign OCEBMUX_int = 1;
            "INV"   	: assign OCEBMUX_int = ~oceb;
            default 	: assign OCEBMUX_int = 1;
        endcase


        case (RSTAMUX)
            "SIG"   	: assign rsta_int = rsta;
            "0" 	: assign rsta_int = 0;
            "1" 	: assign rsta_int = 1;
            "INV"   	: assign rsta_int = ~rsta;
            default 	: assign rsta_int = 1;
        endcase

        case (RSTBMUX)
            "SIG"   	: assign rstb_int = rstb;
            "0" 	: assign rstb_int = 0;
            "1" 	: assign rstb_int = 1;
            "INV"   	: assign rstb_int = ~rstb;
            default 	: assign rstb_int = 1;
        endcase

        case (CLKAMUX)
            "SIG"   	: assign CLKAMUX_int = clka;
            "0" 	: assign CLKAMUX_int = 0;
            "1" 	: assign CLKAMUX_int = 1;
            "INV"   	: assign CLKAMUX_int = ~clka;
            default 	: assign CLKAMUX_int = 1;
        endcase

        case (CLKBMUX)
            "SIG"   	: assign CLKBMUX_int = clkb;
            "0" 	: assign CLKBMUX_int = 0;
            "1" 	: assign CLKBMUX_int = 1;
            "INV"   	: assign CLKBMUX_int = ~clkb;
            default 	: assign CLKBMUX_int = 1;
        endcase


    end
    
    
   initial 
   begin
   rbyte1_reg_a=0;
   rbyte1_reg_b=0;
   doa_reg=0;
   dob_reg=0;
   rd_reg_a=1;
   rd_reg_b=1;   
   case(DATA_WIDTH_A)
    "8" :  bytemode_a = 1;
    "16" : bytemode_a = 0;
    default : bytemode_a = 0;                   
   endcase
   case(DATA_WIDTH_B)
    "8" :  bytemode_b = 1;
    "16" : bytemode_b = 0;
    default : bytemode_b = 0;                   
   endcase
   case(REGMODE_A)
    "OUTREG": oregmode_a = 1;
    "NOREG" : oregmode_a = 0;
    default : oregmode_a = 0;
   endcase
   case(REGMODE_B)
    "OUTREG": oregmode_b = 1;
    "NOREG" : oregmode_b = 0;
    default : oregmode_b = 0;
   endcase 
   case(SRMODE)
    "SYNC":   syncrst = 1;
    "ASYNC" : syncrst = 0;
    default : syncrst = 1;
   endcase    
   case(WRITEMODE_A)
    "NORMAL":   f_wta = 0;
    "WRITETHROUGH" : f_wta = 1;
    default : f_wta = 0;
   endcase    
   case(WRITEMODE_B)
    "NORMAL":   f_wtb = 0;
    "WRITETHROUGH" : f_wtb = 1;
    default : f_wtb = 0;
   endcase    
   end
   
  assign asyncrst_a= rsta_int & !syncrst;
  assign asyncrst_b= rstb_int & !syncrst;
  assign syncrst_a= rsta_int & syncrst;
  assign syncrst_b= rstb_int & syncrst; 
//  assign bramdi_a[7:0] = dia[7:0];
//  assign bramdi_a[15:8]= bytemode_a ? dia[7:0] : dia[15:8] ;
//  assign bramdi_b[7:0] = dib[7:0];
//  assign bramdi_b[15:8]= bytemode_b ? dib[7:0] : dib[15:8] ; 
  
  always @(dia or bytemode_a)
  begin
//    genvar i;
//    generate
      for(i=0; i<8; i=i+1)
      begin
       bramdi_a[2*i]=dia[i];
       if(bytemode_a)
           bramdi_a[2*i+1]=dia[i];
       else
           bramdi_a[2*i+1]=dia[i+8];   
      end      
  end
  always @(dib or bytemode_b)
  begin
//    genvar i;
//    generate
      for(i=0; i<8; i=i+1)
      begin
       bramdi_b[2*i]=dib[i];
       if(bytemode_b)
           bramdi_b[2*i+1]=dib[i];
       else
           bramdi_b[2*i+1]=dib[i+8];   
      end      
  end  
  
  
  assign  bwena_odd = !((!WENAMUX_int) & !(bytemode_a & !bytea));
  assign  bwena_even= !((!WENAMUX_int) & !(bytemode_a & bytea)); 
  assign  BWENAMUX = {8{bwena_odd,bwena_even}};
  assign  bwenb_odd = !((!WENBMUX_int) & !(bytemode_b & !byteb));
  assign  bwenb_even= !((!WENBMUX_int) & !(bytemode_b & byteb));    
  assign  BWENBMUX = {8{bwenb_odd,bwenb_even}};    

  buf bwena_buf[Wen_Width-1:0] (BWENAMUX_int, BWENAMUX);
  buf bwenb_buf[Wen_Width-1:0] (BWENBMUX_int, BWENBMUX);
  buf aa_buf[Add_Width-1:0] (AA_int, addra);
  buf ab_buf[Add_Width-1:0] (AB_int, addrb);
  buf da_buf[Bits-1:0] (DA_int, bramdi_a);   
  buf db_buf[Bits-1:0] (DB_int, bramdi_b);   

  
  assign QA_int=QA_latched;
  assign QB_int=QB_latched;
  
  wire    clkconfA_flag;
  wire    clkconfB_flag;
  wire    clkconf_flag;
  assign clkconfA_flag=(AA_int===AB_latched) && (CENAMUX_int!==1'b1) && (CENBMUX_latched!==1'b1);
  assign clkconfB_flag=(AB_int===AA_latched) && (CENBMUX_int!==1'b1) && (CENAMUX_latched!==1'b1);
  assign clkconf_flag=(AA_int===AB_int) && (CENAMUX_int!==1'b1) && (CENBMUX_int!==1'b1);


  
   always @(CLKAMUX_int)
    begin
      casez({LAST_CLKAMUX, CLKAMUX_int})
        2'b01: begin
          CENAMUX_latched = CENAMUX_int;
          WENAMUX_latched = WENAMUX_int;
          BWENAMUX_latched = BWENAMUX_int;
          AA_latched = AA_int;
          DA_latched = DA_int;
          rw_memA;
        end
        2'b10,
        2'bx?,
        2'b00,
        2'b11: ;
        2'b?x: begin
	  for(i=0;i<Word_Depth;i=i+1)
    	    mem_array[i]={Bits{1'bx}};
    	  QA_latched={Bits{1'bx}};
          rw_memA;
          end
      endcase
    LAST_CLKAMUX=CLKAMUX_int;
   end

always @(CLKBMUX_int)
    begin
      casez({LAST_CLKBMUX, CLKBMUX_int})
        2'b01: begin
          CENBMUX_latched = CENBMUX_int;
          WENBMUX_latched = WENBMUX_int;
          BWENBMUX_latched = BWENBMUX_int;
          AB_latched = AB_int;
          DB_latched = DB_int;
          rw_memB;
        end
        2'b10,
        2'bx?,
        2'b00,
        2'b11: ;
        2'b?x: begin
          for(i=0;i<Word_Depth;i=i+1)
    	    mem_array[i]={Bits{1'bx}};
	    QB_latched={Bits{1'bx}};
            rw_memA;
          end
      endcase
    LAST_CLKBMUX=CLKBMUX_int;
   end


   always @(posedge CLKAMUX_int)
   begin
      if (CENAMUX_int == 0)
         rbyte1_reg_a <= bytea & bytemode_a;
   end
   always @(posedge CLKBMUX_int)
   begin
      if (CENBMUX_int == 0)
         rbyte1_reg_b <= byteb & bytemode_b;
   end
   always @(posedge CLKAMUX_int)
   begin
      if (CENAMUX_int == 0)
         rd_reg_a <= WENAMUX_int;
   end
   always @(posedge CLKBMUX_int)
   begin
      if (CENBMUX_int == 0)
         rd_reg_b <= WENBMUX_int;
   end   

   wire oprcea = (oregmode_a ? OCEAMUX_int : rd_reg_a) & (rd_reg_a|f_wta);
   wire oprceb = (oregmode_b ? OCEBMUX_int : rd_reg_b) & (rd_reg_b|f_wtb);
   wire osela = (rd_reg_a|f_wta) & !oregmode_a;
   wire oselb = (rd_reg_b|f_wtb) & !oregmode_b;
   

   
   always @(QA_int)
   begin
//    genvar i;
//    generate
      for(i=0; i<8; i=i+1)
      begin
       QA_slip[i]=QA_int[2*i];
       QA_slip[i+8]=QA_int[2*i+1];
      end      
   end

   always @(QB_int)
   begin
//    genvar i;
//    generate
      for(i=0; i<8; i=i+1)
      begin
       QB_slip[i]=QB_int[2*i];
       QB_slip[i+8]=QB_int[2*i+1];
      end      
   end
      
   always @(posedge asyncrst_a or posedge CLKAMUX_int)
   begin
      
      if (asyncrst_a == 1)
         doa_reg <= 0;
      else
      begin
         if (oprcea)
            begin
               if(syncrst_a) doa_reg <= 0;
               else
                    doa_reg[15:0] <= doa_tmp[15:0];               
            end
	 else
	   doa_reg <= doa_reg ;
      end
   end



   always @(posedge asyncrst_b or posedge CLKBMUX_int)
   begin
      if (asyncrst_b == 1)
         dob_reg <= 0;
      else
      begin
         if (oprceb)
            begin
               if(syncrst_b) dob_reg <= 0;
               else
               dob_reg[15:0] <= dob_tmp[15:0];                
            end
         else
            dob_reg <= dob_reg ;
      end
   end
   
   assign doa_tmp[15:8]  = {8{(!bytemode_a)}} & QA_slip[15:8];
   assign doa_tmp[7:0] =  rbyte1_reg_a ? QA_slip[15:8] : QA_slip[7:0] ;  

   assign dob_tmp[15:8]  = {8{(!bytemode_b)}} & QB_slip[15:8];
   assign dob_tmp[7:0] =  rbyte1_reg_b ? QB_slip[15:8] : QB_slip[7:0] ;     
   
   assign doa = osela ? doa_tmp : doa_reg;   
   assign dob = oselb ? dob_tmp : dob_reg;
   
  task rw_memA;
    begin
      if(CENAMUX_latched==1'b0)
        begin
          if (WENAMUX_latched==1'b1)
            begin
              if(^(AA_latched)==1'bx)
                QA_latched={Bits{1'bx}};
              else
                QA_latched=mem_array[AA_latched];
            end
          else if (WENAMUX_latched==1'b0)
          begin
            for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
              begin
                lb=wenn*Word_Pt;
                if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                else hb=lb+Word_Pt-1;
                if (BWENAMUX_latched[wenn]==1'b1)
                  begin
                    if(^(AA_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) QA_latched[i]=1'bx;
                    else
                      begin
                      data_tmpa=mem_array[AA_latched];
                      for (i=lb; i<=hb; i=i+1) QA_latched[i]=data_tmpa[i];
                      end
                  end
                else if (BWENAMUX_latched[wenn]==1'b0)
                  begin
                    if (^(AA_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpa=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpa[j]=1'bx;
                            mem_array[i]=data_tmpa;
                          end
                        for (i=lb; i<=hb; i=i+1) QA_latched[i]=1'bx;
                      end
                    else
                      begin
                        data_tmpa=mem_array[AA_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpa[i]=DA_latched[i];
                        mem_array[AA_latched]=data_tmpa;
                        for (i=lb; i<=hb; i=i+1) QA_latched[i]=data_tmpa[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) QA_latched[i]=1'bx;
                    if (^(AA_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpa=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpa[j]=1'bx;
                            mem_array[i]=data_tmpa;
                          end
                      end
                    else
                      begin
                        data_tmpa=mem_array[AA_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpa[i]=1'bx;
                        mem_array[AA_latched]=data_tmpa;
                      end
                 end
               end
             end
           else
             begin
               for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
               begin
                 lb=wenn*Word_Pt;
                 if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                 else hb=lb+Word_Pt-1;
                 if (BWENAMUX_latched[wenn]==1'b1)
                  begin
                    if(^(AA_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) QA_latched[i]=1'bx;
                    else
                      begin
                      data_tmpa=mem_array[AA_latched];
                      for (i=lb; i<=hb; i=i+1) QA_latched[i]=data_tmpa[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) QA_latched[i]=1'bx;
                    if (^(AA_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpa=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpa[j]=1'bx;
                            mem_array[i]=data_tmpa;
                          end
                      end
                    else
                      begin
                        data_tmpa=mem_array[AA_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpa[i]=1'bx;
                        mem_array[AA_latched]=data_tmpa;
                      end
                 end
               end
             end
           end
         else if (CENAMUX_latched==1'bx)
           begin
             for (wenn=0;wenn<Wen_Width;wenn=wenn+1)
            begin
              lb=wenn*Word_Pt;
              if ((lb+Word_Pt)>=Bits) hb=Bits-1;
              else hb=lb+Word_Pt-1;
              if(WENAMUX_latched==1'b1 || BWENAMUX_latched[wenn]==1'b1)
                for (i=lb;i<=hb;i=i+1) QA_latched[i]=1'bx;
              else
                begin
                  for (i=lb;i<=hb;i=i+1) QA_latched[i]=1'bx;
                  if(^(AA_latched)==1'bx)
                    begin
                      for (i=0;i<Word_Depth;i=i+1)
                        begin
                          data_tmpa=mem_array[i];
                          for (j=lb;j<=hb;j=j+1) data_tmpa[j]=1'bx;
                          mem_array[i]=data_tmpa;
                        end
                    end
                  else
                    begin
                      data_tmpa=mem_array[AA_latched];
                      for (i=lb;i<=hb;i=i+1) data_tmpa[i]=1'bx;
                      mem_array[AA_latched]=data_tmpa;
                    end
                end
            end
        end
    end
  endtask
  
task rw_memB;
    begin
      if(CENBMUX_latched==1'b0)
        begin
          if (WENBMUX_latched==1'b1)
            begin
              if(^(AB_latched)==1'bx)
                QB_latched={Bits{1'bx}};
              else
                QB_latched=mem_array[AB_latched];
            end
          else if (WENBMUX_latched==1'b0)
          begin
            for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
              begin
                lb=wenn*Word_Pt;
                if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                else hb=lb+Word_Pt-1;
                if (BWENBMUX_latched[wenn]==1'b1)
                  begin
                    if(^(AB_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) QB_latched[i]=1'bx;
                    else
                      begin
                      data_tmpb=mem_array[AB_latched];
                      for (i=lb; i<=hb; i=i+1) QB_latched[i]=data_tmpb[i];
                      end
                  end
                else if (BWENBMUX_latched[wenn]==1'b0)
                  begin
                    if (^(AB_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpb=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpb[j]=1'bx;
                            mem_array[i]=data_tmpb;
                          end
                        for (i=lb; i<=hb; i=i+1) QB_latched[i]=1'bx;
                      end
                    else
                      begin
                        data_tmpb=mem_array[AB_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpb[i]=DB_latched[i];
                        mem_array[AB_latched]=data_tmpb;
                        for (i=lb; i<=hb; i=i+1) QB_latched[i]=data_tmpb[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) QB_latched[i]=1'bx;
                    if (^(AB_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpb=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpb[j]=1'bx;
                            mem_array[i]=data_tmpb;
                          end
                      end
                    else
                      begin
                        data_tmpb=mem_array[AB_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpb[i]=1'bx;
                        mem_array[AB_latched]=data_tmpb;
                      end
                 end
               end
             end
           else
             begin
               for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
               begin
                 lb=wenn*Word_Pt;
                 if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                 else hb=lb+Word_Pt-1;
                 if (BWENBMUX_latched[wenn]==1'b1)
                  begin
                    if(^(AB_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) QB_latched[i]=1'bx;
                    else
                      begin
                      data_tmpb=mem_array[AB_latched];
                      for (i=lb; i<=hb; i=i+1) QB_latched[i]=data_tmpb[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) QB_latched[i]=1'bx;
                    if (^(AB_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpb=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpb[j]=1'bx;
                            mem_array[i]=data_tmpb;
                          end
                      end
                    else
                      begin
                        data_tmpb=mem_array[AB_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpb[i]=1'bx;
                        mem_array[AB_latched]=data_tmpb;
                      end
                 end
               end
             end
           end
         else if (CENBMUX_latched==1'bx)
           begin
             for (wenn=0;wenn<Wen_Width;wenn=wenn+1)
            begin
              lb=wenn*Word_Pt;
              if ((lb+Word_Pt)>=Bits) hb=Bits-1;
              else hb=lb+Word_Pt-1;
              if(WENBMUX_latched==1'b1 || BWENBMUX_latched[wenn]==1'b1)
                for (i=lb;i<=hb;i=i+1) QB_latched[i]=1'bx;
              else
                begin
                  for (i=lb;i<=hb;i=i+1) QB_latched[i]=1'bx;
                  if(^(AB_latched)==1'bx)
                    begin
                      for (i=0;i<Word_Depth;i=i+1)
                        begin
                          data_tmpb=mem_array[i];
                          for (j=lb;j<=hb;j=j+1) data_tmpb[j]=1'bx;
                          mem_array[i]=data_tmpb;
                        end
                    end
                  else
                    begin
                      data_tmpb=mem_array[AB_latched];
                      for (i=lb;i<=hb;i=i+1) data_tmpb[i]=1'bx;
                      mem_array[AB_latched]=data_tmpb;
                    end
                end
            end
        end
    end
  endtask

   task x_mem;
   begin
     for(i=0;i<Word_Depth;i=i+1)
     mem_array[i]={Bits{1'bx}};
   end
   endtask

endmodule

