`timescale 1 ns / 100 ps

module reg_test();

	reg    clk = 0;
	reg    reset_n = 0;

	logic ra1_req, ra2_req, ra3_req, ra4_req;
	logic[7:0]	ra1, ra2, ra3, ra4;
	logic we;
	logic [7:0] wa;
	logic[63:0] wd;
	logic rd1_valid, rd2_valid, rd3_valid, rd4_valid;
	logic[63:0] rd1, rd2, rd3, rd4;

   regs u0 (
		.clk,
		.reset_n,
		.ra1_req,
		.ra2_req,
		.ra3_req,
		.ra4_req,
		.ra1,
		.ra2,
		.ra3,
		.ra4,
		.we,
		.wa,
		.wd,
		.rd1_valid,
		.rd2_valid,
		.rd3_valid,
		.rd4_valid,
		.rd1,
		.rd2,
		.rd3,
		.rd4
  );

	always #10 clk <= ~clk;

	initial begin
		reset_n <= 0;
		ra1_req <= 0;
		ra2_req <= 0;
		ra3_req <= 0;
		ra4_req <= 0;
		ra1 <= 0;
		ra2 <= 0;
		ra3 <= 0;
		ra4 <= 0;
		
		repeat (2) @(posedge clk);
		reset_n <= 1;
		
		repeat (2) @(posedge clk);
		
		we <= 1;
		wa <= 1;
		wd <= 64'hdeadbeef00000001;
		@(posedge clk);
		we <= 1;
		wa <= 2;
		wd <= 64'hdeadbeef00000002;
		@(posedge clk);
		we <= 1;
		wa <= 3;
		wd <= 64'hdeadbeef00000003;
		@(posedge clk);
		we <= 1;
		wa <= 4;
		wd <= 64'hdeadbeef00000004;
		@(posedge clk);
		we <= 0;
		
		ra1_req <= 1;
		ra3_req <= 1;
		ra1 <= 1;
		ra2 <= 2;
		ra3 <= 3;
//		ra4 <= 4;

		@(posedge clk);
		ra1_req <= 0;
		
		@(posedge clk);
		ra3_req <= 1;
		
		@(posedge clk);
		ra3_req <= 0;
		
	end

endmodule
