module picorv32_regs (
    input [4:0] A1ADDR, A2ADDR, B1ADDR,
    output reg [31:0] A1DATA, A2DATA,
    input [31:0] B1DATA,
    input B1EN, CLK1
);
    reg [31:0] memory [0:31];
	integer i;
    initial
    begin
    	for(i = 0; i < 32; i++)
	    	memory[i] = 32'h0;
    end
    always @(posedge CLK1) begin
        A1DATA <= memory[A1ADDR];
        A2DATA <= memory[A2ADDR];
        if (B1EN) memory[B1ADDR] <= B1DATA;
    end
endmodule

