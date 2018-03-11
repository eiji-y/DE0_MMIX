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

module exec_unit (
	input  logic		clk,
	input  logic		reset_n,
	input  logic		enable,
	
	input  control			data,
	input  values			operands,
	
	input  logic[7:0]		G, L,
	input  logic[60:0]	O, S,
	input  logic[63:0]	P,
	
	output logic			done,
	output control			data_out,
	
	output logic[7:0]		new_G,
	
	output logic[63:0]	mem_address,
	output logic[1:0]		mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
	output logic			mem_read,
	input  logic[63:0]	mem_readdata,
	output logic			mem_write,
	output logic[63:0]	mem_writedata,
	input  logic			mem_done
	);
	
	parameter lring_size	= 256;
	parameter lring_mask	= (lring_size - 1);
	

	logic[7:0]	alu_new_G;
	control		alu_data;
	logic			alu_done;

	logic[7:0]	lsu_new_G;
	control		lsu_data;
	logic			lsu_done;
	
	al_unit		alu1(
		.clk,
		.reset_n,
		.enable,
		
		.G, .L,
		.data_in		(data),
		.operands,
		
		.new_G		(alu_new_G),
		.data			(alu_data),
		
		.done		(alu_done)
	);
	
	ld_st_unit	lsu1(
		.clk,
		.reset_n,
		.enable,
		
		.G,
		.P,
		.data_in		(data),
		.operands,
		
		// result
		.data_out	(lsu_data),
		
		// memory
		.mem_address,
		.mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
		.mem_read,
		.mem_readdata,
		.mem_write,
		.mem_writedata,
		.mem_done,
		
		// control
		.new_G		(lsu_new_G),
		.done			(lsu_done)
	);
	
	assign done = alu_done | lsu_done;
	assign new_G = alu_done ? alu_new_G : lsu_new_G;
	assign data_out = alu_done ? alu_data : lsu_data;
	
endmodule

module al_unit(
	input	 logic		clk,
	input  logic		reset_n,
	input  logic		enable,
	
	input  logic[7:0]		G, L,

	input  control			data_in,
	input  values			operands,
	
	output logic[7:0]		new_G,
	output control			data,

	output logic			done
	);

	function logic[6:0] shift_amt(input[63:0] z);
		shift_amt = (z >= 64) ? 7'd64 : z;
	endfunction

	always_comb begin
		new_G = G;
		data = data_in;
		data.owner = 0;
		
		if (~reset_n) begin
			done = 0;
		end else begin
			done = 0;
			if (enable) begin
				if (operands.y.valid && operands.z.valid && operands.b.valid && operands.ra.valid) begin
					done = 1;
					case (data.i)
					set: begin
							data.x.o = operands.z.o;
						end
					or_: begin
							data.x.o = operands.y.o | operands.z.o;
						end
					orn: begin
							data.x.o = operands.y.o | ~operands.z.o;
						end
					nor_: begin
							data.x.o = ~(operands.y.o | operands.z.o);
						end
					and_: begin
							data.x.o = operands.y.o & operands.z.o;
						end
					andn: begin
							data.x.o = operands.y.o & ~operands.z.o;
						end
					nand_: begin
							data.x.o = ~(operands.y.o & operands.z.o);
						end
					xor_: begin
							data.x.o = operands.y.o ^ operands.z.o;
						end
					nxor: begin
							data.x.o = operands.y.o ^ ~operands.z.o;
						end
					///
					addu: begin
							case (data.op[7:1])
								(IIADDU>>1): data.x.o = (operands.y.o << 1) + operands.z.o;
								(IVADDU>>1): data.x.o = (operands.y.o << 2) + operands.z.o;
								(VIIIADDU>>1): data.x.o = (operands.y.o << 3) + operands.z.o;
								(XVIADDU>>1): data.x.o = (operands.y.o << 4) + operands.z.o;
								default: data.x.o = operands.y.o + operands.z.o; 
							endcase
						end
					subu: begin
							data.x.o = operands.y.o - operands.z.o;
						end
					add: begin
							{data.interrupt[V_BIT], data.x.o } = operands.y.o + operands.z.o;
						end
					sub: begin
							{data.interrupt[V_BIT], data.x.o } = operands.y.o - operands.z.o;
						end
					shlu: begin
							data.x.o = operands.y.o << shift_amt(operands.z.o);
						end
					shl: begin
							data.x.o = operands.y.o << shift_amt(operands.z.o);
							if ($signed(data.x.o) >>> shift_amt(operands.z.o) != operands.y.o)
								data.interrupt[V_BIT] = 1;
						end
					shru: begin
							data.x.o = operands.y.o >> shift_amt(operands.z.o);
						end
					shr: begin
							data.x.o = $signed(operands.y.o) >>> shift_amt(operands.z.o);
						end

					cmp: begin
							if (operands.y.o[63] > operands.z.o[63])	// sign bit
								data.x.o = 64'hffffffffffffffff;
							else if (operands.y.o[63] < operands.z.o[63])
								data.x.o = 64'h0000000000000001;
							else if (operands.y.o < operands.z.o)
								data.x.o = 64'hffffffffffffffff;
							else if (operands.y.o > operands.z.o)
								data.x.o = 64'h0000000000000001;
							else
								data.x.o = 64'h0000000000000000;
						end
					cmpu: begin
							if (operands.y.o < operands.z.o)
								data.x.o = 64'hffffffffffffffff;
							else if (operands.y.o > operands.z.o)
								data.x.o = 64'h0000000000000001;
							else
								data.x.o = 64'h0000000000000000;
						end
						
					cset: begin
							if (register_truth(operands.y.o, data.op))
							  data.x.o = operands.z.o;
							else
							  data.x.o = operands.b.o;
						end

						
					br, pbr: begin
							if (register_truth(operands.b.o, data.op))
								data.go.o = operands.z.o;
							else
								data.go.o = operands.y.o;
								
							//inst_ptr.o = data.go.o;
							//inst_ptr.p = 0;
							
							if (!data.loc[63]) begin
								if (data.go.o[63])
									data.interrupt[P_BIT] = 1;
								else
									data.interrupt[P_BIT] = 0;
							end
						end
					incrl, unsave: begin
//							data.x.o = data.x.o;
						end
					jmp, pushj: begin
							data.go.o = operands.z.o;
						end
					get: begin
							//if (data->zz >= 21 || data->zz == rK
							// || data->zz == rQ)
							//  {
							// if (data != old_hot)
							//wait (1);
							// data->z.o = g[data->zz].o;
							//  }
							data.x.o = operands.z.o;
						end
					put: begin
//							if ((data.xx == 8) || (data.xx >= 15 && data.xx <= 20)) begin
//								// wait hot
//							end
							case (data.xx)
//			      case rV:	/*239: */
//				{
//				  octa rv;
//				  rv = data->z.o;
//				  page_f = rv.l & 7, page_bad = (page_f > 1);
//				  page_n = rv.l & 0x1ff8;
//				  rv = shift_right (rv, 13, 1);
//				  page_r = rv.l & 0x7ffffff;
//				  rv = shift_right (rv, 27, 1);
//				  page_s = rv.l & 0xff;
//				  if (page_s < 13 || page_s > 48)
//				    page_bad = true;
//				  else if (page_s < 32)
//				    page_mask.h = 0, page_mask.l =
//				      (1 << page_s) - 1;
//				  else
//				    page_mask.h =
//				      (1 << (page_s - 32)) - 1, page_mask.l =
//				      0xffffffff;
//				  page_b[4] = (rv.l >> 8) & 0xf;
//				  page_b[3] = (rv.l >> 12) & 0xf;
//				  page_b[2] = (rv.l >> 16) & 0xf;
//				  page_b[1] = (rv.l >> 20) & 0xf;
//				}
//				break;
//			      case rQ:
//				new_Q.h |= data->z.o.h & ~g[rQ].o.h;
//				new_Q.l |= data->z.o.l & ~g[rQ].o.l;
//				data->z.o.l |= new_Q.l;
//				data->z.o.h |= new_Q.h;
//				break;
//			      case rL:
//				if (data->z.o.h != 0)
//				  data->z.o.h = 0, data->z.o.l = g[rL].o.l;
//				else if (data->z.o.l > g[rL].o.l)
//				  data->z.o.l = g[rL].o.l;
//			      default:
//				break;
							rG: begin
									if (|data.z.o[63:8] || (data.z.o[7:0] < L) || (data.z.o[7:0] < 32)) begin
										data.interrupt[B_BIT] = 1;
										data.x.o = rG;
									end else if (data.z.o[7:0] < G) begin
										new_G = G - 1'b1;
										data.x = '{ 0, 1, 2'b01, new_G };
										if (data.z.o[7:0] == new_G)
											data.interim = 0;
										else begin
											data.interim = 1;
											data.owner = 1;
										end
									end
								end
							rA: begin
									if (|operands.z.o[63:18])
										data.interrupt[B_BIT] = 1;
									data.x.o = operands.z.o & 'h3ffff;
								end
							default: begin
									data.x.o = operands.z.o;
								end
							endcase
						end
					pop: begin
							data.x.o = operands.y.o;
							//data.y.o = data.b.o;
							data.go.o = operands.b.o + operands.z.o;
							if (data.go.o[63] && !data.loc[63])
								data.interrupt[P_BIT] = 1;
						end
					go, pushgo: begin
							if (data.i == go) begin
								data.x.o = data.go.o;
							end
							data.go.o = operands.y.o + operands.z.o;
							if (data.go.o[63] && !data.loc[63])
								data.interrupt[P_BIT] = 1;
						end
					trap: begin
							data.interrupt[F_BIT] = 1;
							data.a.o = operands.b.o;
						end
					resum: begin
//							data.go = '{ WW, 1, 0, 0};
//							data.a = '{ g255, 1, 2'b01, rK };
//							data.x = '{ rBB, 1, 2'b01, 255 };
//							data.y = '{ 0, 2'b01, rWW};
//							data.z = '{ 0, 2'b01, rXX};
//							data.b = '{ 0, 2'b01, rBB};
//							data.ra = '{ 0, 2'b01, 255};
							data.go.o = operands.y.o;
							data.a.o = operands.ra.o;
							data.a.known = 1;
							data.x.o = operands.b.o;
							data.x.known = 1;
						end
					default: begin
							done = 0;
						end
					endcase
				end
			end
			
			if (data.ren_x) begin
				data.x.known = 1;
			end
		end
	end
	

	function logic register_truth(input [63:0] o, input [7:0] op);
		logic b;
		
		case (op[2:1])
		0: begin	// BN: branch if negative
				b = o[63];
			end
		1: begin	// BZ: branch if zero
				b = ~|o;
			end
		2: begin	// BP: branch if positive
				b = ~o[63] & |o[62:0];
			end
		3: begin	// BOD: branch if odd
				b = o[0];
			end
		endcase
		
		if (op[3])
			register_truth = b ^ 1'b1;
		else
			register_truth = b;
	endfunction

endmodule

module ld_st_unit(
	input	 logic		clk,
	input  logic		reset_n,
	input  logic		enable,
	
	input  logic[7:0]		G,
	input  logic[63:0]	P,

	input  control			data_in,
	input  values			operands,
	
	// output
	output control			data_out,
	
	// memory
	output logic[63:0]	mem_address,
	output logic[1:0]		mem_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
	output logic			mem_read,
	input  logic[63:0]	mem_readdata,
	output logic			mem_write,
	output logic[63:0]	mem_writedata,
	input  logic			mem_done,
	
	// control
	output logic[7:0]		new_G,
	output logic			done
	);

	enum {
		S_RESET,
		S_IDLE,
		S_MEMWRITE,
		S_MEMREAD
	} state, next_state;
	
	control	data;
	
	assign data_out = data;
	
	assign mem_read = ((state == S_MEMREAD) || (next_state == S_MEMREAD))
								&& operands.y.valid && operands.z.valid;
	assign mem_write = ((state == S_MEMWRITE) || (next_state == S_MEMWRITE)) && (state != S_MEMREAD)
								&& operands.y.valid && operands.z.valid && operands.b.valid;
	
	assign mem_address = operands.y.o + operands.z.o;
	assign mem_writedata = operands.b.o;
	
	always_comb begin
		case (data.op[7:2])
		(LDB>>2), (STB>>2): mem_datasize = 2'b00;
		(LDW>>2), (STW>>2): mem_datasize = 2'b01;
		(LDT>>2), (STT>>2): mem_datasize = 2'b10;
//		(LDO>>2), (STO>>2): mem_datasize = 2'b11;
		default: mem_datasize = 2'b11;
		endcase
	end
	
	always_comb begin
		new_G = G;
		data = data_in;
		data.owner = 0;
		done = 0;
		
		case (state)
		S_RESET: begin
				next_state = S_IDLE;
			end
		S_IDLE: begin
				next_state = S_IDLE;
				if (enable) begin
					case (data.i)
					ld: begin
							next_state = S_MEMREAD;
						end
					st, incgamma: begin
							next_state = S_MEMWRITE;
						end
					pst: begin
							next_state = S_MEMWRITE;
						end
					cswap: begin
							next_state = S_MEMREAD;
						end
						
					syncd: begin
						done = 1;
						end
						
					decgamma, unsav: begin
							next_state = S_MEMREAD;
						end
					endcase
				end
			end
		S_MEMWRITE: begin		// mem write
				if (mem_done) begin
					case (data.op >> 1)
						(STB>>1):
							if (operands.b.o[63:8] != 0)
								data.interrupt[V_BIT] = 1;
						(STW>>1):
							if (operands.b.o[63:16] != 0)
								data.interrupt[V_BIT] = 1;
						(STT>>1):
							if (operands.b.o[63:32] != 0)
								data.interrupt[V_BIT] = 1;
						(CSWAP>>1):
							//if (mem_readdata == P)
								data.a.o = 1;
					endcase
					
					done = 1;
					next_state = S_IDLE;
				end else begin
					next_state = S_MEMWRITE;
				end
			end
		S_MEMREAD: begin		// mem read
				if (mem_done) begin
					if (data.ren_x) begin
						data.x.o = mem_readdata;
						data.x.known = 1;
					end
						
					case (data.op >> 1)
						(LDB>>1): begin
								data.x.o = { {56{mem_readdata[7]}}, mem_readdata[7:0] };
							end
						(LDBU>>1): begin
								data.x.o = { 56'b0, mem_readdata[7:0] };
							end
						(LDW>>1): begin
								data.x.o = { {48{mem_readdata[15]}}, mem_readdata[15:0] };
							end
						(LDWU>>1): begin
								data.x.o = { 48'b0, mem_readdata[15:0] };
							end
						(LDT>>1): begin
								data.x.o = { {32{mem_readdata[31]}}, mem_readdata[31:0] };
							end
						(LDTU>>1): begin
								data.x.o = { 32'b0, mem_readdata[31:0] };
							end
						(LDO>>1), (LDOU>>1): begin
								data.x.o = mem_readdata[63:0];
							end
						(UNSAVE >> 1): begin
							if (data.xx == 0) begin
								new_G = mem_readdata[63:56];
								data.a.o = mem_readdata[17:0];
								data.a.known = 1;
								if (mem_readdata & 64'h00fffffffffc0000)
									data.interrupt[B_BIT] = 1;
							end
						end
							
					endcase
					
					if (data.i == cswap) begin
						if (mem_readdata == P) begin
//							data.a.o = 1;
							next_state = S_MEMWRITE;
						end else begin
							data.ren_x = 1;
							data.x = '{mem_readdata, 1, 2'b01, rP };

							done = 1;
							next_state = S_IDLE;
						end
					end else begin
						done = 1;
						next_state = S_IDLE;
					end
					
				end else begin
					next_state = S_MEMREAD;
				end
			end
		endcase
	end

	always_ff @(posedge clk, negedge reset_n) begin
		if (~reset_n)
			state <= S_RESET;
		else
			state <= next_state;
	end

endmodule
