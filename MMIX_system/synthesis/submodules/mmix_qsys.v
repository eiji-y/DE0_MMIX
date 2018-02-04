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

// mmix_qsys.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module mmix_qsys (
		output wire	[31:0] dbg_led,
		input	 wire	[2:0]	 dbg_btn,
		output wire	[9:0]  dbg_ledg,
		input	 wire	[9:0]	 dbg_sw,
		input  wire        reset_n,         //         reset_sink.reset_n
		input  wire        clk,             //         clock_sink.clk
		input  wire [31:0] d_irq,           // interrupt_receiver.irq
		output wire [27:0] d_address,       //      avalon_master.address
		output wire [7:0]  d_byteenable,    //                   .byteenable
		output wire        d_read,          //                   .read
		input  wire [63:0] d_readdata,      //                   .readdata
		input  wire        d_waitrequest,   //                   .waitrequest
		output wire        d_write,         //                   .write
		output wire [63:0] d_writedata,     //                   .writedata
		input  wire        d_readdatavalid  //                   .readdatavalid
	);

	// TODO: Auto-generated HDL template
	
	wire [63:0]	i_address;
	wire [1:0]	i_datasize;
	wire			i_read;
	wire [63:0]	i_readdata;
	wire			i_write;
	wire [63:0]	i_writedata;
	wire			i_done;
	
	cpu mmix_cpu(
		.dbg_led				(dbg_led),
		.dbg_btn				(dbg_btn),
		.dbg_ledg			(dbg_ledg),
		.dbg_sw				(dbg_sw),

		.clk 					(clk),             //         clock_sink.clk
		.reset_n				(reset_n),         //         reset_sink.reset_n
	
		.mem_address		(i_address),
		.mem_datasize		(i_datasize),	// 0: byte, 1: wyde, 2: tetra, 3: octa
		.mem_read			(i_read),
		.mem_readdata		(i_readdata),
		.mem_write			(i_write),
		.mem_writedata		(i_writedata),
		.mem_done			(i_done)
	);

	bus_adapter mmix_bus_adapter(
		.clk 					(clk),             //         clock_sink.clk
		.reset_n				(reset_n),         //         reset_sink.reset_n

		.mem_address		(i_address),
		.mem_datasize		(i_datasize),	// 0: byte, 1: wyde, 2: tetra, 3: octa
		.mem_read			(i_read),
		.mem_readdata		(i_readdata),
		.mem_write			(i_write),
		.mem_writedata		(i_writedata),
		.mem_done			(i_done),
	
		.d_address			(d_address),       //      avalon_master.address
		.d_byteenable		(d_byteenable),    //                   .byteenable
		.d_read				(d_read),          //                   .read
		.d_readdata			(d_readdata),      //                   .readdata
		.d_waitrequest		(d_waitrequest),   //                   .waitrequest
		.d_write				(d_write),         //                   .write
		.d_writedata		(d_writedata),     //                   .writedata
		.d_readdatavalid	(d_readdatavalid)  //                   .readdatavalid
		);
		
endmodule
