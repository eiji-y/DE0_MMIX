`uselib lib=MMIX_system

module mm_test();

	logic         clocks_sys_clk_clk;                                                                                  // clocks:sys_clk_clk -> [Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_clock, mm_interconnect_0:clocks_sys_clk_clk, mmix_qsys_0:clk, rst_controller:clk, sdram:clk, video_character_buffer_with_dma_0:clk, video_dual_clock_buffer_0:clk_stream_in, video_pll_0:ref_clk_clk]
	logic         video_character_buffer_with_dma_0_avalon_char_source_endofpacket;                                    // video_character_buffer_with_dma_0:stream_endofpacket -> video_dual_clock_buffer_0:stream_in_endofpacket
	logic         video_character_buffer_with_dma_0_avalon_char_source_valid;                                          // video_character_buffer_with_dma_0:stream_valid -> video_dual_clock_buffer_0:stream_in_valid
	logic         video_character_buffer_with_dma_0_avalon_char_source_startofpacket;                                  // video_character_buffer_with_dma_0:stream_startofpacket -> video_dual_clock_buffer_0:stream_in_startofpacket
	logic  [29:0] video_character_buffer_with_dma_0_avalon_char_source_data;                                           // video_character_buffer_with_dma_0:stream_data -> video_dual_clock_buffer_0:stream_in_data
	logic         video_character_buffer_with_dma_0_avalon_char_source_ready;                                          // video_dual_clock_buffer_0:stream_in_ready -> video_character_buffer_with_dma_0:stream_ready
	logic         video_dual_clock_buffer_0_avalon_dc_buffer_source_endofpacket;                                       // video_dual_clock_buffer_0:stream_out_endofpacket -> video_vga_controller_0:endofpacket
	logic         video_dual_clock_buffer_0_avalon_dc_buffer_source_valid;                                             // video_dual_clock_buffer_0:stream_out_valid -> video_vga_controller_0:valid
	logic         video_dual_clock_buffer_0_avalon_dc_buffer_source_startofpacket;                                     // video_dual_clock_buffer_0:stream_out_startofpacket -> video_vga_controller_0:startofpacket
	logic  [29:0] video_dual_clock_buffer_0_avalon_dc_buffer_source_data;                                              // video_dual_clock_buffer_0:stream_out_data -> video_vga_controller_0:data
	logic         video_dual_clock_buffer_0_avalon_dc_buffer_source_ready;                                             // video_vga_controller_0:ready -> video_dual_clock_buffer_0:stream_out_ready
	logic         video_pll_0_vga_clk_clk;                                                                             // video_pll_0:vga_clk_clk -> [rst_controller_002:clk, video_dual_clock_buffer_0:clk_stream_out, video_vga_controller_0:clk]
	logic         mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_waitrequest;          // Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:o_avalon_waitrequest -> mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_waitrequest
	logic  [31:0] mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_writedata;            // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_writedata -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_writedata
	logic  [19:0] mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_address;              // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_address -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_address
	logic         mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_chipselect;           // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_chipselect -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_chip_select
	logic         mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_write;                // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_write -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_write
	logic         mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_read;                 // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_read -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_read
	logic  [31:0] mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_readdata;             // Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:o_avalon_readdata -> mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_readdata
	logic   [3:0] mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_byteenable;           // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_byteenable -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_byteenable
	logic         mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_waitrequest;            // video_character_buffer_with_dma_0:buf_waitrequest -> mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_buffer_slave_waitrequest
	logic   [7:0] mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_writedata;              // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_buffer_slave_writedata -> video_character_buffer_with_dma_0:buf_writedata
	logic  [12:0] mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_address;                // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_buffer_slave_address -> video_character_buffer_with_dma_0:buf_address
	logic         mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_chipselect;             // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_buffer_slave_chipselect -> video_character_buffer_with_dma_0:buf_chipselect
	logic         mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_write;                  // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_buffer_slave_write -> video_character_buffer_with_dma_0:buf_write
	logic         mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_read;                   // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_buffer_slave_read -> video_character_buffer_with_dma_0:buf_read
	logic   [7:0] mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_readdata;               // video_character_buffer_with_dma_0:buf_readdata -> mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_buffer_slave_readdata
	logic   [0:0] mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_byteenable;             // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_buffer_slave_byteenable -> video_character_buffer_with_dma_0:buf_byteenable
	logic  [31:0] mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_writedata;             // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_control_slave_writedata -> video_character_buffer_with_dma_0:ctrl_writedata
	logic   [0:0] mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_address;               // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_control_slave_address -> video_character_buffer_with_dma_0:ctrl_address
	logic         mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_chipselect;            // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_control_slave_chipselect -> video_character_buffer_with_dma_0:ctrl_chipselect
	logic         mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_write;                 // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_control_slave_write -> video_character_buffer_with_dma_0:ctrl_write
	logic         mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_read;                  // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_control_slave_read -> video_character_buffer_with_dma_0:ctrl_read
	logic  [31:0] mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_readdata;              // video_character_buffer_with_dma_0:ctrl_readdata -> mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_control_slave_readdata
	logic   [3:0] mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_byteenable;            // mm_interconnect_0:video_character_buffer_with_dma_0_avalon_char_control_slave_byteenable -> video_character_buffer_with_dma_0:ctrl_byteenable
	logic         mmix_qsys_0_master_waitrequest;                                                                      // mm_interconnect_0:mmix_qsys_0_master_waitrequest -> mmix_qsys_0:d_waitrequest
	logic  [63:0] mmix_qsys_0_master_writedata;                                                                        // mmix_qsys_0:d_writedata -> mm_interconnect_0:mmix_qsys_0_master_writedata
	logic  [27:0] mmix_qsys_0_master_address;                                                                          // mmix_qsys_0:d_address -> mm_interconnect_0:mmix_qsys_0_master_address
	logic         mmix_qsys_0_master_write;                                                                            // mmix_qsys_0:d_write -> mm_interconnect_0:mmix_qsys_0_master_write
	logic         mmix_qsys_0_master_read;                                                                             // mmix_qsys_0:d_read -> mm_interconnect_0:mmix_qsys_0_master_read
	logic  [63:0] mmix_qsys_0_master_readdata;                                                                         // mm_interconnect_0:mmix_qsys_0_master_readdata -> mmix_qsys_0:d_readdata
	logic         mmix_qsys_0_master_readdatavalid;                                                                    // mm_interconnect_0:mmix_qsys_0_master_readdatavalid -> mmix_qsys_0:d_readdatavalid
	logic   [7:0] mmix_qsys_0_master_byteenable;                                                                       // mmix_qsys_0:d_byteenable -> mm_interconnect_0:mmix_qsys_0_master_byteenable
	logic         mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_waitrequest; // Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:o_avalon_erase_waitrequest -> mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_waitrequest
	logic  [31:0] mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_writedata;   // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_writedata -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_erase_writedata
	logic         mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_chipselect;  // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_chipselect -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_erase_chip_select
	logic         mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_write;       // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_write -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_erase_write
	logic         mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_read;        // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_read -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_erase_read
	logic  [31:0] mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_readdata;    // Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:o_avalon_erase_readdata -> mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_readdata
	logic   [3:0] mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_byteenable;  // mm_interconnect_0:Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_byteenable -> Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_avalon_erase_byteenable
	logic         mm_interconnect_0_sdram_s1_waitrequest;                                                              // sdram:za_waitrequest -> mm_interconnect_0:sdram_s1_waitrequest
	logic  [15:0] mm_interconnect_0_sdram_s1_writedata;                                                                // mm_interconnect_0:sdram_s1_writedata -> sdram:az_data
	logic  [21:0] mm_interconnect_0_sdram_s1_address;                                                                  // mm_interconnect_0:sdram_s1_address -> sdram:az_addr
	logic         mm_interconnect_0_sdram_s1_chipselect;                                                               // mm_interconnect_0:sdram_s1_chipselect -> sdram:az_cs
	logic         mm_interconnect_0_sdram_s1_write;                                                                    // mm_interconnect_0:sdram_s1_write -> sdram:az_wr_n
	logic         mm_interconnect_0_sdram_s1_read;                                                                     // mm_interconnect_0:sdram_s1_read -> sdram:az_rd_n
	logic  [15:0] mm_interconnect_0_sdram_s1_readdata;                                                                 // sdram:za_data -> mm_interconnect_0:sdram_s1_readdata
	logic         mm_interconnect_0_sdram_s1_readdatavalid;                                                            // sdram:za_valid -> mm_interconnect_0:sdram_s1_readdatavalid
	logic   [1:0] mm_interconnect_0_sdram_s1_byteenable;                                                               // mm_interconnect_0:sdram_s1_byteenable -> sdram:az_be_n
	logic  [31:0] mmix_qsys_0_d_irq_irq;                                                                               // irq_mapper:sender_irq -> mmix_qsys_0:d_irq
	logic         rst_controller_reset_out_reset;                                                                      // rst_controller:reset_out -> [Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0:i_reset_n, mm_interconnect_0:mmix_qsys_0_reset_n_reset_bridge_in_reset_reset, mm_interconnect_0:sdram_reset_reset_bridge_in_reset_reset, sdram:reset_n, video_character_buffer_with_dma_0:reset, video_dual_clock_buffer_0:reset_stream_in, video_pll_0:ref_reset_reset]
	logic         rst_controller_001_reset_out_reset;                                                                  // rst_controller_001:reset_out -> clocks:ref_reset_reset
	logic         rst_controller_002_reset_out_reset;                                                                  // rst_controller_002:reset_out -> [video_dual_clock_buffer_0:reset_stream_out, video_vga_controller_0:reset]
	logic         video_pll_0_reset_source_reset;                                                                      // video_pll_0:reset_source_reset -> rst_controller_002:reset_in0

	reg  [15:0] sdram_dq;
	wire  [15:0] sdram_wire_dq;
	assign sdram_wire_dq = sdram_dq;

	MMIX_system_sdram sdram (
		.clk            (clocks_sys_clk_clk),                       //   clk.clk
		.reset_n        (~rst_controller_reset_out_reset),          // reset.reset_n
		.az_addr        (mm_interconnect_0_sdram_s1_address),       //    s1.address
		.az_be_n        (~mm_interconnect_0_sdram_s1_byteenable),   //      .byteenable_n
		.az_cs          (mm_interconnect_0_sdram_s1_chipselect),    //      .chipselect
		.az_data        (mm_interconnect_0_sdram_s1_writedata),     //      .writedata
		.az_rd_n        (~mm_interconnect_0_sdram_s1_read),         //      .read_n
		.az_wr_n        (~mm_interconnect_0_sdram_s1_write),        //      .write_n
		.za_data        (mm_interconnect_0_sdram_s1_readdata),      //      .readdata
		.za_valid       (mm_interconnect_0_sdram_s1_readdatavalid), //      .readdatavalid
		.za_waitrequest (mm_interconnect_0_sdram_s1_waitrequest),   //      .waitrequest
		.zs_addr        (sdram_wire_addr),                          //  wire.export
		.zs_ba          (sdram_wire_ba),                            //      .export
		.zs_cas_n       (sdram_wire_cas_n),                         //      .export
		.zs_cke         (sdram_wire_cke),                           //      .export
		.zs_cs_n        (sdram_wire_cs_n),                          //      .export
		.zs_dq          (sdram_wire_dq),                            //      .export
		.zs_dqm         (sdram_wire_dqm),                           //      .export
		.zs_ras_n       (sdram_wire_ras_n),                         //      .export
		.zs_we_n        (sdram_wire_we_n)                           //      .export
	);

	MMIX_system_mm_interconnect_0 mm_interconnect_0 (
		.clocks_sys_clk_clk                                                                (clocks_sys_clk_clk),                                                                                  //                                                        clocks_sys_clk.clk
		.mmix_qsys_0_reset_n_reset_bridge_in_reset_reset                                   (rst_controller_reset_out_reset),                                                                      //                             mmix_qsys_0_reset_n_reset_bridge_in_reset.reset
		.sdram_reset_reset_bridge_in_reset_reset                                           (rst_controller_reset_out_reset),                                                                      //                                     sdram_reset_reset_bridge_in_reset.reset
		.mmix_qsys_0_master_address                                                        (mmix_qsys_0_master_address),                                                                          //                                                    mmix_qsys_0_master.address
		.mmix_qsys_0_master_waitrequest                                                    (mmix_qsys_0_master_waitrequest),                                                                      //                                                                      .waitrequest
		.mmix_qsys_0_master_byteenable                                                     (mmix_qsys_0_master_byteenable),                                                                       //                                                                      .byteenable
		.mmix_qsys_0_master_read                                                           (mmix_qsys_0_master_read),                                                                             //                                                                      .read
		.mmix_qsys_0_master_readdata                                                       (mmix_qsys_0_master_readdata),                                                                         //                                                                      .readdata
		.mmix_qsys_0_master_readdatavalid                                                  (mmix_qsys_0_master_readdatavalid),                                                                    //                                                                      .readdatavalid
		.mmix_qsys_0_master_write                                                          (mmix_qsys_0_master_write),                                                                            //                                                                      .write
		.mmix_qsys_0_master_writedata                                                      (mmix_qsys_0_master_writedata),                                                                        //                                                                      .writedata
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_address              (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_address),              //          Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data.address
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_write                (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_write),                //                                                                      .write
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_read                 (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_read),                 //                                                                      .read
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_readdata             (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_readdata),             //                                                                      .readdata
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_writedata            (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_writedata),            //                                                                      .writedata
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_byteenable           (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_byteenable),           //                                                                      .byteenable
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_waitrequest          (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_waitrequest),          //                                                                      .waitrequest
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_data_chipselect           (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_data_chipselect),           //                                                                      .chipselect
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_write       (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_write),       // Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control.write
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_read        (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_read),        //                                                                      .read
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_readdata    (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_readdata),    //                                                                      .readdata
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_writedata   (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_writedata),   //                                                                      .writedata
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_byteenable  (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_byteenable),  //                                                                      .byteenable
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_waitrequest (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_waitrequest), //                                                                      .waitrequest
		.Altera_UP_Flash_Memory_IP_Core_Avalon_Interface_0_flash_erase_control_chipselect  (mm_interconnect_0_altera_up_flash_memory_ip_core_avalon_interface_0_flash_erase_control_chipselect),  //                                                                      .chipselect
		.sdram_s1_address                                                                  (mm_interconnect_0_sdram_s1_address),                                                                  //                                                              sdram_s1.address
		.sdram_s1_write                                                                    (mm_interconnect_0_sdram_s1_write),                                                                    //                                                                      .write
		.sdram_s1_read                                                                     (mm_interconnect_0_sdram_s1_read),                                                                     //                                                                      .read
		.sdram_s1_readdata                                                                 (mm_interconnect_0_sdram_s1_readdata),                                                                 //                                                                      .readdata
		.sdram_s1_writedata                                                                (mm_interconnect_0_sdram_s1_writedata),                                                                //                                                                      .writedata
		.sdram_s1_byteenable                                                               (mm_interconnect_0_sdram_s1_byteenable),                                                               //                                                                      .byteenable
		.sdram_s1_readdatavalid                                                            (mm_interconnect_0_sdram_s1_readdatavalid),                                                            //                                                                      .readdatavalid
		.sdram_s1_waitrequest                                                              (mm_interconnect_0_sdram_s1_waitrequest),                                                              //                                                                      .waitrequest
		.sdram_s1_chipselect                                                               (mm_interconnect_0_sdram_s1_chipselect),                                                               //                                                                      .chipselect
		.video_character_buffer_with_dma_0_avalon_char_buffer_slave_address                (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_address),                //            video_character_buffer_with_dma_0_avalon_char_buffer_slave.address
		.video_character_buffer_with_dma_0_avalon_char_buffer_slave_write                  (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_write),                  //                                                                      .write
		.video_character_buffer_with_dma_0_avalon_char_buffer_slave_read                   (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_read),                   //                                                                      .read
		.video_character_buffer_with_dma_0_avalon_char_buffer_slave_readdata               (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_readdata),               //                                                                      .readdata
		.video_character_buffer_with_dma_0_avalon_char_buffer_slave_writedata              (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_writedata),              //                                                                      .writedata
		.video_character_buffer_with_dma_0_avalon_char_buffer_slave_byteenable             (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_byteenable),             //                                                                      .byteenable
		.video_character_buffer_with_dma_0_avalon_char_buffer_slave_waitrequest            (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_waitrequest),            //                                                                      .waitrequest
		.video_character_buffer_with_dma_0_avalon_char_buffer_slave_chipselect             (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_buffer_slave_chipselect),             //                                                                      .chipselect
		.video_character_buffer_with_dma_0_avalon_char_control_slave_address               (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_address),               //           video_character_buffer_with_dma_0_avalon_char_control_slave.address
		.video_character_buffer_with_dma_0_avalon_char_control_slave_write                 (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_write),                 //                                                                      .write
		.video_character_buffer_with_dma_0_avalon_char_control_slave_read                  (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_read),                  //                                                                      .read
		.video_character_buffer_with_dma_0_avalon_char_control_slave_readdata              (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_readdata),              //                                                                      .readdata
		.video_character_buffer_with_dma_0_avalon_char_control_slave_writedata             (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_writedata),             //                                                                      .writedata
		.video_character_buffer_with_dma_0_avalon_char_control_slave_byteenable            (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_byteenable),            //                                                                      .byteenable
		.video_character_buffer_with_dma_0_avalon_char_control_slave_chipselect            (mm_interconnect_0_video_character_buffer_with_dma_0_avalon_char_control_slave_chipselect)             //                                                                      .chipselect
	);
	
	always #20
		clocks_sys_clk_clk <= ~clocks_sys_clk_clk;
	
	initial begin
		clocks_sys_clk_clk <= 0;
		rst_controller_reset_out_reset <= 1;
		mmix_qsys_0_master_address <= 'Z;
		mmix_qsys_0_master_byteenable <= 'Z;
		mmix_qsys_0_master_read <= 0;
		mmix_qsys_0_master_write <= 0;
		mmix_qsys_0_master_writedata <= 'Z;
		#80 rst_controller_reset_out_reset <= 0;
		#200;

		@(posedge clocks_sys_clk_clk);
		
		mmix_qsys_0_master_address <= 'h0000cafe; //'h07c01234;
		mmix_qsys_0_master_byteenable <= 'b11111111;
		mmix_qsys_0_master_read <= 1;
		
		sdram_dq <= 'hbeef;
		
		while (mmix_qsys_0_master_waitrequest)
			@(posedge clocks_sys_clk_clk);
		mmix_qsys_0_master_read <= 0;

		
	end
	
endmodule
