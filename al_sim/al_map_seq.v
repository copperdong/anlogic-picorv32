///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//               seq
//   Filename : al_map_seq.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////
module AL_MAP_SEQ (ce, clk, sr, d, q);
input ce, clk, sr, d;
output q;


tri1 ce;
tri0 d,sr,clk;

reg q, q_reg, q_latch;
reg INIT = 1'b0;

tri0 gsrn = glbl.gsrn;
wire gsr = ~gsrn;
always @(gsrn) 
  begin
    if (!gsrn) 
      assign q = INIT;
    else 
      deassign q;
  end

parameter DFFMODE = "FF"; //FF,LATCH
parameter REGSET = "RESET"; //RESET/SET
parameter SRMUX = "SR"; //SR/INV
parameter SRMODE = "SYNC"; //SYNC/ASYNC
parameter INI = "0"; //1(SET)/0(RESET)


reg sr_s,sr_a;

always @(*) begin
  case (INI)
    "1"        : INIT = 1'b1;
    "0"        : INIT = 1'b0;
    default     : INIT = 1'b0;
  endcase

  case (SRMUX)
    "SR"       : sr_s = sr;
    "INV"      : sr_s = ~sr;
    default     : sr_s = sr;
  endcase

  case (REGSET)
    "SET"      : INIT = 1'b1;
    "RESET"    : INIT = 1'b0;
    default     : INIT = 1'b0;
  endcase

  case (SRMODE)
    "SYNC"     :   sr_a = gsr;
    "ASYNC"    :   sr_a = gsr | sr_s;
     default    :   sr_a = gsr;
  endcase

  case (DFFMODE)
    "FF"      : begin
                     q <= q_reg;
                end
    "LATCH"   : begin
                     q <= q_latch;
                end
    default    : begin
                     q <= q_reg;
                  end
  endcase

end

assign clk_c = ce ? clk : 1'b0; 

always @(posedge clk_c or posedge sr_a) begin
  if (sr_a || sr_s)
    q_reg <= INIT;
  else
    q_reg <= d;
end

always @(clk_c or sr_a) begin
  if (sr_a || sr_s)
    q_latch <= INIT;
  else
    q_latch <= d;
end
   

endmodule

