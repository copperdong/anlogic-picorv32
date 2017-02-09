// Verilog netlist created by TD v3.0.987
// Thu Feb  9 15:02:51 2017

module regfile_dp  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(14)
  (
  addra,
  addrb,
  cea,
  ceb,
  clka,
  clkb,
  dia,
  dib,
  rsta,
  rstb,
  wea,
  web,
  doa,
  dob
  );

  input [4:0] addra;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(25)
  input [4:0] addrb;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(26)
  input cea;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(27)
  input ceb;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(28)
  input clka;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(29)
  input clkb;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(30)
  input [31:0] dia;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(23)
  input [31:0] dib;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(24)
  input rsta;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(33)
  input rstb;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(34)
  input wea;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(31)
  input web;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(32)
  output [31:0] doa;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(19)
  output [31:0] dob;  // /home/rgwan/anlogic/picorv32_demo/al_ip/regfile.v(20)


  AL_PHY_BRAM #(
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .MODE("DP8K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    inst_sub_000000_000_32_9 (
    .addra({5'b00000,addra,3'b111}),
    .addrb({5'b00000,addrb,3'b111}),
    .cea(cea),
    .ceb(ceb),
    .clka(clka),
    .clkb(clkb),
    .dia(dia[8:0]),
    .dib(dib[8:0]),
    .rsta(rsta),
    .rstb(rstb),
    .wea(wea),
    .web(web),
    .doa(doa[8:0]),
    .dob(dob[8:0]));
  AL_PHY_BRAM #(
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .MODE("DP8K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    inst_sub_000000_009_32_9 (
    .addra({5'b00000,addra,3'b111}),
    .addrb({5'b00000,addrb,3'b111}),
    .cea(cea),
    .ceb(ceb),
    .clka(clka),
    .clkb(clkb),
    .dia(dia[17:9]),
    .dib(dib[17:9]),
    .rsta(rsta),
    .rstb(rstb),
    .wea(wea),
    .web(web),
    .doa(doa[17:9]),
    .dob(dob[17:9]));
  AL_PHY_BRAM #(
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .MODE("DP8K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    inst_sub_000000_018_32_9 (
    .addra({5'b00000,addra,3'b111}),
    .addrb({5'b00000,addrb,3'b111}),
    .cea(cea),
    .ceb(ceb),
    .clka(clka),
    .clkb(clkb),
    .dia(dia[26:18]),
    .dib(dib[26:18]),
    .rsta(rsta),
    .rstb(rstb),
    .wea(wea),
    .web(web),
    .doa(doa[26:18]),
    .dob(dob[26:18]));
  AL_PHY_BRAM #(
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .MODE("DP8K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    inst_sub_000000_027_32_5 (
    .addra({5'b00000,addra,3'b111}),
    .addrb({5'b00000,addrb,3'b111}),
    .cea(cea),
    .ceb(ceb),
    .clka(clka),
    .clkb(clkb),
    .dia({open_n30,open_n31,open_n32,open_n33,dia[31:27]}),
    .dib({open_n34,open_n35,open_n36,open_n37,dib[31:27]}),
    .rsta(rsta),
    .rstb(rstb),
    .wea(wea),
    .web(web),
    .doa({open_n40,open_n41,open_n42,open_n43,doa[31:27]}),
    .dob({open_n44,open_n45,open_n46,open_n47,dob[31:27]}));

endmodule 

