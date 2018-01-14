`include "mmix_defs.sv"

module alu_test(
	);

	logic			clk = 0;
	logic		reset_n;
	logic		enable;
	
	control			data;
	
	logic[63:0]		y, z;
	logic				y_valid, z_valid;
	
	logic			regwe;
	logic[7:0]		regwa;
	logic[63:0]	regwd;

	logic			cf;
	logic			done;
	
	al_unit dut(
	   .clk,
		.reset_n,
		.enable,
		
		.data,
		
		.y, .z,
		.y_valid, .z_valid,
		
		.regwe,
		.regwa,
		.regwd,

		.cf,
		.done
		);
		
	always #20
		clk <= ~clk;
	
	initial begin
		reset_n <= 0;
		enable <= 0;
		y_valid <= 0;
		z_valid <= 0;
		#80 reset_n <= 1;
		#40;

		@(posedge clk);
		enable <= 1;
		data.i <= orn;
		y <= 'b0011;
		z <= 'b0101;
		y_valid <= 1;
		@(posedge clk);
		z_valid <= 1;
		enable <= 1;
		
		while (done == 0)
			@(posedge clk);
		
		enable <= 0;
		
		repeat(2) @(posedge clk);
		
		enable <= 1;
		data.i <= xor_;

		  @(posedge clk);
		data.i <= and_;

		  @(posedge clk);
		 enable <= 0;

  repeat(2) @(posedge clk);
  		 
		 data.i <= unsav;
		 enable <= 1;
		 
  repeat(2) @(posedge clk);
  		 
		 enable <= 0;
		 

	end
	
endmodule
