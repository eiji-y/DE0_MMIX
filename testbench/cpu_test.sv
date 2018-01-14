module cpu_test(
	);

	logic	[31:0] dbg_led;
	logic			 dbg_btn;

	logic			clk;
	logic			reset_n;

	logic [63:0] mmix_address;
	logic [1:0]  mmix_datasize;	// 0: byte, 1: wyde, 2: tetra, 3: octa
	logic			 mmix_read;
	logic [63:0] mmix_readdata;
	logic			 mmix_write;
	logic [63:0] mmix_writedata;
	logic			 mmix_done;
	
	cpu xxx(
		dbg_led,
		dbg_btn,

		clk,
		reset_n,
	
		mmix_address,
		mmix_datasize,	// 0: byte, 1: wyde, 2: tetra, 3: octa
		mmix_read,
		mmix_readdata,
		mmix_write,
		mmix_writedata,
		mmix_done
		);
		
	always #20
		clk <= ~clk;
	
	initial begin
		clk <= 0;
		reset_n <= 0;
		mmix_done <= 0;
		#80 reset_n <= 1;

		////////////////		
		wait_mem_read(64'h0000fffffffffffc, 64'h00000000f1f00001);

		wait_mem_read(64'h0000ffffffc00000, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc00004, 64'h00000000e3ff8000);
		wait_mem_read(64'h0000ffffffc00008, 64'h00000000e6ff007f);
		wait_mem_read(64'h0000ffffffc0000c, 64'h00000000e5ff0000);
		wait_mem_read(64'h0000ffffffc00010, 64'h00000000e4ff8000);
		wait_mem_read(64'h0000ffffffc00014, 64'h00000000ad00ff00);
		wait_mem_write(64'h80000000007f8000, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc00018, 64'h00000000e000ff00);
		wait_mem_read(64'h0000ffffffc0001c, 64'h0000000021ffff70);
		wait_mem_read(64'h0000ffffffc00020, 64'h00000000ad00ff00);
		wait_mem_write(64'h80000000007f8070, 64'hff00000000000000);

		// UNSAVE: memory read rG|rA
		wait_mem_read(64'h0000ffffffc00024, 64'h00000000fb0000ff);
		wait_mem_read(64'h80000000007f8070, 64'hff00000000000000);
		wait_mem_read(64'h80000000007f8068, 64'h0000000000008068);
		wait_mem_read(64'h80000000007f8060, 64'h0000000000008060);
		wait_mem_read(64'h80000000007f8058, 64'h0000000000008058);
		wait_mem_read(64'h80000000007f8050, 64'h0000000000008050);
		wait_mem_read(64'h80000000007f8048, 64'h0000000000008048);
		wait_mem_read(64'h80000000007f8040, 64'h0000000000008040);
		wait_mem_read(64'h80000000007f8038, 64'h0000000000008038);
		wait_mem_read(64'h80000000007f8030, 64'h0000000000008030);
		wait_mem_read(64'h80000000007f8028, 64'h0000000000008028);
		wait_mem_read(64'h80000000007f8020, 64'h0000000000008020);
		wait_mem_read(64'h80000000007f8018, 64'h0000000000008018);
		wait_mem_read(64'h80000000007f8010, 64'h0000000000008010);
		wait_mem_read(64'h80000000007f8008, 64'h0000000000008008);
		wait_mem_read(64'h80000000007f8000, 64'h0000000000000000);

		wait_mem_read(64'h0000ffffffc00028, 64'h00000000f7130020);
		wait_mem_read(64'h0000ffffffc0002c, 64'h00000000e3fe0000);
		wait_mem_read(64'h0000ffffffc00030, 64'h00000000e6fe0080);
		wait_mem_read(64'h0000ffffffc00034, 64'h00000000e5fe0000);
		wait_mem_read(64'h0000ffffffc00038, 64'h00000000e4fe8000);
		wait_mem_read(64'h0000ffffffc0003c, 64'h00000000f2000146);

		wait_mem_read(64'h0000ffffffc00554, 64'h0000000027fefe08);
		wait_mem_read(64'h0000ffffffc00558, 64'h00000000affdfe00);
		wait_mem_write(64'h80000000007ffff8, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc0055c, 64'h0000000023fdfe08);
		wait_mem_read(64'h0000ffffffc00560, 64'h00000000fe010004);
		wait_mem_read(64'h0000ffffffc00564, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc00568, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc0056c, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc00570, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc00574, 64'h00000000e3020000);
		wait_mem_read(64'h0000ffffffc00578, 64'h00000000ab020000);
		wait_mem_write(64'h80000000007f0000, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc0057c, 64'h00000000e3000004);
		wait_mem_read(64'h0000ffffffc00580, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc00584, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc00588, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc0058c, 64'h00000000e3020000);
		wait_mem_read(64'h0000ffffffc00590, 64'h00000000ab020000);
		wait_mem_write(64'h80000000007f0004, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc00594, 64'h00000000e3000008);
		wait_mem_read(64'h0000ffffffc00598, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc0059c, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc005a0, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc005a4, 64'h00000000e2020200);
		wait_mem_read(64'h0000ffffffc005a8, 64'h00000000e4028001);
		wait_mem_read(64'h0000ffffffc005ac, 64'h00000000af020000);
		wait_mem_write(64'h80000000007f0008, 64'h8001000002000000);
		wait_mem_read(64'h0000ffffffc005b0, 64'h00000000e30405d8);
		wait_mem_read(64'h0000ffffffc005b4, 64'h00000000e604ffc0);
		wait_mem_read(64'h0000ffffffc005b8, 64'h00000000e504ffff);
		wait_mem_read(64'h0000ffffffc005bc, 64'h00000000e4048000);
		wait_mem_read(64'h0000ffffffc005c0, 64'h00000000f303ffa8);
		wait_mem_read(64'h0000ffffffc00460, 64'h0000000027fefe28);
		wait_mem_read(64'h0000ffffffc00464, 64'h00000000affdfe20);
		wait_mem_write(64'h80000000007ffff0, 64'h8000000000800000);
		wait_mem_read(64'h0000ffffffc00468, 64'h0000000023fdfe28);
		wait_mem_read(64'h0000ffffffc0046c, 64'h00000000fe020004);
		wait_mem_read(64'h0000ffffffc00470, 64'h000000002701fd20);
		wait_mem_read(64'h0000ffffffc00474, 64'h00000000af020100);
		wait_mem_write(64'h80000000007fffd8, 64'h8000ffffffc005c4);
		wait_mem_read(64'h0000ffffffc00478, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc0047c, 64'h00000000af000100);
		wait_mem_write(64'h80000000007fffe0, 64'h8000ffffffc005d8);
		wait_mem_read(64'h0000ffffffc00480, 64'h00000000f0000015);
		wait_mem_read(64'h0000ffffffc004d4, 64'h000000002701fd0c);
		wait_mem_read(64'h0000ffffffc004d8, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc004dc, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffe0, 64'h8000ffffffc005d8);
		wait_mem_read(64'h0000ffffffc004e0, 64'h0000000081020000);
		wait_mem_read(64'h8000ffffffc005d8,	64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc004e4, 64'h00000000a3020100);
		wait_mem_write(64'h80000000007fffec, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc004e8, 64'h000000002700fd0c);
		wait_mem_read(64'h0000ffffffc004ec, 64'h0000000081020000);
		wait_mem_read(64'h80000000007fffec, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc004f0, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc004f4, 64'h00000000a3020100);
		wait_mem_write(64'h80000000007fffd7, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc004f8, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc004fc, 64'h0000000081010100);
		wait_mem_read(64'h80000000007fffd7, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc00500, 64'h000000003b000138);
		wait_mem_read(64'h0000ffffffc00504, 64'h000000003f000038);
		wait_mem_read(64'h0000ffffffc00508, 64'h0000000031000000);
		wait_mem_read(64'h0000ffffffc0050c, 64'h0000000042000004);
		wait_mem_read(64'h0000ffffffc00510, 64'h00000000e3000001);
		wait_mem_read(64'h0000ffffffc00514, 64'h000000002702fd21);
		wait_mem_read(64'h0000ffffffc00518, 64'h00000000a3000200);
		wait_mem_write(64'h80000000007fffd7, 64'h0000000000000001);
		wait_mem_read(64'h0000ffffffc0051c, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc00520, 64'h0000000081020100);
		wait_mem_read(64'h80000000007fffd7, 64'h0000000000000001);
		wait_mem_read(64'h0000ffffffc00524, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc00528, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc0052c, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffe0, 64'h8000ffffffc005d8);
		wait_mem_read(64'h0000ffffffc00530, 64'h0000000023000001);
		wait_mem_read(64'h0000ffffffc00534, 64'h00000000af000100);
		wait_mem_write(64'h80000000007fffe0, 64'h8000ffffffc005d9);
		wait_mem_read(64'h0000ffffffc00538, 64'h000000003b000238);
		wait_mem_read(64'h0000ffffffc0053c, 64'h000000003f000038);
		wait_mem_read(64'h0000ffffffc00540, 64'h0000000031000000);
		wait_mem_read(64'h0000ffffffc00544, 64'h000000004b00ffd0);

		wait_mem_read(64'h0000ffffffc00484, 64'h000000002700fd0c);
		wait_mem_read(64'h0000ffffffc00488, 64'h0000000081000000);
		wait_mem_read(64'h80000000007fffec, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc0048c, 64'h000000003b000038);
		wait_mem_read(64'h0000ffffffc00490, 64'h000000003d000038);
		wait_mem_read(64'h0000ffffffc00494, 64'h000000003100000a);
		wait_mem_read(64'h0000ffffffc00498, 64'h000000004a000006);
		wait_mem_read(64'h0000ffffffc004b0, 64'h000000002700fd0c);
		wait_mem_read(64'h0000ffffffc004b4, 64'h0000000081000000);
		wait_mem_read(64'h80000000007fffec, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc004b8, 64'h000000003b000038);
		wait_mem_read(64'h0000ffffffc004bc, 64'h000000003d000038);
		wait_mem_read(64'h0000ffffffc004c0, 64'h00000000c1040000);
		wait_mem_read(64'h0000ffffffc004c4, 64'h00000000f303ff0f);

		// putc()
		wait_mem_read(64'h0000ffffffc00100, 64'h0000000027fefe20);
		wait_mem_read(64'h0000ffffffc00104, 64'h00000000affdfe18);
		wait_mem_write(64'h80000000007fffc8, 64'h80000000007ffff8);
		wait_mem_read(64'h0000ffffffc00108, 64'h0000000023fdfe20);
		wait_mem_read(64'h0000ffffffc0010c, 64'h00000000fe020004);
		wait_mem_read(64'h0000ffffffc00110, 64'h000000002701fd20);
		wait_mem_read(64'h0000ffffffc00114, 64'h00000000af020100);
		wait_mem_write(64'h80000000007fffb0, 64'h8000ffffffc004c8);
		wait_mem_read(64'h0000ffffffc00118, 64'h00000000c1010000);
		wait_mem_read(64'h0000ffffffc0011c, 64'h000000002700fd09);
		wait_mem_read(64'h0000ffffffc00120, 64'h00000000a3010000);
		wait_mem_write(64'h80000000007fffc7, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc00124, 64'h000000002700fd09);
		wait_mem_read(64'h0000ffffffc00128, 64'h0000000081000000);
		wait_mem_read(64'h80000000007fffc7, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc0012c, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00130, 64'h000000003b000018);
		wait_mem_read(64'h0000ffffffc00134, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00138, 64'h000000003b000020);
		wait_mem_read(64'h0000ffffffc0013c, 64'h000000003d000020);
		wait_mem_read(64'h0000ffffffc00140, 64'h000000003d000018);
		wait_mem_read(64'h0000ffffffc00144, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00148, 64'h000000003b020020);
		wait_mem_read(64'h0000ffffffc0014c, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc00150, 64'h00000000af020100);
		wait_mem_write(64'h80000000007fffb8, 64'h0000004d00000000);
		wait_mem_read(64'h0000ffffffc00154, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc00158, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffb8, 64'h0000004d00000000);
		wait_mem_read(64'h0000ffffffc0015c, 64'h000000003d010020);
		wait_mem_read(64'h0000ffffffc00160, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc00164, 64'h00000000af010000);
		wait_mem_write(64'h80000000007fffb8, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc00168, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc0016c, 64'h000000008d010100);
		wait_mem_read(64'h80000000007fffb8, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc00170, 64'h000000003100010a);
		wait_mem_read(64'h0000ffffffc00174, 64'h0000000042000072);
		wait_mem_read(64'h0000ffffffc00178, 64'h000000002702fd18);
		wait_mem_read(64'h0000ffffffc0017c, 64'h000000008d020200);
		wait_mem_read(64'h80000000007fffb8, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc00180, 64'h000000003100020d);
		wait_mem_read(64'h0000ffffffc00184, 64'h0000000042000054);
		wait_mem_read(64'h0000ffffffc00188, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc0018c, 64'h000000008d010100);
		wait_mem_read(64'h80000000007fffb8, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc00190, 64'h0000000031000108);
		wait_mem_read(64'h0000ffffffc00194, 64'h0000000042000090);
		wait_mem_read(64'h0000ffffffc00198, 64'h00000000e3000008);
		wait_mem_read(64'h0000ffffffc0019c, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc001a0, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc001a4, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc001a8, 64'h000000008d010000);
		wait_mem_read(64'h80000000007f0008, 64'h8001000002000000);
		wait_mem_read(64'h0000ffffffc001ac, 64'h000000002700fd09);
		wait_mem_read(64'h0000ffffffc001b0, 64'h0000000081020000);
		wait_mem_read(64'h80000000007fffc7, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc001b4, 64'h00000000a3020100);
		wait_mem_write(64'h8001000002000000, 64'h000000000000004d);
		wait_mem_read(64'h0000ffffffc001b8, 64'h0000000023010101);
		wait_mem_read(64'h0000ffffffc001bc, 64'h00000000e3000008);
		wait_mem_read(64'h0000ffffffc001c0, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc001c4, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc001c8, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc001cc, 64'h00000000af010000);
		wait_mem_write(64'h80000000007f0008, 64'h8001000002000001);
		wait_mem_read(64'h0000ffffffc001d0, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc001d4, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc001d8, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc001dc, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc001e0, 64'h0000000089000000);
		wait_mem_read(64'h80000000007f0000, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc001e4, 64'h0000000023000001);
		wait_mem_read(64'h0000ffffffc001e8, 64'h00000000c1010000);
		wait_mem_read(64'h0000ffffffc001ec, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc001f0, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc001f4, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc001f8, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc001fc, 64'h00000000ab010000);
		wait_mem_write(64'h80000000007f0000, 64'h0000000000000001);
		wait_mem_read(64'h0000ffffffc00200, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc00204, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc00208, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc0020c, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc00210, 64'h0000000089000000);
		wait_mem_read(64'h80000000007f0000, 64'h0000000000000001);
		wait_mem_read(64'h0000ffffffc00214, 64'h000000003b000020);
		wait_mem_read(64'h0000ffffffc00218, 64'h000000003d000020);
		wait_mem_read(64'h0000ffffffc0021c, 64'h0000000031000050);
		wait_mem_read(64'h0000ffffffc00220, 64'h000000004a00008d);
		wait_mem_read(64'h0000ffffffc00454, 64'h000000008dfdfe18);
		wait_mem_read(64'h80000000007fffc8, 64'h80000000007ffff8);
		wait_mem_read(64'h0000ffffffc00458, 64'h0000000023fefe20);
		wait_mem_read(64'h0000ffffffc0045c, 64'h00000000f8000000);

		// puts()
		wait_mem_read(64'h0000ffffffc004c8, 64'h000000002701fd20);
		wait_mem_read(64'h0000ffffffc004cc, 64'h000000008d010100);
		wait_mem_read(64'h80000000007fffd8, 64'h8000ffffffc005c4);
		wait_mem_read(64'h0000ffffffc004d0, 64'h00000000f6040001);
		wait_mem_read(64'h0000ffffffc004d4, 64'h000000002701fd0c);
		wait_mem_read(64'h0000ffffffc004d8, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc004dc, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffe0, 64'h8000ffffffc005d9);
		wait_mem_read(64'h0000ffffffc004e0, 64'h0000000081020000);
		wait_mem_read(64'h8000ffffffc005d9, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc004e4, 64'h00000000a3020100);
		wait_mem_write(64'h80000000007fffec, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc004e8, 64'h000000002700fd0c);
		wait_mem_read(64'h0000ffffffc004ec, 64'h0000000081020000);
		wait_mem_read(64'h80000000007fffec, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc004f0, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc004f4, 64'h00000000a3020100);
		wait_mem_write(64'h80000000007fffd7, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc004f8, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc004fc, 64'h0000000081010100);
		wait_mem_read(64'h80000000007fffd7, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc00500, 64'h000000003b000138);
		wait_mem_read(64'h0000ffffffc00504, 64'h000000003f000038);
		wait_mem_read(64'h0000ffffffc00508, 64'h0000000031000000);
		wait_mem_read(64'h0000ffffffc0050c, 64'h0000000042000004);
		wait_mem_read(64'h0000ffffffc00510, 64'h00000000e3000001);
		wait_mem_read(64'h0000ffffffc00514, 64'h000000002702fd21);
		wait_mem_read(64'h0000ffffffc00518, 64'h00000000a3000200);
		wait_mem_write(64'h80000000007fffd7, 64'h0000000000000001);
		wait_mem_read(64'h0000ffffffc0051c, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc00520, 64'h0000000081020100);
		wait_mem_read(64'h80000000007fffd7, 64'h0000000000000001);
		wait_mem_read(64'h0000ffffffc00524, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc00528, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc0052c, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffe0, 64'h8000ffffffc005d9);
		wait_mem_read(64'h0000ffffffc00530, 64'h0000000023000001);
		wait_mem_read(64'h0000ffffffc00534, 64'h00000000af000100);
		wait_mem_write(64'h80000000007fffe0, 64'h8000ffffffc005da);
		wait_mem_read(64'h0000ffffffc00538, 64'h000000003b000238);
		wait_mem_read(64'h0000ffffffc0053c, 64'h000000003f000038);
		wait_mem_read(64'h0000ffffffc00540, 64'h0000000031000000);
		wait_mem_read(64'h0000ffffffc00544, 64'h000000004b00ffd0);
		
		wait_mem_read(64'h0000ffffffc00484, 64'h000000002700fd0c);
		wait_mem_read(64'h0000ffffffc00488, 64'h0000000081000000);
		wait_mem_read(64'h80000000007fffec, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc0048c, 64'h000000003b000038);
		wait_mem_read(64'h0000ffffffc00490, 64'h000000003d000038);
		wait_mem_read(64'h0000ffffffc00494, 64'h000000003100000a);
		wait_mem_read(64'h0000ffffffc00498, 64'h000000004a000006);
		wait_mem_read(64'h0000ffffffc0049c, 64'h00000000e304000d);
		wait_mem_read(64'h0000ffffffc004a0, 64'h00000000f303ff18);
		
		// putc('\r')
		wait_mem_read(64'h0000ffffffc00100, 64'h0000000027fefe20);
		wait_mem_read(64'h0000ffffffc00104, 64'h00000000affdfe18);
		wait_mem_write(64'h80000000007fffc8, 64'h80000000007ffff8);
		wait_mem_read(64'h0000ffffffc00108, 64'h0000000023fdfe20);
		wait_mem_read(64'h0000ffffffc0010c, 64'h00000000fe020004);
		wait_mem_read(64'h0000ffffffc00110, 64'h000000002701fd20);
		wait_mem_read(64'h0000ffffffc00114, 64'h00000000af020100);
		wait_mem_write(64'h80000000007fffb0, 64'h8000ffffffc004a4);
		wait_mem_read(64'h0000ffffffc00118, 64'h00000000c1010000);
		wait_mem_read(64'h0000ffffffc0011c, 64'h000000002700fd09);
		wait_mem_read(64'h0000ffffffc00120, 64'h00000000a3010000);
		wait_mem_write(64'h80000000007fffc7, 64'h000000000000000d);
		wait_mem_read(64'h0000ffffffc00124, 64'h000000002700fd09);
		wait_mem_read(64'h0000ffffffc00128, 64'h0000000081000000);
		wait_mem_read(64'h80000000007fffc7, 64'h000000000000000d);
		wait_mem_read(64'h0000ffffffc0012c, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00130, 64'h000000003b000018);
		wait_mem_read(64'h0000ffffffc00134, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00138, 64'h000000003b000020);
		wait_mem_read(64'h0000ffffffc0013c, 64'h000000003d000020);
		wait_mem_read(64'h0000ffffffc00140, 64'h000000003d000018);
		wait_mem_read(64'h0000ffffffc00144, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00148, 64'h000000003b020020);
		wait_mem_read(64'h0000ffffffc0014c, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc00150, 64'h00000000af020100);
		wait_mem_write(64'h80000000007fffb8, 64'h0000000d00000000);
		wait_mem_read(64'h0000ffffffc00154, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc00158, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffb8, 64'h0000000d00000000);
		wait_mem_read(64'h0000ffffffc0015c, 64'h000000003d010020);
		wait_mem_read(64'h0000ffffffc00160, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc00164, 64'h00000000af010000);
		wait_mem_write(64'h80000000007fffb8, 64'h000000000000000d);
		wait_mem_read(64'h0000ffffffc00168, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc0016c, 64'h000000008d010100);
		wait_mem_read(64'h80000000007fffb8, 64'h000000000000000d);
		wait_mem_read(64'h0000ffffffc00170, 64'h000000003100010a);
		wait_mem_read(64'h0000ffffffc00174, 64'h0000000042000072);
		wait_mem_read(64'h0000ffffffc00178, 64'h000000002702fd18);
		wait_mem_read(64'h0000ffffffc0017c, 64'h000000008d020200);
		wait_mem_read(64'h80000000007fffb8, 64'h000000000000000d);
		wait_mem_read(64'h0000ffffffc00180, 64'h000000003100020d);
		wait_mem_read(64'h0000ffffffc00184, 64'h0000000042000054);
		
		wait_mem_read(64'h0000ffffffc002d4, 64'h00000000e3000008);
		wait_mem_read(64'h0000ffffffc002d8, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc002dc, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc002e0, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc002e4, 64'h000000008d010000);
		wait_mem_read(64'h80000000007f0008, 64'h8001000002000001);
		wait_mem_read(64'h0000ffffffc002e8, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc002ec, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc002f0, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc002f4, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc002f8, 64'h0000000089000000);
		wait_mem_read(64'h80000000007f0000, 64'h0000000000000001);
		wait_mem_read(64'h0000ffffffc002fc, 64'h000000003b000020);
		wait_mem_read(64'h0000ffffffc00300, 64'h000000003d000020);
		wait_mem_read(64'h0000ffffffc00304, 64'h0000000036000000);
		wait_mem_read(64'h0000ffffffc00308, 64'h0000000022010100);
		wait_mem_read(64'h0000ffffffc0030c, 64'h00000000e3000008);
		wait_mem_read(64'h0000ffffffc00310, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc00314, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc00318, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc0031c, 64'h00000000af010000);
		wait_mem_write(64'h80000000007f0008, 64'h8001000002000000);
		wait_mem_read(64'h0000ffffffc00320, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc00324, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc00328, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc0032c, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc00330, 64'h00000000e3010000);
		wait_mem_read(64'h0000ffffffc00334, 64'h00000000ab010000);
		wait_mem_write(64'h80000000007f0000, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc00338, 64'h00000000f0000047);
		wait_mem_read(64'h0000ffffffc00454, 64'h000000008dfdfe18);
		wait_mem_read(64'h80000000007fffc8, 64'h80000000007ffff8);
		wait_mem_read(64'h0000ffffffc00458, 64'h0000000023fefe20);
		wait_mem_read(64'h0000ffffffc0045c, 64'h00000000f8000000);
	
		// puts()
		wait_mem_read(64'h0000ffffffc004a4, 64'h000000002700fd20);
		wait_mem_read(64'h0000ffffffc004a8, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffd8, 64'h8000ffffffc005c4);
		wait_mem_read(64'h0000ffffffc004ac, 64'h00000000f6040000);
		wait_mem_read(64'h0000ffffffc004b0, 64'h000000002700fd0c);
		wait_mem_read(64'h0000ffffffc004b4, 64'h0000000081000000);
		wait_mem_read(64'h80000000007fffec, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc004b8, 64'h000000003b000038);
		wait_mem_read(64'h0000ffffffc004bc, 64'h000000003d000038);
		wait_mem_read(64'h0000ffffffc004c0, 64'h00000000c1040000);
		wait_mem_read(64'h0000ffffffc004c4, 64'h00000000f303ff0f);
		
		// putc('\n');
		wait_mem_read(64'h0000ffffffc00100, 64'h0000000027fefe20);
		wait_mem_read(64'h0000ffffffc00104, 64'h00000000affdfe18);
		wait_mem_write(64'h80000000007fffc8, 64'h80000000007ffff8);
		wait_mem_read(64'h0000ffffffc00108, 64'h0000000023fdfe20);
		wait_mem_read(64'h0000ffffffc0010c, 64'h00000000fe020004);
		wait_mem_read(64'h0000ffffffc00110, 64'h000000002701fd20);
		wait_mem_read(64'h0000ffffffc00114, 64'h00000000af020100);
		wait_mem_write(64'h80000000007fffb0, 64'h8000ffffffc004c8);
		wait_mem_read(64'h0000ffffffc00118, 64'h00000000c1010000);
		wait_mem_read(64'h0000ffffffc0011c, 64'h000000002700fd09);
		wait_mem_read(64'h0000ffffffc00120, 64'h00000000a3010000);
		wait_mem_write(64'h80000000007fffc7, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc00124, 64'h000000002700fd09);
		wait_mem_read(64'h0000ffffffc00128, 64'h0000000081000000);
		wait_mem_read(64'h80000000007fffc7, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc0012c, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00130, 64'h000000003b000018);
		wait_mem_read(64'h0000ffffffc00134, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00138, 64'h000000003b000020);
		wait_mem_read(64'h0000ffffffc0013c, 64'h000000003d000020);
		wait_mem_read(64'h0000ffffffc00140, 64'h000000003d000018);
		wait_mem_read(64'h0000ffffffc00144, 64'h00000000c1000000);
		wait_mem_read(64'h0000ffffffc00148, 64'h000000003b020020);
		wait_mem_read(64'h0000ffffffc0014c, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc00150, 64'h00000000af020100);
		wait_mem_write(64'h80000000007fffb8, 64'h0000000a00000000);
		wait_mem_read(64'h0000ffffffc00154, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc00158, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffb8, 64'h0000000a00000000);
		wait_mem_read(64'h0000ffffffc0015c, 64'h000000003d010020);
		wait_mem_read(64'h0000ffffffc00160, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc00164, 64'h00000000af010000);
		wait_mem_write(64'h80000000007fffb8, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc00168, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc0016c, 64'h000000008d010100);
		wait_mem_read(64'h80000000007fffb8, 64'h000000000000000a);
		wait_mem_read(64'h0000ffffffc00170, 64'h000000003100010a);
		wait_mem_read(64'h0000ffffffc00174, 64'h0000000042000072);
	
		wait_mem_read(64'h0000ffffffc0033c, 64'h00000000e3000004);
		wait_mem_read(64'h0000ffffffc00340, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc00344, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc00348, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc0034c, 64'h0000000089000000);
		wait_mem_read(64'h80000000007f0004, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc00350, 64'h000000003b000020);
		wait_mem_read(64'h0000ffffffc00354, 64'h000000003d000020);
		wait_mem_read(64'h0000ffffffc00358, 64'h0000000031000027);
		wait_mem_read(64'h0000ffffffc0035c, 64'h000000004a000006);

		wait_mem_read(64'h0000ffffffc00374, 64'h00000000e3000004);
		wait_mem_read(64'h0000ffffffc00378, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc0037c, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc00380, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc00384, 64'h0000000089000000);
		wait_mem_read(64'h80000000007f0004, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc00388, 64'h0000000023000001);
		wait_mem_read(64'h0000ffffffc0038c, 64'h00000000c1010000);
		wait_mem_read(64'h0000ffffffc00390, 64'h00000000e3000004);
		wait_mem_read(64'h0000ffffffc00394, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc00398, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc0039c, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc003a0, 64'h00000000ab010000);
		wait_mem_write(64'h80000000007f0004, 64'h0000000000000001);
		wait_mem_read(64'h0000ffffffc003a4, 64'h00000000e3000008);
		wait_mem_read(64'h0000ffffffc003a8, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc003ac, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc003b0, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc003b4, 64'h000000008d000000);
		wait_mem_read(64'h80000000007f0008, 64'h8001000002000000);
		wait_mem_read(64'h0000ffffffc003b8, 64'h0000000023010050);
		wait_mem_read(64'h0000ffffffc003bc, 64'h00000000e3000008);
		wait_mem_read(64'h0000ffffffc003c0, 64'h00000000e600007f);
		wait_mem_read(64'h0000ffffffc003c4, 64'h00000000e5000000);
		wait_mem_read(64'h0000ffffffc003c8, 64'h00000000e4008000);
		wait_mem_read(64'h0000ffffffc003cc, 64'h00000000af010000);
		wait_mem_write(64'h80000000007f0008, 64'h8001000002000050);
		wait_mem_read(64'h0000ffffffc003d0, 64'h00000000f0000021);
		
		wait_mem_read(64'h0000ffffffc00454, 64'h000000008dfdfe18);
		wait_mem_read(64'h80000000007fffc8, 64'h80000000007ffff8);
		wait_mem_read(64'h0000ffffffc00458, 64'h0000000023fefe20);
		wait_mem_read(64'h0000ffffffc0045c, 64'h00000000f8000000);
		
		// puts()
		wait_mem_read(64'h0000ffffffc004c8, 64'h000000002701fd20);
		wait_mem_read(64'h0000ffffffc004cc, 64'h000000008d010100);
		wait_mem_read(64'h80000000007fffd8, 64'h8000ffffffc005c4);
		wait_mem_read(64'h0000ffffffc004d0, 64'h00000000f6040001);
		wait_mem_read(64'h0000ffffffc004d4, 64'h000000002701fd0c);
		wait_mem_read(64'h0000ffffffc004d8, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc004dc, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffe0, 64'h8000ffffffc005da);
		wait_mem_read(64'h0000ffffffc004e0, 64'h0000000081020000);
		wait_mem_read(64'h8000ffffffc005da, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc004e4, 64'h00000000a3020100);
		wait_mem_write(64'h80000000007fffec, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc004e8, 64'h000000002700fd0c);
		wait_mem_read(64'h0000ffffffc004ec, 64'h0000000081020000);
		wait_mem_read(64'h80000000007fffec, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc004f0, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc004f4, 64'h00000000a3020100);
		wait_mem_write(64'h80000000007fffd7, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc004f8, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc004fc, 64'h0000000081010100);
		wait_mem_read(64'h80000000007fffd7, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc00500, 64'h000000003b000138);
		wait_mem_read(64'h0000ffffffc00504, 64'h000000003f000038);
		wait_mem_read(64'h0000ffffffc00508, 64'h0000000031000000);
		wait_mem_read(64'h0000ffffffc0050c, 64'h0000000042000004);

		wait_mem_read(64'h0000ffffffc0051c, 64'h000000002701fd21);
		wait_mem_read(64'h0000ffffffc00520, 64'h0000000081020100);
		wait_mem_read(64'h80000000007fffd7, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc00524, 64'h000000002701fd18);
		wait_mem_read(64'h0000ffffffc00528, 64'h000000002700fd18);
		wait_mem_read(64'h0000ffffffc0052c, 64'h000000008d000000);
		wait_mem_read(64'h80000000007fffe0, 64'h8000ffffffc005da);
		wait_mem_read(64'h0000ffffffc00530, 64'h0000000023000001);
		wait_mem_read(64'h0000ffffffc00534, 64'h00000000af000100);
		wait_mem_write(64'h80000000007fffe0, 64'h8000ffffffc005db);
		wait_mem_read(64'h0000ffffffc00538, 64'h000000003b000238);
		wait_mem_read(64'h0000ffffffc0053c, 64'h000000003f000038);
		wait_mem_read(64'h0000ffffffc00540, 64'h0000000031000000);
		wait_mem_read(64'h0000ffffffc00544, 64'h000000004b00ffd0);
		wait_mem_read(64'h0000ffffffc00548, 64'h000000008dfdfe20);
		wait_mem_read(64'h80000000007ffff0, 64'h8000000000800000);
		wait_mem_read(64'h0000ffffffc0054c, 64'h0000000023fefe28);
		wait_mem_read(64'h0000ffffffc00550, 64'h00000000f8000000);

		// main()
		wait_mem_read(64'h0000ffffffc005c4, 64'h00000000f6040001);
		wait_mem_read(64'h0000ffffffc005c8, 64'h00000000e3000000);
		wait_mem_read(64'h0000ffffffc005cc, 64'h000000008dfdfe00);
		wait_mem_read(64'h80000000007ffff8, 64'h0000000000000000);
		wait_mem_read(64'h0000ffffffc005d0, 64'h0000000023fefe08);
		wait_mem_read(64'h0000ffffffc005d4, 64'h00000000f8010000);

		// start.S
		wait_mem_read(64'h0000ffffffc00040, 64'h00000000f0000000);
		/////

	end
	
	task wait_mem_read(logic[63:0] addr, logic[63:0] data);
		while (1) begin
			@(posedge clk);
			if (mmix_read == 1)
				break;
		end
				
		if (mmix_address != addr)
			$stop;
		mmix_readdata <= data;
		mmix_done <= 1;

		@(posedge clk);
		mmix_done <= 0;
	endtask
	
	task wait_mem_write(logic[63:0] addr, logic[63:0] data);
		while (1) begin
			@(posedge clk);
			if (mmix_write == 1)
				break;
		end
				
		if (mmix_address != addr)
			$stop;
		if (mmix_writedata != data)
			$stop;
		mmix_done <= 1;

		@(posedge clk);
		mmix_done <= 0;
	endtask
	
endmodule
