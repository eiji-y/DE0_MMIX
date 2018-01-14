`timescale 1 ns / 100 ps

module bus_adapter_test();

	reg    clk = 0;
	reg    reset_n;

	reg [63:0]	mem_address;
	reg [1:0]   mem_datasize;
	logic	mem_read;
	wire [63:0]	mem_readdata;
	logic	mem_write;
	logic [63:0]	mem_writedata;
	wire	mem_done;

	wire [27:0]	d_address;
	wire [7:0]	d_byteenable;
	wire	d_read;
	reg [63:0]	d_readdata;
	reg	d_waitrequest;
	wire	d_write;
	wire [63:0]	d_writedata;
	reg	d_readdatavalid;

	bus_adapter i0 (
		.clk		(clk),             //         clock_sink.clk
		.reset_n	(reset_n),         //         reset_sink.reset_n

		.mem_address	(mem_address),
		.mem_datasize	(mem_datasize),
		.mem_read	(mem_read),
		.mem_readdata	(mem_readdata),
		.mem_write	(mem_write),
		.mem_writedata	(mem_writedata),
		.mem_done	(mem_done),
	
		.d_address	(d_address),       //      avalon_master.address
		.d_byteenable	(d_byteenable),    //                   .byteenable
		.d_read		(d_read),          //                   .read
		.d_readdata	(d_readdata),      //                   .readdata
		.d_waitrequest	(d_waitrequest),   //                   .waitrequest
		.d_write	(d_write),         //                   .write
		.d_writedata	(d_writedata),     //                   .writedata
		.d_readdatavalid	(d_readdatavalid)  //                   .readdatavalid
	);

	always #10 clk <= ~clk;

	always @(posedge d_read) begin
		d_waitrequest <= 1;
		repeat (2) @(posedge clk);
		d_waitrequest <= 0;
		@(posedge clk);
		d_readdata <= 64'h0102030405060708;
		d_readdatavalid <= 1;
		@(posedge clk);
		d_readdata <= 64'bz;
		d_readdatavalid <= 0;
		d_waitrequest <= 1;
		
		while (~d_write) @(posedge clk);
		repeat (3) @(posedge clk);
		d_waitrequest <= 0;
		@(posedge clk);
		d_waitrequest <= 1;
		
	end
	
	initial begin
		reset_n <= 0;
		mem_read <= 0;
		mem_write <= 0;
		d_waitrequest <= 0;
		d_readdatavalid <= 0;
		repeat (2) @(posedge clk);
		reset_n <= 1;
		
		repeat (2) @(posedge clk);
		mem_address <= 64'h0123456789abcdef;
		mem_datasize <= 3;
		mem_read <= 1;
		
		while (!mem_done) @(posedge clk);
		mem_read <= 0;
		
		repeat(2) @(posedge clk);
		mem_datasize <= 2;
		mem_writedata <= 'hdaedbeefdeadbeef;
		mem_write <= 1;
		
		while (!mem_done) @(posedge clk);
		mem_write <= 0;
		
	end

endmodule
