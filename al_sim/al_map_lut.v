///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011-2021 Anlogic, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//
//   Vendor : Anlogic
//   Version : 0.1
//   Description : Anlogic Functional Simulation Library Component
//              lut1 lut2 lut3 lut4 lut5 lut6
//   Filename : al_map_lut.v
//   Timestamp : Mon Nov  4 14:20:41 CST 2013
//
///////////////////////////////////////////////////////////////////////////////
//
// Revision:
//    11/04/13 - Initial version.
//
///////////////////////////////////////////////////////////////////////////////

`timescale  1 ps / 1 ps

// Note: EQN parameter is not used in describing the behavior.
// Only to suppress the warning in compiling map.v

module AL_MAP_LUT1 (o, a);

    parameter EQN = "(A)";

    parameter INIT = 2'h0;

    input a;

    output o;
    
    wire o;

    assign o = (INIT[0] == INIT[1]) ? INIT[0] : INIT[a];

endmodule


module AL_MAP_LUT2 (o, a, b);

    parameter EQN = "(A)";

    parameter INIT = 4'h0;

    input a, b;

    output o;

    reg  o;
    wire [1:0] s;

    assign s = {b, a};

    always @(s)
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           o = INIT[s];
         else if ((INIT[0] == INIT[1]) && (INIT[2] == INIT[3]) && (INIT[0] == INIT[2])) 
           o = INIT[0];
         else if ((s[1] == 0) && (INIT[0] == INIT[1]))
           o = INIT[0];
         else if ((s[1] == 1) && (INIT[2] == INIT[3])) 
           o = INIT[2];
         else if ((s[0] == 0) && (INIT[0] == INIT[2])) 
           o = INIT[0];
         else if ((s[0] == 1) && (INIT[1] == INIT[3]))
           o = INIT[1];
         else
           o = 1'bx;
endmodule


module AL_MAP_LUT3 (o, a, b, c);

    parameter EQN = "(A)";

    parameter INIT = 8'h00;

    input a, b, c;

    output o;

    reg o;
    reg tmp;
  
    always @(  c or  b or  a )  begin
      tmp =  a ^ b  ^ c;
      if ( tmp == 0 || tmp == 1)
           o = INIT[{c, b, a}];
      else
           o = lut3_mux4 ( {1'b0, 1'b0, lut3_mux4 (INIT[7:4], {b, a}),
                          lut3_mux4 (INIT[3:0], {b, a}) }, {1'b0, c});
    end

  function lut3_mux4;
  input [3:0] d;
  input [1:0] s;

  begin
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           lut3_mux4 = d[s];
         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut3_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3]))
           lut3_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut3_mux4 = d[1];
         else
           lut3_mux4 = 1'bx;
   end
   endfunction

endmodule


module AL_MAP_LUT4 (o, a, b, c, d);

    parameter EQN = "(A)";

  parameter INIT = 16'h0000;

  input a, b, c, d;

  output o;

  reg o;
  reg tmp;

  always @(  d or  c or  b or  a )  begin
 
    tmp =  a ^ b  ^ c ^ d;

    if ( tmp == 0 || tmp == 1)

        o = INIT[{d, c, b, a}];

    else 
    
      o =  lut4_mux4 ( {lut4_mux4 ( INIT[15:12], {b, a}),
                          lut4_mux4 ( INIT[11:8], {b, a}),
                          lut4_mux4 ( INIT[7:4], {b, a}),
                          lut4_mux4 ( INIT[3:0], {b, a}) }, {d, c});
  end

  function lut4_mux4;
  input [3:0] d;
  input [1:0] s;
   
  begin

       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           
           lut4_mux4 = d[s];

         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2])) 
           lut4_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut4_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3])) 
           lut4_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2])) 
           lut4_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut4_mux4 = d[1];
         else
           lut4_mux4 = 1'bx;
   end
  endfunction

endmodule


module AL_MAP_LUT5 (o, a, b, c, d, e);

    parameter EQN = "(A)";

  parameter INIT = 32'h00000000;
  parameter LOC = "UNPLACED";

  output o;
  input a, b, c, d, e;

  wire a0, a1, a2, a3, a4;
  wire o_out_tmp;

  buf b0 (a0, a);
  buf b1 (a1, b);
  buf b2 (a2, c);
  buf b3 (a3, d);
  buf b4 (a4, e);
  buf b5 (o, o_out_tmp);

  reg o_out;
  reg tmp;

  assign o_out_tmp= o_out;

  always @( a4 or a3 or  a2 or  a1 or  a0 )  begin

    tmp =  a0 ^ a1  ^ a2 ^ a3 ^ a4;

    if ( tmp == 0 || tmp == 1)

        o_out = INIT[{a4, a3, a2, a1, a0}];

    else

      o_out =  lut4_mux4 (
                        { lut6_mux8 ( INIT[31:24], {a2, a1, a0}),
                          lut6_mux8 ( INIT[23:16], {a2, a1, a0}),
                          lut6_mux8 ( INIT[15:8], {a2, a1, a0}),
                          lut6_mux8 ( INIT[7:0], {a2, a1, a0}) }, { a4, a3});
  end


  specify

	(a => o) = (0:0:0, 0:0:0);
	(b => o) = (0:0:0, 0:0:0);
	(c => o) = (0:0:0, 0:0:0);
	(d => o) = (0:0:0, 0:0:0);
	(e => o) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify


  function lut6_mux8;
  input [7:0] d;
  input [2:0] s;
   
  begin

       if ((s[2]^s[1]^s[0] ==1) || (s[2]^s[1]^s[0] ==0))
           
           lut6_mux8 = d[s];

         else
           if ( ~(|d))
                 lut6_mux8 = 1'b0;
           else if ((&d))
                 lut6_mux8 = 1'b1;
           else if (((s[1]^s[0] ==1'b1) || (s[1]^s[0] ==1'b0)) && (d[{1'b0,s[1:0]}]==d[{1'b1,s[1:0]}]))
                 lut6_mux8 = d[{1'b0,s[1:0]}];
           else if (((s[2]^s[0] ==1) || (s[2]^s[0] ==0)) && (d[{s[2],1'b0,s[0]}]==d[{s[2],1'b1,s[0]}]))
                 lut6_mux8 = d[{s[2],1'b0,s[0]}];
           else if (((s[2]^s[1] ==1) || (s[2]^s[1] ==0)) && (d[{s[2],s[1],1'b0}]==d[{s[2],s[1],1'b1}]))
                 lut6_mux8 = d[{s[2],s[1],1'b0}];
           else if (((s[0] ==1) || (s[0] ==0)) && (d[{1'b0,1'b0,s[0]}]==d[{1'b0,1'b1,s[0]}]) &&
              (d[{1'b0,1'b0,s[0]}]==d[{1'b1,1'b0,s[0]}]) && (d[{1'b0,1'b0,s[0]}]==d[{1'b1,1'b1,s[0]}]))
                 lut6_mux8 = d[{1'b0,1'b0,s[0]}];
           else if (((s[1] ==1) || (s[1] ==0)) && (d[{1'b0,s[1],1'b0}]==d[{1'b0,s[1],1'b1}]) &&
              (d[{1'b0,s[1],1'b0}]==d[{1'b1,s[1],1'b0}]) && (d[{1'b0,s[1],1'b0}]==d[{1'b1,s[1],1'b1}]))
                 lut6_mux8 = d[{1'b0,s[1],1'b0}];
           else if (((s[2] ==1) || (s[2] ==0)) && (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b0,1'b1}]) &&
              (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b1,1'b0}]) && (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b1,1'b1}]))
                 lut6_mux8 = d[{s[2],1'b0,1'b0}];
           else
                 lut6_mux8 = 1'bx;
   end
  endfunction


  function lut4_mux4;
  input [3:0] d;
  input [1:0] s;
   
  begin

       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))

           lut4_mux4 = d[s];

         else if ((d[0] ^ d[1]) == 0 && (d[2] ^ d[3]) == 0 && (d[0] ^ d[2]) == 0)
           lut4_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] == d[1]))
           lut4_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] == d[3]))
           lut4_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] == d[2]))
           lut4_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] == d[3]))
           lut4_mux4 = d[1];
         else
           lut4_mux4 = 1'bx;

   end
  endfunction

endmodule


module AL_MAP_LUT6 (o, a, b, c, d, e, f);

    parameter EQN = "(A)";

  parameter INIT = 64'h0000000000000000;

  input a, b, c, d, e, f;

  output o;

  reg o;
  reg tmp;

  always @( f or e or d or  c or  b or  a )  begin
 
    tmp =  a ^ b  ^ c ^ d ^ e ^ f;

    if ( tmp == 0 || tmp == 1)

        o = INIT[{f, e, d, c, b, a}];

    else 
    
      o =  lut6_mux8 ( {lut6_mux8 ( INIT[63:56], {c, b, a}),
                          lut6_mux8 ( INIT[55:48], {c, b, a}),
                          lut6_mux8 ( INIT[47:40], {c, b, a}),
                          lut6_mux8 ( INIT[39:32], {c, b, a}),
                          lut6_mux8 ( INIT[31:24], {c, b, a}),
                          lut6_mux8 ( INIT[23:16], {c, b, a}),
                          lut6_mux8 ( INIT[15:8], {c, b, a}),
                          lut6_mux8 ( INIT[7:0], {c, b, a}) }, {f, e, d});
  end

  function lut6_mux8;
  input [7:0] d;
  input [2:0] s;
   
  begin

   if ((s[2]^s[1]^s[0] ==1) || (s[2]^s[1]^s[0] ==0))
           
       lut6_mux8 = d[s];

     else
       if ( ~(|d))
             lut6_mux8 = 1'b0;
       else if ((&d))
             lut6_mux8 = 1'b1;
       else if (((s[1]^s[0] ==1'b1) || (s[1]^s[0] ==1'b0)) && (d[{1'b0,s[1:0]}]==d[{1'b1,s[1:0]}]))
             lut6_mux8 = d[{1'b0,s[1:0]}];
       else if (((s[2]^s[0] ==1) || (s[2]^s[0] ==0)) && (d[{s[2],1'b0,s[0]}]==d[{s[2],1'b1,s[0]}]))
             lut6_mux8 = d[{s[2],1'b0,s[0]}];
       else if (((s[2]^s[1] ==1) || (s[2]^s[1] ==0)) && (d[{s[2],s[1],1'b0}]==d[{s[2],s[1],1'b1}]))
             lut6_mux8 = d[{s[2],s[1],1'b0}];
       else if (((s[0] ==1) || (s[0] ==0)) && (d[{1'b0,1'b0,s[0]}]==d[{1'b0,1'b1,s[0]}]) &&
          (d[{1'b0,1'b0,s[0]}]==d[{1'b1,1'b0,s[0]}]) && (d[{1'b0,1'b0,s[0]}]==d[{1'b1,1'b1,s[0]}]))
             lut6_mux8 = d[{1'b0,1'b0,s[0]}];
       else if (((s[1] ==1) || (s[1] ==0)) && (d[{1'b0,s[1],1'b0}]==d[{1'b0,s[1],1'b1}]) &&
          (d[{1'b0,s[1],1'b0}]==d[{1'b1,s[1],1'b0}]) && (d[{1'b0,s[1],1'b0}]==d[{1'b1,s[1],1'b1}]))
             lut6_mux8 = d[{1'b0,s[1],1'b0}];
       else if (((s[2] ==1) || (s[2] ==0)) && (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b0,1'b1}]) &&
          (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b1,1'b0}]) && (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b1,1'b1}]))
             lut6_mux8 = d[{s[2],1'b0,1'b0}];
       else
             lut6_mux8 = 1'bx;
   end
  endfunction

endmodule

