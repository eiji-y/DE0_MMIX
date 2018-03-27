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
		output logic[9:0]  dbg_ledg,
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
		S_COMMIT,
		S_TRAP,
		S_HALT,
		S_STOP
	} stage;
	
	/////
	reg [60:0]  O;
	reg [60:0]  S;
	reg [7:0]  G;
	reg [7:0]  L;
	
	logic[63:0]	J;
	logic[63:0] P;
	
	logic[63:0]	I;
	logic[63:0]	Q;
	logic[63:0] new_Q;
	logic[63:0]	K;

	logic[3:0] doing_interrupt;
	
	///////
	
	logic fu_enable;
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
	wire[60:0]	new_O, new_S;
	
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
		.J, .I, .Q,
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
		.new_Q,
		
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

	regwrite		regw;
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

		.regw,
		.J,
		.P,
		.K
	);
	
	led led0(
//		.data	(f_head.loc),
		.data	(data.loc),
		.btn (dbg_btn[2]),
		.dbg_led (dbg_led)
		);
		
	always_comb begin
		case (dbg_sw[3:1])
		default: begin
				dbg_ledg[0] = (stage == S_IFETCH);
				dbg_ledg[1] = (stage == S_DISPATCH);
				dbg_ledg[2] = (stage == S_EXEC);
				dbg_ledg[3] = (stage == S_COMMIT);
				dbg_ledg[4] = (stage == S_TRAP);
				dbg_ledg[5] = operands.y.valid;
				dbg_ledg[6] = operands.z.valid;
				dbg_ledg[7] = operands.b.valid;
				dbg_ledg[8] = operands.ra.valid;
				dbg_ledg[9] = no_fetch;
			end
		3'b010: begin
				dbg_ledg[7:0] = regw.addr;
				dbg_ledg[9:8] = regw.enable;
			end
		3'b001: begin
				dbg_ledg[7:0] = data.y.addr;
				dbg_ledg[9:8] = data.y.src;
			end
		3'b011: begin
				dbg_ledg[7:0] = data.z.addr;
				dbg_ledg[9:8] = data.z.src;
			end
		3'b101: begin
				dbg_ledg[7:0] = data.b.addr;
				dbg_ledg[9:8] = data.b.src;
			end
		3'b111: begin
				dbg_ledg[7:0] = data.ra.addr;
				dbg_ledg[9:8] = data.ra.src;
			end
		endcase
	end
	
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
	
	//////////////////////
	control next_data;
	
	always_comb begin
		next_data = data;
		
		case (stage)
		S_DISPATCH: begin
				if (~stall) begin
					next_data = dec_data;
					next_data.owner = 1;
				end
			end
		S_EXEC: begin
				if (ex1_done) begin
					next_data = ex1_data;
				end
			end
		S_TRAP: begin
				if (doing_interrupt == 7) begin
					next_data.ra = '{ 0, 2'b01, rTT};
					next_data.b = '{ 0, 2'b01, 255};
					next_data.interrupt[26:19] <= 8'h80;
				end
			end
		endcase
	end
	
	// I
	logic[63:0] next_I;
	logic interval_timeout;
	
	always_comb begin
		interval_timeout = 0;
		
		if (regw.enable[0] && regw.addr == rI) begin
			next_I = regw.data;
  		end else begin
			next_I = I - 1;
			if (next_I == 0)
				interval_timeout = 1;
		end
	end
	
	// Q
	logic[63:0] next_Q;
	logic[63:0] next_new_Q;
	
	always_comb begin
		next_Q = Q;
		next_new_Q = new_Q;
		
		next_Q[7] |= interval_timeout;
		next_new_Q[7] |= interval_timeout;
		
		if ((stage == S_EXEC) && ex1_done) begin
			// remember bits that have changed from 0 to 1 since last GET.
			if ((ex1_data.i == get) && (ex1_data.zz == rQ)) begin
				next_new_Q = next_Q & ~ex1_data.x.o;
			end if ((ex1_data.i == put) && (ex1_data.xx == rQ)) begin
				next_new_Q |= ex1_data.x.o & ~next_Q;
				next_Q = ex1_data.x.o | next_new_Q;
			end
  		end
  	end

	always_ff @(posedge clk, negedge reset_n)
		if (reset_n == 0) begin
			stage <= S_RESET;
			G <= 8'd32;
			L <= 8'd0;
			O <= 0;
			S <= 0;
			I <= 0;
			Q <= 0;
			new_Q <= 0;
			next_addr <= 64'h8000fffffffffffc;
			data <= 0;
		end else begin
			I <= next_I;
			Q <= next_Q;
			new_Q <= next_new_Q;
			data <= next_data;
			
			regw = '{0, 0, 0};
			
			case (stage)
			S_RESET:
				begin
					stage <= S_IFETCH;
				end
			S_IFETCH:
				begin
					if (fetch_done) begin
						stage <= S_DISPATCH;
						head <= f_head;
						
					end
				end
			S_DISPATCH:
				begin
					if (~stall) begin
						stage <= S_EXEC;
//						data <= dec_data;
						//no_fetch <= dec_data.interim;
						no_fetch <= (dec_data.i > trip);
						
						if (dec_data.interim) begin
							if (dec_data.op == SAVE) begin
								if (dec_data.i != incgamma) begin
									case (dec_data.zz)
									0: begin
											head.inst <= pack_bytes(SAVE, dec_data.xx, G, 1);
										end
									1: begin
											if (dec_data.yy == 255)
												head.inst <= pack_bytes(SAVE, dec_data.xx, 0, 2);
											else
												head.inst <= pack_bytes(SAVE, dec_data.xx, dec_data.yy + 1, 1);
										end
									2: begin
											if (dec_data.yy == rR)
												head.inst <= pack_bytes(SAVE, dec_data.xx, rP, 2);
											else
												head.inst <= pack_bytes(SAVE, dec_data.xx, dec_data.yy + 1, 2);
										end
									endcase
								end
							end else if (dec_data.op == UNSAVE) begin
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
						
						if (dec_data.i == resum) begin
							// data.y = '{ 0, 2'b01, rWW};
							// data.z = '{ 0, 2'b01, rXX};
							head.loc <= operands.y.o - 4;
							case (operands.z.o[63:56])
							RESUME_SET: begin
									head.resuming <= 4;
									head.inst <= { SETH, operands.z.o[23:16], 16'b0 };
								end
							//RESUME_CONT:
							//RESUME_AGAIN:
							//RESUME_TRANS:
							endcase
						end
						
//						data.owner <= 1;
						
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
//						data <= ex1_data;

						if (ex1_data.ren_x)
							regw = '{ ex1_data.x.src, ex1_data.x.addr, ex1_data.x.o };
						
						stage <= S_COMMIT;
					end
				end
			S_COMMIT:
				begin
					if (data.ren_a)
						regw = '{ data.a.src, data.a.addr, data.a.o };
					
					if (data.interrupt[F_BIT]) begin
						stage <= S_TRAP;
						doing_interrupt <= 4;
					end else if (((Q & K) != 0) && (data.i != resum)) begin
						stage <= S_TRAP;
						doing_interrupt <= 7;
					end else if (data.owner) begin
						stage <= S_EXEC;
					end else if (no_fetch) begin	//(no_fetch)
						stage <= S_DISPATCH;
					end else begin
						if (dbg_sw[0])
							stage <= S_STOP;
						else
							stage <= S_IFETCH;
					end
				end
			S_TRAP:
				begin
					case (doing_interrupt)
					// dynamic trap entry point
					7: begin
							doing_interrupt <= doing_interrupt - 1;
						end
					6: begin
							if (operands.b.valid) begin
								regw = '{ 2'b01, rBB, operands.b.o };
								doing_interrupt <= doing_interrupt - 1;
							end
						end
					5: begin
							regw = '{ 2'b01, 255, J };
							doing_interrupt <= doing_interrupt - 1;
						end
					// forced trap entry point
					4: begin
							if (operands.ra.valid) begin
								next_addr <= operands.ra.o;
								regw = '{ 2'b01, rK, 0 };
								doing_interrupt <= doing_interrupt - 1;
							end
						end
					3:	begin
							regw = '{ 2'b01, rWW, data.go.o };
							doing_interrupt <= doing_interrupt - 1;
						end
					2: begin
							regw = '{ 2'b01, rXX, { data.interrupt[26:19], 24'b0, data.op, data.xx, data.yy, data.zz} };
							doing_interrupt <= doing_interrupt - 1;
						end
					1: begin
							regw = '{ 2'b01, rYY, operands.y.o };
							doing_interrupt <= doing_interrupt - 1;
						end
  					0: begin
							regw = '{ 2'b01, rZZ, operands.z.o };
							
							if (dbg_sw[9] || ~next_addr[63])
								stage <= S_STOP;
							else
								stage <= S_IFETCH;
						end
					endcase
				end
			S_HALT:
				begin
					stage <= S_HALT;
				end
			S_STOP:
				begin
					if (prev_btn1 & ~btn1) begin
						stage <= S_IFETCH;
					end else begin
						stage <= S_STOP;
					end
				end

			endcase
		end
	
endmodule
