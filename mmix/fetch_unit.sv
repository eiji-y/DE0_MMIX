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
	input  logic			ctl_change,
	input  logic[63:0]	next_addr,
	output logic			fetch_done,
	output fetch			head,
	
	output logic [63:0]	mem_address,
	output logic [1:0]	mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
	output logic			mem_read,
	input  logic [63:0]	mem_readdata,
	input  logic			mem_done
);

	logic[63:0]	loc;
	logic[31:0]	inst;
	logic[18:0]	interrupt;
	
	assign head.loc = loc;
	assign head.inst = inst;
	assign head.interrupt = interrupt;
	
	logic [3:0]		state;
	logic [63:0]	inst_ptr;
	logic [63:0]	new_inst_ptr;
	
	assign mem_datasize = 2'b10;
	assign new_inst_ptr[63:0] = ctl_change ? next_addr : inst_ptr;
	
	always_ff @(posedge clk, negedge reset_n) begin
		if (reset_n == 0) begin
			inst_ptr <= 64'h8000fffffffffffc;
			mem_read <= 0;
			fetch_done <= 0;
			interrupt <= 0;
			state <= 0;
		end else begin
			case (state)
			0: begin
					if (enable) begin
						if (new_inst_ptr[63]) begin
							if (new_inst_ptr[62:48]) begin
								inst <= {SWYM, 24'b0};
								interrupt[PX_BIT] <= 1;
								fetch_done <= 1;
								state <= 15;
							end else begin
								mem_address <= {16'b0, new_inst_ptr[47:0]};
								mem_read <= 1;
								state <= 1;
							end
						end else begin
							// request virtual address translation
							mem_address <= new_inst_ptr;
							interrupt[F_BIT] <= 1;
							fetch_done <= 1;
							state <= 15;
						end
						inst_ptr <= new_inst_ptr;
					end
				end
			1: begin
					if (mem_done) begin
						mem_read <= 0;
						loc <= inst_ptr;
						inst <= mem_readdata[31:0];
						inst_ptr <= inst_ptr + 4;
						fetch_done <= 1;
						state <= 15;
					end
				end
			15: begin
					fetch_done <= 0;
					interrupt <= 0;
					state <= 0;
				end
			endcase
		end
	end

endmodule
