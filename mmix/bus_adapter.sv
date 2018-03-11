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

module bus_adapter(
		input  wire        clk,             //         clock_sink.clk
		input  wire        reset_n,         //         reset_sink.reset_n

		input  wire [63:0] mem_address,
		input	 wire [1:0]  mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
		input	 wire			 mem_read,
		output wire [63:0] mem_readdata,
		input  wire			 mem_write,
		input  wire [63:0] mem_writedata,
		output wire			 mem_done,
	
		output wire [27:0] d_address,       //      avalon_master.address
		output wire [7:0]  d_byteenable,    //                   .byteenable
		output wire        d_read,          //                   .read
		input  wire [63:0] d_readdata,      //                   .readdata
		input  wire        d_waitrequest,   //                   .waitrequest
		output wire        d_write,         //                   .write
		output wire [63:0] d_writedata,     //                   .writedata
		input  wire        d_readdatavalid  //                   .readdatavalid
	);

	logic			write_done;
	logic [1:0]	i_state;
	logic			i_request;
	logic [63:0]	i_readdata;
	logic [63:0]	i_writedata;
	logic [7:0]		i_byteenable;

	function [63:0] octa_swap (input [63:0] in);
		octa_swap = {	in[7:0], in[15:8],
							in[23:16], in[31:24],
							in[39:32], in[47:40],
							in[55:48], in[63:56]};
	endfunction
	
	assign mem_readdata = octa_swap(i_readdata);
	assign d_writedata = octa_swap(i_writedata);
							
	assign d_address = {mem_address[48], mem_address[26:3], 3'b000};
	assign i_request = ~i_state[1];
	assign d_read = mem_read & i_request;
	assign d_write = mem_write & i_request;
	assign d_byteenable = i_byteenable;
//	assign mem_done =  mem_write ? write_done : d_readdatavalid;
	assign mem_done = (i_state == 2) ? d_readdatavalid : write_done;
	
	always_comb begin
		case (mem_datasize)
		0:	begin
				i_byteenable = 1'b1 << mem_address[2:0];
				i_readdata = d_readdata << ((7 - mem_address[2:0]) << 3);
				i_writedata = mem_writedata << ((7 - mem_address[2:0]) << 3);
			end
		1:	begin
				i_byteenable = 2'b11 << (mem_address[2:1] * 2);
				i_readdata = d_readdata << ((3 - mem_address[2:1]) << 4);
				i_writedata = mem_writedata << ((3 - mem_address[2:1]) << 4);
			end
		2:	begin
				i_byteenable = 4'b1111 << (mem_address[2] * 4);
				i_readdata = d_readdata << ((1 - mem_address[2]) << 5);
				i_writedata = mem_writedata << ((1 - mem_address[2]) << 5);
			end
		3:	begin
				i_byteenable = 8'b11111111;
				i_readdata = d_readdata;
				i_writedata = mem_writedata;
			end
		endcase
	end
	
	always_ff @(posedge clk or negedge reset_n)
	begin
		if (reset_n == 0)
			begin
				i_state <= 0;
				write_done <= 0;
			end	
		else
			case (i_state)
			0:				// wait command
				if (mem_read | mem_write)
					begin
						i_state <= 1;
//						write_done <= 0;
					end
			1:		// read
				if (d_waitrequest == 0)
					begin
						if (mem_read)
							i_state <= 2;
						else begin
							i_state <= 3;
							write_done <= 1;
						end
					end
			2:
				if (d_readdatavalid == 1)
					begin
						i_state <= 0;
					end
			3: begin
					i_state <= 0;
					write_done <= 0;
				end
			endcase
	end
	
endmodule
