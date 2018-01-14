`timescale 1 ns / 100 ps

module fetch_unit_test();

	logic			clk = 0;
	logic			reset_n = 0;
	logic			enable = 0;
	logic			ctl_change = 0;
	logic[63:0]	next_addr;
	logic			fetch_done;
	logic[63:0]	loc;
	logic[31:0]	inst;
	logic[18:0]	interrupt;	
	
	logic [63:0]	mem_address;
	logic [1:0]	mem_datasize;	// 0: byte; 1: wyde; 2: tetra; 3: octa
	logic			mem_read;
	 logic [63:0]	mem_readdata;
	 logic			mem_done = 0;

   fetch_unit u0 (
		.clk,
		.reset_n,
		.enable,
		.ctl_change,
		.next_addr,
		.fetch_done,
		.loc,
		.inst,
		.interrupt,	
		
		.mem_address,
		.mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
		.mem_read,
		.mem_readdata,
		.mem_done
  );

	always #10 clk <= ~clk;

	initial begin
		reset_n <= 0;
		
		repeat (2) @(posedge clk);
		reset_n <= 1;
		
		repeat (2) @(posedge clk);
		
		// first cycle
		enable <= 1;
		
		while (!mem_read)
			@(posedge clk);
		
		mem_readdata <= 'hdeadbeefdeadbeef;
		mem_done <= 1;
		
		@(posedge clk);
		mem_done <= 0;
		
		while (!fetch_done)
			@(posedge clk);
		
		enable <= 0;
		
		repeat (2) @(posedge clk);
		
		//// bext cycle
		enable <= 1;
		ctl_change <= 1;
		next_addr <= 'h8000fffffff00000;

		while (!mem_read)
			@(posedge clk);
		
		mem_readdata <= 'hcafecafecafecafe;
		mem_done <= 1;
		
		@(posedge clk);
		mem_done <= 0;
		
		while (!fetch_done)
			@(posedge clk);
		
		enable <= 0;

		end

endmodule
