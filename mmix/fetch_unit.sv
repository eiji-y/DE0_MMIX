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

module fetch_unit(
	input  logic			clk,
	input  logic			reset_n,
	input  logic			enable,
	input  logic[63:0]	inst_ptr,
	output logic			fetch_done,
	output fetch			head,
	
	output logic [63:0]	mem_address,
	output logic [1:0]	mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
	output logic			mem_read,
	input  logic [63:0]	mem_readdata,
	input  logic			mem_done
);

	logic[31:0]	inst;
	logic px_bit, f_bit;
	
	assign head.loc = inst_ptr;
	assign head.inst = head.interrupt[F_BIT] ? {SWYM, 24'b0} : inst;
	assign head.resuming = 0;
	
	always_comb begin
		head.interrupt = 0;
		head.interrupt[PX_BIT] = px_bit;
		head.interrupt[F_BIT] = f_bit;
	end
	
	logic [3:0]		state;
	
	assign mem_datasize = 2'b10;
	assign mem_address = { 1'b0, inst_ptr[62:0] };
	
	always_ff @(posedge clk, negedge reset_n) begin
		if (reset_n == 0) begin
			inst <= 0;
		end else begin
			if ((state == 1) && mem_done)
				inst <= mem_readdata[31:0];
		end
	end

	always_ff @(posedge clk, negedge reset_n) begin
		if (reset_n == 0) begin
			mem_read <= 0;
			fetch_done <= 0;
			px_bit <= 0;
			f_bit <= 0;
			state <= 0;
		end else begin
			case (state)
			0: begin
					if (enable) begin
						if (inst_ptr[63]) begin
							if (inst_ptr[62:48]) begin
								px_bit <= 1;
								fetch_done <= 1;
								state <= 15;
							end else begin
								mem_read <= 1;
								state <= 1;
							end
						end else begin
							// request virtual address translation
							f_bit <= 1;
							fetch_done <= 1;
							state <= 15;
						end
					end
				end
			1: begin
					if (mem_done) begin
						mem_read <= 0;
						fetch_done <= 1;
						state <= 15;
					end
				end
			15: begin
					fetch_done <= 0;
					px_bit <= 0;
					f_bit <= 0;
					state <= 0;
				end
			endcase
		end
	end

endmodule
