`timescale 1 ns / 1 ps

module system (
	input            clk,
	input            resetn_i,
	output           trap,
	output reg [7:0] out_byte,
	output reg       out_byte_en,
	output mem_valid,
	output mem_instr,
	output reset_o,
	output mem_la_write
);
	reg mem_ready;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;
	wire [31:0] mem_rdata;

	wire mem_la_read;
	//wire mem_la_write;
	wire [31:0] mem_la_addr;
	wire [31:0] mem_la_wdata;
	wire [3:0] mem_la_wstrb;
	
	reg resetn = 0;
	
	always @(posedge clk)
	begin
		resetn <= resetn_i;
	end
	
	picorv32 picorv32_core (
		.clk         (clk         ),
		.resetn      (resetn      ),
		.trap        (trap        ),
		.mem_valid   (mem_valid   ),
		.mem_instr   (mem_instr   ),
		.mem_ready   (mem_ready   ),
		.mem_addr    (mem_addr    ),
		.mem_wdata   (mem_wdata   ),
		.mem_wstrb   (mem_wstrb   ),
		.mem_rdata   (mem_rdata   ),
		.mem_la_read (mem_la_read ),
		.mem_la_write(mem_la_write),
		.mem_la_addr (mem_la_addr ),
		.mem_la_wdata(mem_la_wdata),
		.mem_la_wstrb(mem_la_wstrb)
	);

	assign reset_o = resetn;
	reg [31:0] m_read_data;
	reg m_read_en;

	sysmem_l mem_l  (.doa(mem_rdata[7:0]),
			.dia(mem_la_wdata[7:0]), 
			.addra(mem_la_addr[11:2]),
			.cea(1'b1), 
			.clka(clk), 
			.wea(mem_la_wstrb[0] && mem_la_write), 
			.rsta(~resetn));
	sysmem_ml mem_ml  (.doa(mem_rdata[15:8]),
			.dia(mem_la_wdata[15:8]), 
			.addra(mem_la_addr[11:2]),
			.cea(1'b1), 
			.clka(clk), 
			.wea(mem_la_wstrb[1] && mem_la_write), 
			.rsta(~resetn));
	sysmem_mh mem_mh  (.doa(mem_rdata[23:16]),
			.dia(mem_la_wdata[23:16]), 
			.addra(mem_la_addr[11:2]),
			.cea(1'b1), 
			.clka(clk), 
			.wea(mem_la_wstrb[2] && mem_la_write), 
			.rsta(~resetn));
	sysmem_hi mem_hi  (.doa(mem_rdata[31:24]),
			.dia(mem_la_wdata[31:24]), 
			.addra(mem_la_addr[11:2]),
			.cea(1'b1), 
			.clka(clk), 
			.wea(mem_la_wstrb[3] && mem_la_write), 
			.rsta(~resetn));
																																 
		always @(posedge clk) begin
			mem_ready <= 1;
			out_byte_en <= 0;

			if (mem_la_write && mem_la_addr == 32'h1000_0000) begin
				out_byte_en <= 1;
				out_byte <= mem_la_wdata;
			end
		end
endmodule
