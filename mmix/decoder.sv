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

module inst_decoder(
	input	fetch			head,
	input wire [7:0]	G, L,
	input wire [60:0]	S, O,
	input logic[63:0]	J,
	
	output logic		stall,
//	
	output logic[7:0]		new_L,
	output logic[60:0]	new_O, new_S,

	output control			data,
	input  values			operands
	);

	internal_opcode internal_op[0:255] = '{
		trap,fcmp,funeq,funeq,fadd,fix,fsub,fix,
		flot,flot,flot,flot,flot,flot,flot,flot,
		fmul,feps,feps,feps,fdiv,fsqrt,frem,fint,
		mul,mul,mulu,mulu,div,div,divu,divu,
		add,add,addu,addu,sub,sub,subu,subu,
		addu,addu,addu,addu,addu,addu,addu,addu,
		cmp,cmp,cmpu,cmpu,sub,sub,subu,subu,
		shl,shl,shlu,shlu,shr,shr,shru,shru,
		br,br,br,br,br,br,br,br,
		br,br,br,br,br,br,br,br,
		pbr,pbr,pbr,pbr,pbr,pbr,pbr,pbr,
		pbr,pbr,pbr,pbr,pbr,pbr,pbr,pbr,
		cset,cset,cset,cset,cset,cset,cset,cset,
		cset,cset,cset,cset,cset,cset,cset,cset,
		zset,zset,zset,zset,zset,zset,zset,zset,
		zset,zset,zset,zset,zset,zset,zset,zset,
		ld,ld,ld,ld,ld,ld,ld,ld,
		ld,ld,ld,ld,ld,ld,ld,ld,
		ld,ld,ld,ld,cswap,cswap,ldunc,ldunc,
		ldvts,ldvts,preld,preld,prego,prego,go,go,
		pst,pst,pst,pst,pst,pst,pst,pst,
		pst,pst,pst,pst,st,st,st,st,
		pst,pst,pst,pst,st,st,st,st,
		syncd,syncd,prest,prest,syncid,syncid,pushgo,pushgo,
		or_,or_,orn,orn,nor_,nor_,xor_,xor_,
		and_,and_,andn,andn,nand_,nand_,nxor,nxor,
		bdif,bdif,wdif,wdif,tdif,tdif,odif,odif,
		mux,mux,sadd,sadd,mor,mor,mor,mor,
		set,set,set,set,addu,addu,addu,addu,
		or_,or_,or_,or_,andn,andn,andn,andn,
		jmp,jmp,pushj,pushj,set,set,put,put,
		pop,resume,save,unsave,sync,noop,get,trip
	};
	
	logic support[0:255] = '{
		1, 0, 0, 0, 0, 0, 0, 0,	// TRAP, FCMP, FUN, FEQL, FADD, FIX, FSUB, FIXU,
		0, 0, 0, 0, 0, 0, 0, 0, // FLOT, FLOTI, FLOTU, FLOTUI, SFLOT, SFLOTI, SFLOTU, SFLOTUI,
		0, 0, 0, 0, 0, 0, 0, 0, // FMUL, FCMPE, FUNE, FEQLE, FDIV, FSQRT, FREM, FINT,
		0, 0, 0, 0, 0, 0, 0, 0, // MUL, MULI, MULU, MULUI, DIV, DIVI, DIVU, DIVUI,
		1, 1, 1, 1, 1, 1, 1, 1, // ADD, ADDI, ADDU, ADDUI, SUB, SUBI, SUBU, SUBUI,
		0, 0, 0, 0, 0, 0, 0, 0, // IIADDU, IIADDUI, IVADDU, IVADDUI, VIIIADDU, VIIIADDUI, XVIADDU, XVIADDUI,
		1, 1, 1, 1, 1, 1, 1, 1, // CMP, CMPI, CMPU, CMPUI, NEG, NEGI, NEGU, NEGUI,
		1, 1, 1, 1, 1, 1, 1, 1, // SL, SLI, SLU, SLUI, SR, SRI, SRU, SRUI,
		1, 1, 1, 1, 1, 1, 1, 1, // BN, BNB, BZ, BZB, BP, BPB, BOD, BODB,
		1, 1, 1, 1, 1, 1, 1, 1, // BNN, BNNB, BNZ, BNZB, BNP, BNPB, BEV, BEVB,
		1, 1, 1, 1, 1, 1, 1, 1, // PBN, PBNB, PBZ, PBZB, PBP, PBPB, PBOD, PBODB,
		1, 1, 1, 1, 1, 1, 1, 1, // PBNN, PBNNB, PBNZ, PBNZB, PBNP, PBNPB, PBEV, PBEVB,
		1, 1, 1, 1, 1, 1, 1, 1, // CSN, CSNI, CSZ, CSZI, CSP, CSPI, CSOD, CSODI,
		1, 1, 1, 1, 1, 1, 1, 1, // CSNN, CSNNI, CSNZ, CSNZI, CSNP, CSNPI, CSEV, CSEVI,
		0, 0, 0, 0, 0, 0, 0, 0, // ZSN, ZSNI, ZSZ, ZSZI, ZSP, ZSPI, ZSOD, ZSODI,
		0, 0, 0, 0, 0, 0, 0, 0, // ZSNN, ZSNNI, ZSNZ, ZSNZI, ZSNP, ZSNPI, ZSEV, ZSEVI,
		1, 1, 1, 1, 1, 1, 1, 1, // LDB, LDBI, LDBU, LDBUI, LDW, LDWI, LDWU, LDWUI,
		1, 1, 1, 1, 1, 1, 1, 1, // LDT, LDTI, LDTU, LDTUI, LDO, LDOI, LDOU, LDOUI,
		0, 0, 0, 0, 1, 1, 0, 0, // LDSF, LDSFI, LDHT, LDHTI, CSWAP, CSWAPI, LDUNC, LDUNCI,
		0, 0, 0, 0, 0, 0, 1, 1, // LDVTS, LDVTSI, PRELD, PRELDI, PREGO, PREGOI, GO, GOI,
		1, 1, 1, 1, 1, 1, 1, 1, // STB, STBI, STBU, STBUI, STW, STWI, STWU, STWUI,
		1, 1, 1, 1, 1, 1, 1, 1, // STT, STTI, STTU, STTUI, STO, STOI, STOU, STOUI,
		0, 0, 0, 0, 1, 1, 0, 0, // STSF, STSFI, STHT, STHTI, STCO, STCOI, STUNC, STUNCI,
		1, 1, 0, 0, 0, 0, 1, 1, // SYNCD, SYNCDI, PREST, PRESTI, SYNCID, SYNCIDI, PUSHGO, PUSHGOI,
		1, 1, 1, 1, 1, 1, 1, 1, // OR, ORI, ORN, ORNI, NOR, NORI, XOR, XORI,
		1, 1, 1, 1, 1, 1, 1, 1, // AND, ANDI, ANDN, ANDNI, NAND, NANDI, NXOR, NXORI,
		0, 0, 0, 0, 0, 0, 0, 0, // BDIF, BDIFI, WDIF, WDIFI, TDIF, TDIFI, ODIF, ODIFI,
		0, 0, 0, 0, 0, 0, 0, 0, // MUX, MUXI, SADD, SADDI, MOR, MORI, MXOR, MXORI,
		1, 1, 1, 1, 1, 1, 1, 1, // SETH, SETMH, SETML, SETL, INCH, INCMH, INCML, INCL,
		1, 1, 1, 1, 1, 1, 1, 1, // ORH, ORMH, ORML, ORL, ANDNH, ANDNMH, ANDNML, ANDNL,
		1, 1, 1, 1, 1, 1, 1, 1, // JMP, JMPB, PUSHJ, PUSHJB, GETA, GETAB, PUT, PUTI,
		1, 0, 0, 1, 0, 0, 1, 1  // POP, RESUME, SAVE, UNSAVE, SYNC, SWYM, GET, TRIP
	};
	
	// 'h01 means Z is an immediate value
	// 'h02 means rZ is a source operand
	// 'h04 means Y is an immediate value
	// 'h08 means rY is a source operans
	// 'h10 means rX is a source operand
	// 'h20 means rX is a destination
	// 'h40 means YZ is part of a relative address
	// 'h80 means the control changes at this point
	parameter X_is_dest_bit   = 'h20;
	parameter rel_addr_bit    = 'h40;
	parameter ctl_change_bit  = 'h80;

	reg [7:0] flags[0:255] = '{
		'h8a,'h2a,'h2a,'h2a,'h2a,'h26,'h2a,'h26,	// TRAP
		'h26,'h25,'h26,'h25,'h26,'h25,'h26,'h25,	// FLOT
		'h2a,'h2a,'h2a,'h2a,'h2a,'h26,'h2a,'h26,	// FMUL
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h2a,'h29,'h2a,'h29,'h26,'h25,'h26,'h25,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h50,'h50,'h50,'h50,'h50,'h50,'h50,'h50,	// BN
		'h50,'h50,'h50,'h50,'h50,'h50,'h50,'h50,
		'h50,'h50,'h50,'h50,'h50,'h50,'h50,'h50,
		'h50,'h50,'h50,'h50,'h50,'h50,'h50,'h50,
		'h3a,'h39,'h3a,'h39,'h3a,'h39,'h3a,'h39,
		'h3a,'h39,'h3a,'h39,'h3a,'h39,'h3a,'h39,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,	// LDB
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h2a,'h29,'h2a,'h29,'h3a,'h39,'h2a,'h29,
		'h2a,'h29,'h0a,'h09,'h0a,'h09,'haa,'ha9,
		'h1a,'h19,'h1a,'h19,'h1a,'h19,'h1a,'h19,
		'h1a,'h19,'h1a,'h19,'h1a,'h19,'h1a,'h19,
		'h1a,'h19,'h1a,'h19,'h0a,'h09,'h1a,'h19,	// STSF
		'h0a,'h09,'h0a,'h09,'h0a,'h09,'haa,'ha9,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,	// OR
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h2a,'h29,'h2a,'h29,'h2a,'h29,'h2a,'h29,
		'h20,'h20,'h20,'h20,'h30,'h30,'h30,'h30,	// SETH
		'h30,'h30,'h30,'h30,'h30,'h30,'h30,'h30,
		'hc0,'hc0,'he0,'he0,'h60,'h60,'h02,'h01,
		'h80,'h80,'h00,'h02,'h01,'h00,'h20,'h8a
	};

	reg [7:0] third_operand[0:255] = '{
		0,rA,0,0,rA,rA,rA,rA,
		rA,rA,rA,rA,rA,rA,rA,rA,
		rA,rE,rE,rE,rA,rA,rA,rA,
		rA,rA,0,0,rA,rA,rD,rD,
		rA,rA,0,0,rA,rA,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,rA,rA,0,0,
		rA,rA,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		rA,rA,0,0,rA,rA,0,0,
		rA,rA,0,0,0,0,0,0,
		rA,rA,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		rM,rM,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,
		rJ,0,0,0,0,0,0,255
	};

//	logic	no_fetch;
	mmix_opcode		op;
	internal_opcode	i;
	reg [7:0]		f;

//	assign data.no_fetch = no_fetch;
	assign data.loc = head.loc;

	reg			dispatch_done;
	
	assign {data.op, data.xx, data.yy, data.zz} = head.inst;
	
	// labels
	logic pop_unsave;
	logic decrease_gamma;
	
	spec	yy_y;
	spec zz_z;
	
	yy_zz_decoder yy_zz_dec(
		.f			(f),
		.loc		(head.loc),
		.inst		(head.inst),
		.G			(G),
		.L			(L),
		.O			(O),
		.i,
		.y			(yy_y),
		.z			(zz_z)
	);

	
	always_comb begin
	
		pop_unsave = 0;
		decrease_gamma = 0;
		
		stall = 0;
		
		new_L = L;
		new_S = S;
		new_O = O;
		
		op = data.op;

//		if (~support[op]) begin
//			f = flags[TRAP];
//			i = trap;
//		end else if ((op == TRIP) && head.loc[63]) begin
//			f = 0;
//			i = noop;
//		end else begin
//			f = flags[op];
//			i = internal_op[op];
//		end
		if ((op == TRIP) && head.loc[63]) begin
			f = 0;
			i = noop;
		end else begin
			f = flags[op];
			if (~support[op])
				i = trap;
			else
				i = internal_op[op];
		end
		
		data.i = i;
		data.x = '{ 0, 0, 0, 0};
		data.a = '{ 0, 0, 0, 0};
		data.need_b = 0;
		data.need_ra = 0;
		data.ren_x = 0;
		data.mem_x = 0;
		data.ren_a = 0;
		data.interrupt = head.interrupt;
		data.interim = 0;
		data.go = '{ data.loc + 4, 0, 0, 0};
		data.owner = 0;
		
		//if (head->noted) peek_hist=head->hist;
		//else
		// @<Redirect the fetch if control changes at this inst@>=
//		ctl_change = 0;
//		inst_ptr = 0;
//		if (f & ctl_change_bit) begin
//			case (i)
//			jmp, br, pbr, pushj: begin
//					ctl_change = 1;
//					inst_ptr = zz_z.o;
//				end
//			pop: begin
//					ctl_change = 1;
//					inst_ptr = J + (head.inst[15:0] << 2);
//				end
////			go, pushgo, trap, resume, syncid:
////				stage <= S_HALT;
////			trip:
////				stage <= S_HALT;					
//			endcase
//		end
		
		if (f & X_is_dest_bit) begin
			if (data.xx >= G) begin
				if (i != pushgo && i != pushj && i != cswap)
					data.ren_x = 1;
					data.x = '{0, 0, 2'b01, data.xx};
			end else if (data.xx < L) begin
				if (i != cswap) begin
					data.ren_x = 1;
					data.x = '{0, 0, 2'b10, (O + data.xx) & lring_mask };
				end
			end
		end
		
		if ((f & X_is_dest_bit) && (data.xx >= L) && (data.xx < G)) begin
//			no_fetch = 1;
			
			// @<Install register X as the destination, or insert
			// an internal command and |goto dispatch_done| if X is marginal@>;
			if (((S - O - L - 1) & lring_mask) == 0) begin
				// @<Insert an instruction to advance gamma@>=
				data.b = '{ 0, 2, S & lring_mask };
				data.ra = '{0, 0, 0};
				data.i = incgamma;
				new_S = S + 1;
				data.y = '{ S << 3, 0, 0 };
				data.z = '{ 0, 0, 0 };
				data.mem_x = 1;
				data.x = '{ 0, 0, 0, 0 };
				op = STOU;
				data.interim = 1;
				data.stack_alert = 1;
			end else begin
				// @<Insert an instruction to advance beta and L@>=
				data.b = '{ 0, 2, S & lring_mask };
				data.ra = '{0, 0, 0};
				data.i = incrl;
				data.x = '{0, 1, 2'b10, (O + L) & lring_mask};
				new_L = L + 1;
				data.y = '{ 0, 0, 0 };
				data.z = '{ 0, 0, 0 };
				data.mem_x = 0;
				op = SETH; /* this instruction to be handled by the simplest units */
				data.interim = 1;
				data.stack_alert = 0;
			end
		end else begin
//			no_fetch = 0;
			
			data.mem_x = 0;
			data.interim = 0;
			data.stack_alert = 0;
			
			dispatch_done = 0;
			
			// assign y & z
			data.z = zz_z;
			
			if ((op[7:4] == 4'he) && (i != set)) begin
				if (data.xx >= G) begin
					data.y = '{ 0, 1, data.xx};
				end else begin
					data.y = '{ 0, 2, (O + data.xx) & lring_mask };
				end
			end else begin
				data.y = yy_y;
			end
			
			// @ @<Install the operand fields of the |cool| block@>=
			if (f & 8'h10) begin
				if (data.xx >= G) begin
					data.b = '{ 0, 1, data.xx};
				end else if (data.xx < L) begin
					data.b = '{ 0, 2, (O + data.xx) & lring_mask };
				end else begin
					data.b = '{ 0, 0, 0 };
				end
			end else if ((op & 'hfe) == STCO) begin
				data.b = '{ data.xx, 0, 0 };
			end else begin
				data.b = '{ 0, 0, 0 };
			end

			if (third_operand[op] && (i != trap)) begin
				if (third_operand[op] == rA || third_operand[op] == rE) begin
					data.ra = '{ 0, 1, rA };
				end else begin
					data.ra = '{ 0, 0, 0 };
				end
				if (third_operand[op] != rA) begin
					data.b = '{ 0, 1, third_operand[op] };
				end
			end else begin
				data.ra = '{ 0, 0, 0 };
			end

			case (i)
			cswap: begin
					data.ren_a = 1;
					if (data.xx >= G)
						data.a = '{ 0, 0, 1, data.xx };
					else
						data.a = '{ 0, 0, 2, (O + data.xx) & lring_mask };
					//data.i = pst;
				end
			st:
				begin
					
				end
			pst:
				begin
					data.mem_x = 1;
					// spec_install (&mem, &cool->x);
				end
			ld:
				begin
					// cool->ptr_a = (void *)mem.up;
				end
			// @<Special cases of instruction dispatch@>=
			put: begin
					if ((data.yy != 0) || (data.xx >= 32)) begin
						data.interrupt[B_BIT] = 1;
						data.i = noop;
					end else begin
						if ((data.xx >= 9) && (data.xx <= 11))	begin
							data.interrupt[B_BIT] = 1;
							data.i = noop;
						end else if ((data.xx >= 8) && (data.xx <= 18) && ~data.loc[63]) begin
							data.interrupt[K_BIT] = 1;
							data.i = noop;
						end else begin
//							if ((data.xx == 8) || ((data.xx >= 15) && (data.xx <= 20)))
//								freeze_dispatch = 1;
							data.ren_x = 1;
							data.x = '{ 0, 0, 2'b01, data.xx };
						end
					end
				end
			get: begin
					if ((data.yy != 0) || (data.zz >= 32)) begin
						data.interrupt[B_BIT] = 1;
						data.i = noop;
					end else begin
						case (data.zz)
						rO: data.z.o = O << 3;
						rS: data.z.o = S << 3;
						rG: data.z.o = G;
						rL: data.z.o = L;
						default: data.z = '{0, 2'b01, data.zz };
						endcase
					end
				end
			pushgo, pushj: begin
				if ((data.xx >= G) && (((S - O - L - 1) & lring_mask) == 0)) begin
					// @<Insert an instruction to advance gamma@>=
			      data.need_b = 0;
					data.need_ra = 0;
			      data.i = incgamma;
			      new_S = S + 1;
			      data.b = '{ 0, 2'b10, S & lring_mask};
			      data.y = '{ S << 3, 2'b00, 0 };
			      data.z = '{ 0, 0, 0};
			      data.mem_x = 1;
					// spec_install (&mem, &cool.x);
			      op = STOU;
			      data.interim = 1;
					data.stack_alert = 1;
				end else begin
					if (data.xx >= G) begin
						data.ren_x = 1;
						data.x = '{ L, 1, 2'b10, (O + L) & lring_mask };
						data.ren_a = 1;
						data.a = '{ data.loc + 4, 1, 2'b01, rJ };
						//cool.set_l = true, spec_install (&g[rL], &cool.rl);
						//cool.rl.o.l = cool_L - x - 1;
						new_L = 0;
						new_O = O + L + 1;
					end else begin
						//data.x = '{ data.xx, 1, 0, 0 };
						data.x.known = 1;
						data.x.o = data.xx;
						data.ren_a = 1;
						data.a = '{ data.loc + 4, 1, 2'b01, rJ };
						//cool.set_l = true, spec_install (&g[rL], &cool.rl);
						//cool.rl.o.l = cool_L - x - 1;
						new_L = L - data.xx - 1;
						new_O = O + data.xx + 1;
					end
				end
			end
			pop: begin
				if (data.xx && L >= data.xx)
					data.y = '{ 0, 2'b10, (O + data.xx - 1) & lring_mask};
				// pop_unsave:
				pop_unsave = 1;
			end
			trap: begin
					data.ra = '{ 0, 2'b01, rT};
					data.b = '{ 0, 2'b01, 255};
					data.ren_x = 1;
					data.x = '{ J, 1, 2'b01, 255};
					data.ren_a = 1;
					data.a = '{ 0, 0, 2'b01, rBB};
					if (f & X_is_dest_bit)
						data.interrupt[26:19] = RESUME_SET;
					else
						data.interrupt[26:19] = 'h80;
				end
			unsave: begin
					if (data.interrupt[B_BIT]) begin
						data.i = noop;
					end else begin
						data.interim = 1;
						op = LDOU;
						data.i = unsav;
						case (data.xx)
						0: begin
								if (~operands.z.valid) begin
									stall = 1;
								end else begin
									//cool->ren_x = true, spec_install (&g[rG], &cool->x);
									data.ren_a = 1;
									data.a = '{ 0, 0, 2'b01, rA };
									new_O = operands.z.o >> 3;
									new_S = operands.z.o >> 3;
									new_L = 0;
								end
							end
						1, 2: begin
								data.ren_x = 1;
								data.x = '{ 0, 0, 2'b01, data.yy};
								new_O = O - 1;
								new_S = O - 1;
								data.z = '{ new_O << 3, 0, 0};
							end
						3: begin
								data.i = unsave;
								data.interim = 0;
								op = UNSAVE;
								
								//goto pop_unsave;
								pop_unsave = 1;
							end
						default: begin
								data.interim = 0;
								data.i = noop;
								data.interrupt[B_BIT] = 1;
							end
						endcase
					end
				end
			endcase
		
		end
		
		if (pop_unsave) begin
			if (S == O) begin
				// assume lring_size is large enough.
				decrease_gamma = 1;
			end else begin
				// use ra to read l reg
				data.ra = '{ 0, 2'b10, (O - 1) & lring_mask };
				if (~operands.ra.valid)
					stall = 1;
				else begin
					// now, operands.ra.o is new L
					if ((O - S) <= operands.ra.o[7:0]) begin
						// assume lring_size is large enough.
						decrease_gamma = 1;
					end else begin
						new_O = O - operands.ra.o[7:0] - 1;
						new_L = operands.ra.o[7:0] + (data.xx <= L ? data.xx : L + 1);
						if (new_L > G)
							new_L = G;
						if (operands.ra.o[7:0] < new_L) begin
							data.ren_x = 1;
							//spec_install (&l[(cool_O.l - 1) & lring_mask], &cool->x);
							data.x = '{0, 0, 2'b10, (O - 1) & lring_mask };
						end
						data.z.o = head.inst[15:0] << 2;
					end
				end
			end
		end	// pop_unsave

		if (decrease_gamma) begin
			data.i = decgamma;
			new_S = S - 1;
			data.y = '{ new_S << 3, 2'b00, 0 };
			// spec_install (&l[new_S.l & lring_mask], &cool->x);
			data.x = '{ 0, 0, 2'b10, new_S & lring_mask };
			op = LDOU;
			//cool->ptr_a = (void *) mem.up;
			data.z = '{ 0, 0, 0 };
			data.b = '{ 0, 0, 0 };
			data.need_b = 0;
			data.ren_x = 1;
			data.interim = 1;
		end
		
	end
	
endmodule

module yy_zz_decoder(
	input logic [7:0]		f,
	input logic [63:0]	loc,
	input logic [31:0]	inst,
	input logic [7:0]		G,
	input logic [7:0]		L,
	input logic [60:0]		O,
	input internal_opcode	i,
	output spec			y,
	output spec			z
);

	parameter lring_mask = 255;
	parameter X_is_dest_bit   = 'h20;
	parameter rel_addr_bit    = 'h40;
	parameter ctl_change_bit  = 'h80;

	logic [7:0] op, yy, zz;
	assign op = inst[31:24];
	assign yy = inst[15:8];
	assign zz = inst[7:0];
	
	always_comb begin
		if (f & rel_addr_bit) begin
			// @ @<Convert relative...@>=
			y = '{ loc + 4, 0, 0 };
			
			if ((op & 'hfe) == JMP)
				z = '{ loc + {{38{inst[24]}}, inst[23:0], 2'b00}, 0, 0 };
			else
				z = '{ loc + {{46{inst[24]}}, inst[15:0], 2'b00}, 0, 0 };
		end else begin

			if (op[7:4] == 4'he) begin
				case (op&3)
				0: z = '{ inst[15:0] << 48, 0, 0};
				1: z = '{ inst[15:0] << 32, 0, 0};
				2: z = '{ inst[15:0] << 16, 0, 0};
				3: z = '{ inst[15:0], 0, 0 };
				endcase
			end else begin
				if (f[0])
					z = '{ zz, 0, 0};
				else if (f[1]) begin
					if (zz >= G)
						z = '{ 0, 1, zz};
					else
						z = '{ 0, 2, (O + zz) & lring_mask };
				end else
					z = '{ 0, 0, 0 };
			end
			
			if (f[2])
				y = '{ yy, 0, 0};
			else if (f[3]) begin
				if (yy >= G)
					y = '{ 0, 1, yy};
				else
					y = '{ 0, 2, (O + yy) & lring_mask };
			end else
				y = '{ 0, 0, 0 };
		end
	end

endmodule
