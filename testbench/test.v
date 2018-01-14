`timescale 1 ns / 100 ps

module test();

	reg    clk = 0;
	reg    reset_n = 0;

    MMIX_system u0 (
//		.dbg_led_led		({HEX3_DP, HEX3_D, HEX2_DP, HEX2_D, HEX1_DP, HEX1_D, HEX0_DP, HEX0_D}),
//		.dbg_led_btn		(BUTTON[2]),
        .clk_clk       (clk),       //   clk.clk
        .reset_reset_n (reset_n),  // reset.reset_n
//        .sdram_wire_addr   (DRAM_ADDR),   // sdram_wire.addr
//        .sdram_wire_ba     ({DRAM_BA_1, DRAM_BA_0}),     //           .ba
//        .sdram_wire_cas_n  (DRAM_CAS_N),  //           .cas_n
//        .sdram_wire_cke    (DRAM_CKE),    //           .cke
//        .sdram_wire_cs_n   (DRAM_CS_N),   //           .cs_n
//        .sdram_wire_dq     (DRAM_DQ),     //           .dq
//        .sdram_wire_dqm    ({DRAM_UDQM, DRAM_LDQM}),    //           .dqm
//        .sdram_wire_ras_n  (DRAM_RAS_N),  //           .ras_n
//        .sdram_wire_we_n   (DRAM_WE_N),   //           .we_n
//        .sdram_clk_clk     (DRAM_CLK),      //  sdram_clk.clk
        .flash_wire_ADDR  (),  // flash_wire.ADDR
        .flash_wire_CE_N  (),  //           .CE_N
        .flash_wire_OE_N  (),  //           .OE_N
        .flash_wire_WE_N  (),  //           .WE_N
        .flash_wire_RST_N (), //           .RST_N
        .flash_wire_DQ    ()     //           .DQ
//        .vga_wire_CLK     (),     //   vga_wire.CLK
//        .vga_wire_HS      (VGA_HS),      //           .HS
//        .vga_wire_VS      (VGA_VS),      //           .VS
//        .vga_wire_R       (VGA_R),       //           .R
//        .vga_wire_G       (VGA_G),       //           .G
//        .vga_wire_B       (VGA_B)        //           .B
    );

	always #10 clk <= ~clk;

	initial begin
		reset_n <= 0;
		repeat (2) @(posedge clk);
		reset_n <= 1;
	end

endmodule
