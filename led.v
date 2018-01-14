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

module led(
	input wire	[63:0] data,
	input wire			 btn,
	output wire	[32:0] dbg_led
	);

	reg [1:0] state;

	assign dbg_led[31] = (state == 0)?0:1;
	assign dbg_led[30:24] = LED(sel2(0, sel1(state, data)));
	assign dbg_led[23] = (state == 1)?0:1;
	assign dbg_led[22:16] = LED(sel2(1, sel1(state, data)));
	assign dbg_led[15] = (state == 2)?0:1;
	assign dbg_led[14:8] = LED(sel2(2, sel1(state, data)));
	assign dbg_led[7] = (state == 3)?0:1;
	assign dbg_led[6:0] = LED(sel2(3, sel1(state, data)));
	
	function [6:0] LED(input [3:0] in);
		begin
			case (in)
			4'h0: LED = ~7'b0111111;
			4'h1: LED = ~7'b0000110;
			4'h2: LED = ~7'b1011011;
			4'h3: LED = ~7'b1001111;
			4'h4: LED = ~7'b1100110;
			4'h5: LED = ~7'b1101101;
			4'h6: LED = ~7'b1111101;
			4'h7: LED = ~7'b0000111;
			4'h8: LED = ~7'b1111111;
			4'h9: LED = ~7'b1100111;
			4'ha: LED = ~7'b1110111;
			4'hb: LED = ~7'b1111100;
			4'hc: LED = ~7'b0111001;
			4'hd: LED = ~7'b1011110;
			4'he: LED = ~7'b1111001;
			4'hf: LED = ~7'b1110001;
			endcase
		end
	endfunction
	
	function [15:0] sel1(input [2:0] state, input [63:0] data);
		begin
			case (state)
			0: sel1 = data[63:48];
			1: sel1 = data[47:32];
			2: sel1 = data[31:16];
			3: sel1 = data[15:0];
			endcase
		end
	endfunction
	
	function [7:0] sel2(input [0:2] pos, input [15:0] data);
		case (pos)
		0: sel2 = data[15:12];
		1: sel2 = data[11:8];
		2: sel2 = data[7:4];
		3: sel2 = data[3:0];
		endcase
	endfunction
	
	always @(posedge btn)
		state <= state + 1;
		
endmodule
