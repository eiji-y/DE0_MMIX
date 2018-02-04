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

module regfile(
	input logic clk,
	input	logic	reset_n,

	input  spec			y,     z,     b,     ra,
	output spec_val	y_val, z_val, b_val, ra_val,
	
	input regwrite		gregw,
	input regwrite		lregw,
	
	output[63:0]		J,
	output[63:0]		P
	);
	
	logic			gy_valid, gz_valid, gb_valid, gra_valid;
	logic[7:0]	gady, gadz, gadb, gadra;
	logic[63:0] grdy, grdz, grdb, grdra;
	logic gregwe;
	logic [7:0] gregwa;
	logic[63:0] gregwd;

	logic			ly_valid, lz_valid, lb_valid, lra_valid;
	logic[7:0]	lady, ladz, ladb, ladra;
	logic[63:0] lrdy, lrdz, lrdb, lrdra;
	logic lregwe;
	logic [7:0] lregwa;
	logic[63:0] lregwd;
	
	logic[63:0]	gJ;
	logic[63:0] gP;
	
	regs greg(
		.clk (clk),
		.reset_n (reset_n),
		.ra1_req		(y.src[0]),
		.ra2_req		(z.src[0]),
		.ra3_req		(b.src[0]),
		.ra4_req		(ra.src[0]),
		.rd1_valid	(gy_valid),
		.rd2_valid	(gz_valid),
		.rd3_valid	(gb_valid),
		.rd4_valid	(gra_valid),
		.ra1	(gady),
		.rd1	(grdy),
		.ra2	(gadz),
		.rd2	(grdz),
		.ra3	(gadb),
		.rd3	(grdb),
		.ra4	(gadra),
		.rd4	(grdra),
		.we	(gregwe),
		.wa	(gregwa),
		.wd	(gregwd)
	);

	regs lreg(
		.clk (clk),
		.reset_n (reset_n),
		.ra1_req		(y.src[1]),
		.ra2_req		(z.src[1]),
		.ra3_req		(b.src[1]),
		.ra4_req		(ra.src[1]),
		.rd1_valid	(ly_valid),
		.rd2_valid	(lz_valid),
		.rd3_valid	(lb_valid),
		.rd4_valid	(lra_valid),
		.ra1	(lady),
		.rd1	(lrdy),
		.ra2	(ladz),
		.rd2	(lrdz),
		.ra3	(ladb),
		.rd3	(lrdb),
		.ra4	(ladra),
		.rd4	(lrdra),
		.we	(lregwe),
		.wa	(lregwa),
		.wd	(lregwd)
	);
	
	assign gady = y.addr;
	assign lady = y.addr;
	
	assign gadz = z.addr;
	assign ladz = z.addr;
	
	assign gadb = b.addr;
	assign ladb = b.addr;
	
	assign gadra = ra.addr;
	assign ladra = ra.addr;
	
	assign gregwe = gregw.enable;
	assign lregwe = lregw.enable;
	assign gregwa = gregw.addr;
	assign lregwa = lregw.addr;
	assign gregwd = gregw.data;
	assign lregwd = lregw.data;
	
	assign J = gJ;
	assign P = gP;

	always_comb begin
		if (y.src[0])
			y_val = '{ grdy, gy_valid };
		else if (y.src[1])
			y_val = '{ lrdy, ly_valid };
		else
			y_val = '{ y.o, 1 };

		if (z.src[0])
			z_val = '{ grdz, gz_valid };
		else if (z.src[1])
			z_val = '{ lrdz, lz_valid };
		else
			z_val = '{ z.o, 1 };
			
		if (b.src[0])
			b_val = '{ grdb, gb_valid };
		else if (b.src[1])
			b_val = '{ lrdb, lb_valid };
		else
			b_val = '{ b.o, 1 };
			
		if (ra.src[0])
			ra_val = '{ grdra, gra_valid };
		else if (ra.src[1])
			ra_val = '{ lrdra, lra_valid };
		else
			ra_val = '{ ra.o, 1 };
	end
	
	always_ff @(posedge clk, negedge reset_n) begin
		if (reset_n == 0) begin
			gJ <= 0;
			gP <= 0;
		end else begin
			if (gregwe) begin
				case (gregwa)
				rJ: gJ <= gregwd;
				rP: gP <= gregwd;
				endcase
			end
		end
	end
	
endmodule

module regs(
	input logic clk,
	input	logic	reset_n,
	input logic	ra1_req,
	input logic	ra2_req,
	input logic	ra3_req,
	input logic	ra4_req,
	input logic[7:0] ra1,
	input logic[7:0] ra2,
	input logic[7:0] ra3,
	input logic[7:0] ra4,
	input logic we,
	input logic [7:0] wa,
	input logic[63:0] wd,
	output logic rd1_valid,
	output logic rd2_valid,
	output logic rd3_valid,
	output logic rd4_valid,
	output logic[63:0] rd1,
	output logic[63:0] rd2,
	output logic[63:0] rd3,
	output logic[63:0] rd4
	);
	
	// latch
	logic[63:0]	l_rd1, l_rd2, l_rd3, l_rd4;
	reg[7:0]	prev_ra1, prev_ra2, prev_ra3, prev_ra4;
	
	logic	rd1_invalid, rd2_invalid, rd3_invalid, rd4_invalid;
	reg[7:0]	ra;
	wire[63:0] rd;
	reg[2:0] state;
	
	sram rf(
		.clk,
		.reset_n,
		.ra,
		.we,
		.wa,
		.wd,
		.rd
	);
	
	assign rd1 = (state == 1) ? rd : l_rd1;
	assign rd2 = (state == 2) ? rd : l_rd2;
	assign rd3 = (state == 3) ? rd : l_rd3;
	assign rd4 = (state == 4) ? rd : l_rd4;
	
	assign rd1_valid = ~rd1_invalid;
	assign rd2_valid = ~rd2_invalid;
	assign rd3_valid = ~rd3_invalid;
	assign rd4_valid = ~rd4_invalid;
	
	assign rd1_invalid = (prev_ra1 != ra1) & (state != 1) & ra1_req;
	assign rd2_invalid = (prev_ra2 != ra2) & (state != 2) & ra2_req;
	assign rd3_invalid = (prev_ra3 != ra3) & (state != 3) & ra3_req;
	assign rd4_invalid = (prev_ra4 != ra4) & (state != 4) & ra4_req;
	
	always_ff @(posedge clk, negedge reset_n)
		if (reset_n == 0) begin
			prev_ra1 <= 0;
			prev_ra2 <= 0;
			prev_ra3 <= 0;
			prev_ra4 <= 0;
			ra <= 0;
			state <= 0;
		end else begin
			case (state)
			0: begin
					l_rd1 <= rd;
					l_rd2 <= rd;
					l_rd3 <= rd;
					l_rd4 <= rd;
				end
			1: begin
					prev_ra1 <= ra;
					l_rd1 <= rd;
				end
			2: begin
					prev_ra2 <= ra;
					l_rd2 <= rd;
				end
			3: begin
					prev_ra3 <= ra;
					l_rd3 <= rd;
				end
			4: begin
					prev_ra4 <= ra;
					l_rd4 <= rd;
				end
			endcase
			if (rd1_invalid | rd2_invalid) begin
				if (rd1_invalid) begin
					ra <= ra1;
					state <= 1;
				end else	begin
					ra <= ra2;
					state <= 2;
				end
			end else	begin
				if (rd3_invalid) begin
					ra <= ra3;
					state <= 3;
				end else if (rd4_invalid) begin
					ra <= ra4;
					state <= 4;
				end else
					state <= 5;
			end
			
			if (we) begin
				if (ra1_req) begin
					if (wa == ra1)
						l_rd1 <= wd;
				end else begin
					if (wa == prev_ra1)
						l_rd1 <= wd;
				end
				
				if (ra2_req) begin
					if (wa == ra2)
						l_rd2 <= wd;
				end else begin
					if (wa == prev_ra2)
						l_rd2 <= wd;
				end
				
				if (ra3_req) begin
					if (wa == ra3)
						l_rd3 <= wd;
				end else begin
					if (wa == prev_ra3)
						l_rd3 <= wd;
				end
				
				if (ra4_req) begin
					if (wa == ra4)
						l_rd4 <= wd;
				end else begin
					if (wa == prev_ra4)
						l_rd4 <= wd;
				end
				
			end
		end
	
endmodule

module sram(
	input logic clk,
	input	logic	reset_n,
	input logic[7:0] ra,
	input logic we,
	input logic [7:0] wa,
	input logic[63:0] wd,
	output logic[63:0] rd
);

	reg[63:0] ram[0:255];

	always_ff @(posedge clk, negedge reset_n)
		if (reset_n == 0) begin
		end else begin
			if (we)
				ram[wa] <= wd;
		end
	
	assign rd = ram[ra];
	
endmodule
