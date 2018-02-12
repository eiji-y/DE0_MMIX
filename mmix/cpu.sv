/*
 * Copyright 2018 Eiji Yoshiya
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

// synthesis translate_off
`include "mmix_defs.sv"
// synthesis translate_on 

module cpu(
		output wire	[31:0] dbg_led,
		input  wire [2:0]  dbg_btn,
		output wire	[9:0]  dbg_ledg,
		input	 wire	[9:0]	 dbg_sw,

		input	wire			clk,
		input	wire			reset_n,
	
		output wire [63:0] mem_address,
		output wire [1:0]  mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
		output wire			 mem_read,
		input  wire [63:0] mem_readdata,
		output wire			 mem_write,
		output wire [63:0] mem_writedata,
		input  wire			 mem_done
	);

	enum bit[3:0] {
		S_RESET,
		S_IFETCH,
		S_DISPATCH,
		S_EXEC,
		S_TRAP,
		S_HALT,
		S_STOP
	} stage;
	
	/////
	reg [61:0]  O;
	reg [61:0]  S;
	reg [7:0]  G;
	reg [7:0]  L;
	
	logic[63:0]	J;
	logic[63:0] P;
	
	///////
	
	logic [63:0]	next_addr;
	logic fetch_done;
	logic	no_fetch;
	fetch	f_head;

	wire [63:0]	f_mem_address;
	wire [1:0]	f_mem_datasize;
	wire			f_mem_read;
	
	fetch_unit fu(
		.clk,
		.reset_n,
		.enable			(fu_enable),
		.inst_ptr		(next_addr),
		.fetch_done,

		.head				(f_head),
		
		.mem_address	(f_mem_address),
		.mem_datasize	(f_mem_datasize),	// 0: byte, 1: wyde, 2: tetra, 3: octa
		.mem_read		(f_mem_read),
		.mem_readdata,
		.mem_done
	);
	
	assign fu_enable = (stage == S_IFETCH);
	
	///////	
	logic stall;
	
	wire[7:0]	new_G, new_L;
	wire[61:0]	new_O, new_S;
	
	fetch		head;
	control dec_data;
	control data;
	values	operands;
	
	inst_decoder i_dec(
		.head,
		.G		(G),
		.L		(L),
		.S		(S),
		.O		(O),
		.J,
		.stall,

		.new_L,
		.new_O, .new_S,

		.data			(dec_data),
		.operands
	);
	
	wire	ex1_done;
	wire	ex1_enable = (stage == S_EXEC);
	
	control		ex1_data;
	
	wire [63:0]	ex1_mem_address;
	wire [1:0]	ex1_mem_datasize;
	wire			ex1_mem_read;
	
//	regwrite	ex1_regw;
	
	exec_unit	ex1(
		.clk,
		.reset_n,
		.enable	(ex1_enable),
		
		.data,
		.operands,
		
		.G, .L,
		.O, .S,
		.P,
		
		.done			(ex1_done),
		
		.new_G,
		.data_out		(ex1_data),
		
		.mem_address	(ex1_mem_address),
		.mem_datasize	(ex1_mem_datasize),	// 0: byte, 1: wyde, 2: tetra, 3: octa
		.mem_read		(ex1_mem_read),
		.mem_readdata,
		.mem_write,
		.mem_writedata,
		.mem_done
	);

	regwrite		gregw, lregw;
	spec			y,     z,     b,     ra;

	regfile	registers(
		.clk		(clk),
		.reset_n	(reset_n),

		.y, //			(data.y),
		.z, //			(data.z),
		.b, //			(data.b),
		.ra, //		(data.ra),
		.y_val	(operands.y),
		.z_val	(operands.z),
		.b_val	(operands.b),
		.ra_val	(operands.ra),

		.gregw, .lregw,
		.J,
		.P
	);
	
	led led0(
		.data	(f_head.loc),
//		.data	(operands.y.o),
		.btn (dbg_btn[2]),
		.dbg_led (dbg_led)
		);
	
	assign y = (stage == S_DISPATCH) ? dec_data.y : data.y;
	assign z = (stage == S_DISPATCH) ? dec_data.z : data.z;
	assign b = (stage == S_DISPATCH) ? dec_data.b : data.b;
	assign ra = (stage == S_DISPATCH) ? dec_data.ra : data.ra;
	
	assign mem_address = (stage == S_IFETCH) ? f_mem_address : ex1_mem_address;
	assign mem_datasize = (stage == S_IFETCH) ? f_mem_datasize : ex1_mem_datasize;
	assign mem_read = (stage == S_IFETCH) ? f_mem_read : ex1_mem_read;
	
	function [31:0] pack_bytes (input [7:0] b1, b2, b3, b4);
		pack_bytes = { b1, b2, b3, b4};
	endfunction
	
	// for single step execution.
	logic prev_btn1;
	logic btn1;
	
	always_ff @(posedge clk) begin
		prev_btn1 <= btn1;
		btn1 <= dbg_btn[1];
	end

	always @(posedge clk, negedge reset_n)
		if (reset_n == 0) begin
			stage <= S_RESET;
		end else begin
			gregw = '{0, 0, 0};
			lregw = '{0, 0, 0};
			
			case (stage)
			S_RESET:
				begin
					G <= 8'd32;
					L <= 8'd0;
					O <= 0;
					S <= 0;
					stage <= S_IFETCH;
					next_addr <= 64'h8000fffffffffffc;
				end
			S_IFETCH:
				begin
					if (fetch_done) begin
						if (dbg_sw[0])
							stage <= S_STOP;
						else
							stage <= S_DISPATCH;
						head <= f_head;
					end
				end
			S_DISPATCH:
				begin
					if (~stall) begin
						stage <= S_EXEC;
						data <= dec_data;
						no_fetch <= dec_data.interim;
						
						if (dec_data.i == trap) begin
							stage <= S_TRAP;
						end
						
						if (dec_data.interim) begin
							if (dec_data.op == UNSAVE) begin
								case (dec_data.xx)
								0: begin
										head.inst <= pack_bytes(UNSAVE, 1, rZ, 0 );
									end
								1: begin
										if (dec_data.yy == rP)
											head.inst <= pack_bytes(UNSAVE, 1, rR, 0);
										else if (dec_data.yy == 0)
											head.inst <= pack_bytes(UNSAVE, 2, 255, 0);
										else
											head.inst <= pack_bytes(UNSAVE, 1 , dec_data.yy - 1, 0);
									end
								2: begin
										if (dec_data.yy == G)
											head.inst <= pack_bytes(UNSAVE, 3, 0, 0);
										else
											head.inst <= pack_bytes(UNSAVE, 2, dec_data.yy - 1, 0);
									end
								endcase
							end
						end
						
						data.owner <= 1;
						
						O <= new_O;
						S <= new_S;
						L <= new_L;
						
					end
				end
			S_EXEC:
				begin
					if (ex1_done) begin
						next_addr <= ex1_data.go.o;
						
						G <= new_G;
						data <= ex1_data;

						if (ex1_data.ren_x & ex1_data.x.src[0])
							gregw = '{ 1, ex1_data.x.addr, ex1_data.x.o };
						else if (ex1_data.ren_a & ex1_data.a.src[0])
							gregw = '{ 1, ex1_data.a.addr, ex1_data.a.o };
						
						if (ex1_data.ren_x & ex1_data.x.src[1])
							lregw = '{ 1, ex1_data.x.addr, ex1_data.x.o };
						else if (ex1_data.ren_a & ex1_data.a.src[1])
							lregw = '{ 1, ex1_data.a.addr, ex1_data.a.o };
						
						if (ex1_data.owner)
							stage <= S_EXEC;
						else begin
							if (no_fetch)	//(no_fetch)
								stage <= S_DISPATCH;
							else
								stage <= S_IFETCH;
						end
					end
				end
		//						8'hf7:	// PUTI
		//							begin
		//								stage = S_STORE_GREG;
		//								case (xx)
		//								19:	// G
		//									begin
		//										if ((z[63:8] != 0) || (z[7:0] < L) || (z[7:0] < 32))
		//											begin
		//												program_bits[B_BIT] = 1;
		//												z = {56'b0, G};
		//												stage = S_TRAP;
		//											end
		//										else if (z[7:0] < G)
		//											begin
		//												gregwe = 1;
		//												gregwa = G - 1;
		//												gregwd = 0;
		//												G = G - 1;
		//												stage = S_EXEC;
		//											end
		//									end
		//								20:	// L
		//									begin
		//										if (z[63:8] != 0)
		//											z = {56'b0, L};
		//										else if (z[7:0] > L)
		//											z[7:0] = L;
		//									end
		//								default:
		//									begin
		//									end
		//								endcase
		//
		//								x = z;
		//							end
			S_TRAP,
			S_HALT:
				begin
					stage <= S_HALT;
				end
			S_STOP:
				begin
					if (prev_btn1 & ~btn1) begin
						stage <= S_DISPATCH;
					end else begin
						stage <= S_STOP;
					end
				end

			endcase
		end
	
endmodule
