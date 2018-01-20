module pop_test(
	);

	logic	[31:0] dbg_led;
	logic			 dbg_btn;

	logic			clk;
	logic			reset_n;

	logic [63:0] mmix_address;
	logic [1:0]  mmix_datasize;	// 0: byte, 1: wyde, 2: tetra, 3: octa
	logic			 mmix_read;
	logic [63:0] mmix_readdata;
	logic			 mmix_write;
	logic [63:0] mmix_writedata;
	logic			 mmix_done;
	
	cpu xxx(
		dbg_led,
		dbg_btn,

		clk,
		reset_n,
	
		mmix_address,
		mmix_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
		mmix_read,
		mmix_readdata,
		mmix_write,
		mmix_writedata,
		mmix_done
		);
		
	always #20
		clk <= ~clk;
	
	task wait_mem_read(logic[63:0] addr, logic[63:0] data);
		while (1) begin
			@(posedge clk);
			if (mmix_read == 1)
				break;
		end
				
		if (mmix_address != addr)
			$stop;
		mmix_readdata <= data;
		mmix_done <= 1;

		@(posedge clk);
		mmix_done <= 0;
	endtask
	
	task wait_mem_write(logic[63:0] addr, logic[63:0] data);
		while (1) begin
			@(posedge clk);
			if (mmix_write == 1)
				break;
		end
				
		if (mmix_address != addr)
			$stop;
		if (mmix_writedata != data)
			$stop;
		mmix_done <= 1;

		@(posedge clk);
		mmix_done <= 0;
	endtask

	initial begin
		clk <= 0;
		reset_n <= 0;
		mmix_done <= 0;
		#80 reset_n <= 1;

		////////////////		
		wait_mem_read(64'h0000fffffffffffc, 64'h00000000f1f00001);

		wait_mem_read(64'h0000ffffffc00000, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc00004, 64'h00000000e3ff8000);
		wait_mem_read(64'h0000ffffffc00008, 64'h00000000e6ff007f);
		wait_mem_read(64'h0000ffffffc0000c, 64'h00000000e5ff0000);
		wait_mem_read(64'h0000ffffffc00010, 64'h00000000e4ff8000);
		wait_mem_read(64'h0000ffffffc00014, 64'h00000000ad00ff00);
		wait_mem_write(64'h80000000007f8000, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc00018, 64'h00000000e000ff00);
		wait_mem_read(64'h0000ffffffc0001c, 64'h0000000021ffff70);
		wait_mem_read(64'h0000ffffffc00020, 64'h00000000ad00ff00);
		wait_mem_write(64'h80000000007f8070, 64'hff00000000000000);

		// UNSAVE: memory read rG|rA
		wait_mem_read(64'h0000ffffffc00024, 64'h00000000fb0000ff);
		wait_mem_read(64'h80000000007f8070, 64'hff00000000000000);
		wait_mem_read(64'h80000000007f8068, 64'h0000000000008068);
		wait_mem_read(64'h80000000007f8060, 64'h0000000000008060);
		wait_mem_read(64'h80000000007f8058, 64'h0000000000008058);
		wait_mem_read(64'h80000000007f8050, 64'h0000000000008050);
		wait_mem_read(64'h80000000007f8048, 64'h0000000000008048);
		wait_mem_read(64'h80000000007f8040, 64'h0000000000008040);
		wait_mem_read(64'h80000000007f8038, 64'h0000000000008038);
		wait_mem_read(64'h80000000007f8030, 64'h0000000000008030);
		wait_mem_read(64'h80000000007f8028, 64'h0000000000008028);
		wait_mem_read(64'h80000000007f8020, 64'h0000000000008020);
		wait_mem_read(64'h80000000007f8018, 64'h0000000000008018);
		wait_mem_read(64'h80000000007f8010, 64'h0000000000008010);
		wait_mem_read(64'h80000000007f8008, 64'h0000000000008008);
		wait_mem_read(64'h80000000007f8000, 64'h0000000000000000);

		wait_mem_read(64'h0000ffffffc00028, 64'h00000000f7130020);
		wait_mem_read(64'h0000ffffffc0002c, 64'h00000000e3fe0000);
		wait_mem_read(64'h0000ffffffc00030, 64'h00000000e6fe0080);
		wait_mem_read(64'h0000ffffffc00034, 64'h00000000e5fe0000);
		wait_mem_read(64'h0000ffffffc00038, 64'h00000000e4fe8000);
		wait_mem_read(64'h0000ffffffc0003c, 64'h00000000f2030146);

		///////
		wait_mem_read(64'h0000ffffffc00554, 64'h00000000e3001140);
		wait_mem_read(64'h0000ffffffc00558, 64'h00000000f8010000);
		
		// start.S
		wait_mem_read(64'h0000ffffffc00040, 64'h00000000f0000000);
		/////

	end
	
endmodule
