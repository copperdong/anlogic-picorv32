module simple_spi(clk_i,
		rst_i,
		
		sel_i,
		data_i,
		data_o,
		addr_i,
		
		mosi_o,
		miso_i,
		cs_o,
		clk_o);
	input clk_i;
	input rst_i;
	input sel_i; /* SPI 寄存器：SPI_ODR, SPI_IDR, SPI_BSRR, SPI_STATUS */
	input [31:0]data_i;
	output [31:0]data_o;
	input [1:0]addr_i;
	
	output mosi_o;
	input miso_i;
	output cs_o;
	output clk_o;
	
		
endmodule
