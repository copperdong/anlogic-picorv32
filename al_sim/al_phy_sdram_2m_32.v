module AL_PHY_SDRAM_2M_32 (
    clk,
    ras_n,
    cas_n,
    we_n,
    addr,
    ba,
    dq,
    dm,     // aka dm2
    dm0,
    cke
);

input         clk;
input         ras_n;
input         cas_n;
input         we_n;
input  [10:0] addr;
input  [1:0]  ba;
inout  [31:0] dq;
input         dm;
input         dm0;
input         cke;

endmodule
