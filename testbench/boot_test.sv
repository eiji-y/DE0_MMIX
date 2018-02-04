module boot_test(
	);
	
	import "DPI-C" function void mem_init(string);
	import "DPI-C" function longint mem_read(int, longint);
	import "DPI-C" function void mem_write(int, longint, longint);

	logic	[31:0] dbg_led;
	logic			 dbg_btn;
	logic				dbg_halt;

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
	
	task wait_mem_access();
		while (1) begin
			@(posedge clk);
			if (mmix_read == 1) begin
				mmix_readdata = mem_read(mmix_datasize, mmix_address);
				break;
			end else if (mmix_write == 1) begin
				mem_write(mmix_datasize, mmix_address, mmix_writedata);
				break;
			end
			
		end

		mmix_done <= 1;

		@(posedge clk);
		mmix_done <= 0;
	endtask

	initial begin
		clk <= 0;
		reset_n <= 0;
		mmix_done <= 0;
		#80 reset_n <= 1;

		mem_init("vmlinux.bin");
		////////////////
		while (1)
			wait_mem_access();
			
		/////

	end
	
endmodule
