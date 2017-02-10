`timescale 1 ns / 1 ps

module system_tb;
	reg clk = 1;
	always #5 clk = ~clk;

	reg resetn = 0;
	initial begin
		//if ($test$plusargs("vcd")) begin
			$dumpfile("system.vcd");
			$dumpvars(0, system_tb);
		//end
		repeat (100) @(posedge clk);
		resetn <= 1;
		#2000 $finish;
	end
	
	reg [5:0]counter;
	wire [31:0]data_out;
	wire we;
	assign we = counter[0];
	
	wire [4:0]waddr;
	assign waddr = counter[5:1];
	wire [4:0]raddr = counter[5:1] - 2;
	
	wire [31:0]data_in = counter;
	regfile_dp_m dut(.di(data_in), .waddr(waddr), .we(we), .wclk(clk), .do(data_out), .raddr(raddr));
	always @(posedge clk)
	begin
		if(resetn)
		counter <= counter + 1;
		else
		counter <= 0;
	end
endmodule

module regfile_dp_m(di, waddr, we, wclk, do, raddr);
	input [31:0] di;
	input [4:0] waddr;
	input [4:0] raddr;
	input we;
	input wclk;
	output [31:0] do;
	
	reg [31:0]memory[0:31];
	
	always @(posedge wclk)
		if(we)
			memory[waddr] <= di;
	assign do = memory[raddr];
endmodule
