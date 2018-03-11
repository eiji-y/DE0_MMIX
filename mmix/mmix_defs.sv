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

// local register size
parameter lring_size	= 256;
parameter lring_mask	= (lring_size - 1);

// interrupt bits
parameter P_BIT = 0; /* instruction in privileged location */
parameter S_BIT = 1; /* security violation */
parameter B_BIT = 2; /* instruction breaks the rules */
parameter K_BIT = 3; /* instruction for kernel only */
parameter N_BIT = 4; /* virtual translation bypassed */
parameter PX_BIT = 5; /* permission lacking to execute from page */
parameter PW_BIT = 6; /* permission lacking to write on page */
parameter PR_BIT = 7; /* permission lacking to read from page */
parameter X_BIT = 8; /* floating inexact */
parameter Z_BIT = 9; /* floating division by zero */
parameter U_BIT = 10; /* floating underflow */
parameter O_BIT = 11; /* floating overflow */
parameter I_BIT = 12; /* floating invalid operation */
parameter W_BIT = 13; /* float-to-fix overflow */
parameter V_BIT = 14; /* integer overflow */
parameter D_BIT = 15; /* integer divide check */
parameter H_BIT = 16; /* trip handler bit */
parameter F_BIT = 17; /* forced trap bit */
parameter E_BIT = 18; /* external (dynamic) trap bit */

parameter RESUME_AGAIN = 0;	/* repeat the command in rX as if in location rW − 4 */
parameter RESUME_CONT = 1;		/* same, but substitute rY and rZ for operands */
parameter RESUME_SET = 2;		/* set r[X] to rZ */
parameter RESUME_TRANS = 3;	/* install (rY, rZ) into IT-cache or DT-cache, then RESUME_AGAIN */

// Special Register Numbers
parameter rA = 21; /* arithmetic status register */
parameter rB = 0;  /* bootstrap register (trip) */
parameter rC = 8;  /* continuation register */
parameter rD = 1;  /* dividend register */
parameter rE = 2;  /* epsilon register */
parameter rF = 22; /* failure location register */
parameter rG = 19; /* global threshold register */
parameter rH = 3;  /* himult register */
parameter rI = 12; /* interval counter */
parameter rJ = 4;  /* return-jump register */
parameter rK = 15; /* interrupt mask register */
parameter rL = 20; /* local threshold register */
parameter rM = 5;  /* multiplex mask register */
parameter rN = 9;  /* serial number */
parameter rO = 10; /* register stack offset */
parameter rP = 23; /* prediction register */
parameter rQ = 16; /* interrupt request register */
parameter rR = 6;  /* remainder register */
parameter rS = 11; /* register stack pointer */
parameter rT = 13; /* trap address register */
parameter rU = 17; /* usage counter */
parameter rV = 18; /* virtual translation register */
parameter rW = 24; /* where-interrupted register (trip) */
parameter rX = 25; /* execution register (trip) */
parameter rY = 26; /* Y operand (trip) */
parameter rZ = 27; /* Z operand (trip) */
parameter rBB = 7;  /* bootstrap register (trap) */
parameter rTT = 14; /* dynamic trap address register */
parameter rWW = 28; /* where-interrupted register (trap) */
parameter rXX = 29; /* execution register (trap) */
parameter rYY = 30; /* Y operand (trap) */
parameter rZZ = 31; /* Z operand (trap) */

typedef enum bit[7:0] {
	TRAP, FCMP, FUN, FEQL, FADD, FIX, FSUB, FIXU,									// FPU
	FLOT, FLOTI, FLOTU, FLOTUI, SFLOT, SFLOTI, SFLOTU, SFLOTUI,					// FPU
	FMUL, FCMPE, FUNE, FEQLE, FDIV, FSQRT, FREM, FINT,								// MUL, DIV, FPU
	MUL, MULI, MULU, MULUI, DIV, DIVI, DIVU, DIVUI,									// MUL, DIV 
	ADD, ADDI, ADDU, ADDUI, SUB, SUBI, SUBU, SUBUI,									// ALU
	IIADDU, IIADDUI, IVADDU, IVADDUI, VIIIADDU, VIIIADDUI, XVIADDU, XVIADDUI,	// ALU
	CMP, CMPI, CMPU, CMPUI, NEG, NEGI, NEGU, NEGUI,									// ALU
	SL, SLI, SLU, SLUI, SR, SRI, SRU, SRUI,											// ALU
	BN, BNB, BZ, BZB, BP, BPB, BOD, BODB,												// ALU
	BNN, BNNB, BNZ, BNZB, BNP, BNPB, BEV, BEVB,										// ALU
	PBN, PBNB, PBZ, PBZB, PBP, PBPB, PBOD, PBODB,									// ALU
	PBNN, PBNNB, PBNZ, PBNZB, PBNP, PBNPB, PBEV, PBEVB,							// ALU
	CSN, CSNI, CSZ, CSZI, CSP, CSPI, CSOD, CSODI,									// ALU
	CSNN, CSNNI, CSNZ, CSNZI, CSNP, CSNPI, CSEV, CSEVI,							// ALU
	ZSN, ZSNI, ZSZ, ZSZI, ZSP, ZSPI, ZSOD, ZSODI,									// ALU
	ZSNN, ZSNNI, ZSNZ, ZSNZI, ZSNP, ZSNPI, ZSEV, ZSEVI,							// ALU
	LDB, LDBI, LDBU, LDBUI, LDW, LDWI, LDWU, LDWUI,									// LSU
	LDT, LDTI, LDTU, LDTUI, LDO, LDOI, LDOU, LDOUI,									// LSU
	LDSF, LDSFI, LDHT, LDHTI, CSWAP, CSWAPI, LDUNC, LDUNCI,						// LSU
	LDVTS, LDVTSI, PRELD, PRELDI, PREGO, PREGOI, GO, GOI,							// LSU, ALU
	STB, STBI, STBU, STBUI, STW, STWI, STWU, STWUI,									// LSU
	STT, STTI, STTU, STTUI, STO, STOI, STOU, STOUI,									// LSU
	STSF, STSFI, STHT, STHTI, STCO, STCOI, STUNC, STUNCI,							// LSU
	SYNCD, SYNCDI, PREST, PRESTI, SYNCID, SYNCIDI, PUSHGO, PUSHGOI,			// LSU, ALU
	OR, ORI, ORN, ORNI, NOR, NORI, XOR, XORI,											// ALU
	AND, ANDI, ANDN, ANDNI, NAND, NANDI, NXOR, NXORI,								// ALU
	BDIF, BDIFI, WDIF, WDIFI, TDIF, TDIFI, ODIF, ODIFI,							// ALU
	MUX, MUXI, SADD, SADDI, MOR, MORI, MXOR, MXORI,									// ALU
	SETH, SETMH, SETML, SETL, INCH, INCMH, INCML, INCL,							// ALU
	ORH, ORMH, ORML, ORL, ANDNH, ANDNMH, ANDNML, ANDNL,							// ALU
	JMP, JMPB, PUSHJ, PUSHJB, GETA, GETAB, PUT, PUTI,								// ALU
	POP, RESUME, SAVE, UNSAVE, SYNC, SWYM, GET, TRIP								// ALU
} mmix_opcode;

typedef enum bit[6:0] {
	mul0,
	mul1,
	mul2,
	mul3,
	mul4,
	mul5,
	mul6,
	mul7,
	mul8,
	div,
	sh,
	mux,
	sadd,
	mor,
	fadd,
	fmul,
	fdiv,
	fsqrt,
	fint,
	fix,
	flot,
	feps,
	fcmp,
	funeq,
	fsub,
	frem,
	mul,
	mulu,
	divu,
	add,
	addu,
	sub,
	subu,
	set,
	or_,
	orn,
	nor_,
	and_,
	andn,
	nand_,
	xor_,
	nxor,
	shlu,
	shru,
	shl,
	shr,
	cmp,
	cmpu,
	bdif,
	wdif,
	tdif,
	odif,
	zset,
	cset,
	get,
	put,
	ld,
	ldptp,
	ldpte,
	ldunc,
	ldvts,
	preld,
	prest,
	st,
	syncd,
	syncid,
	pst,
	stunc,
	cswap,
	br,
	pbr,
	pushj,
	go,
	prego,
	pushgo,
	pop,
	resume,
	save,
	unsave,
	sync,
	jmp,
	noop,
	trap,
	trip,
	incgamma,
	decgamma,
	incrl,
	sav,
	unsav,
	resum
} internal_opcode;

typedef struct packed {
	logic[63:0]		loc;
	logic[31:0]		inst;
	logic[18:0]		interrupt;
	logic[2:0]		resuming;
} fetch;

typedef struct packed {
	logic[63:0]		o;		// octa value
	logic[1:0]		src;	// 0: octa value, 1: greg, 2: lreg
	logic[7:0]		addr;	// reg address
} spec;

typedef struct packed {
	logic[63:0]		o;
	logic				known;
	logic[1:0]		src;	// 0: memory, 1: greg, 2: lreg
	logic[7:0]		addr;	// reg address
} specnode;

typedef struct packed {
	logic[63:0]		o;
	logic				valid;
} spec_val;

typedef struct packed {
	logic[63:0]		loc;
	mmix_opcode		op;
	logic[7:0]		xx, yy, zz;
	spec				y, z, b, ra;
	specnode			x, a, go; //, rl;
	logic				owner;
	internal_opcode	i;
	
//	logic				need_b;
//	logic				need_ra;
	logic				ren_x;
	logic				ren_a;
	
	logic				mem_x, interim, stack_alert;
	logic	[26:0]	interrupt;
} control;

typedef struct packed {
	spec_val			y, z, b, ra;
} values;

typedef struct packed {
	logic[1:0]	enable;
	logic[7:0]	addr;
	logic[63:0]	data;
} regwrite;