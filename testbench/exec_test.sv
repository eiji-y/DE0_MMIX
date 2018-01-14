`include "mmix_defs.sv"

module exec_test(
	);

	logic		clk;
	logic		reset_n;
	logic		enable;
	
	control			data;
	
	logic[63:0]	y, z, b;
	logic			y_valid, z_valid, b_valid;
	logic[7:0]		G, L;
	logic[61:0]	O, S;
	
	logic			done;
	logic[18:0]	interrupt;
	
	logic			we_G;
	logic[7:0]		new_G;

	logic			gregwe, lregwe;
	logic[7:0]		gregwa, lregwa;
	logic[63:0]	gregwd, lregwd;
	
	logic[63:0]	mem_address;
	logic[1:0]		mem_datasize;	// 0: byte, 1: wyde, 2: tetra, 3: octa
	logic			mem_read;
	logic[63:0]	mem_readdata;
	logic			mem_write;
	logic[63:0]	mem_writedata;
	logic			mem_done;

	exec_unit dut(
		.clk,
		.reset_n,
		.enable,
		
		.data,
		
		.y, .z, .b,
		.y_valid, .z_valid, .b_valid,
		.G, .L,
		.O, .S,
		
		.done,
		.interrupt,
		
		.we_G,
		.new_G,

		.gregwe, .lregwe,
		.gregwa, .lregwa,
		.gregwd, .lregwd,
		
		.mem_address,
		.mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
		.mem_read,
		.mem_readdata,
		.mem_write,
		.mem_writedata,
		.mem_done
		);
		
	always #20
		clk <= ~clk;
	
	initial begin
		clk <= 0;
		reset_n <= 0;
		enable <= 0;
		mem_done <= 0;
		y_valid <= 0;
		z_valid <= 0;
		b_valid <= 0;
		#80 reset_n <= 1;
		#40;

		@(posedge clk);
		enable <= 1;
		data.i <= incgamma;
		y <= 10;
		z <= 32;
		y_valid <= 1;
		@(posedge clk);
		b <= 'h1234;
		z_valid <= 1;
		b_valid <= 1;
		@(posedge clk);
		enable <= 0;
		
		@(posedge clk);
		mem_done <= 1;
		@(posedge clk);
		mem_done <= 0;

		while (done == 0)
			@(posedge clk);
			
		y_valid <= 0;
		z_valid <= 0;
		b_valid <= 0;
		
		@(posedge clk);
		data.i <= unsav;
		data.op <= UNSAVE;
		data.xx <= 0;
		enable <= 1;
		y <= 1;
		z <= 16;
		y_valid <= 1;
		z_valid <= 1;
		@(posedge clk);
		mem_done <= 1;
		mem_readdata <= 'h200000000000ffff;
		enable <= 0;
		@(posedge clk);
		mem_done <= 0;
		

	end
	
endmodule
