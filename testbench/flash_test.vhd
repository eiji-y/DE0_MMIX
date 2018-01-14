LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

library MMIX_system;
USE MMIX_system.ALL;

entity flash_test is
end flash_test;

architecture sim of flash_test is

COMPONENT Altera_UP_Flash_Memory_IP_Core_Avalon_Interface is
	GENERIC (
		FLASH_MEMORY_ADDRESS_WIDTH : INTEGER := 22;
		FLASH_MEMORY_WAIT_COUNT		: INTEGER := 5;
		FLASH_MEMORY_DATA_WIDTH 	: INTEGER := 8
	);
	PORT 
	(
		-- Signals to/from Avalon Interface 
		i_clock 							: IN 		STD_LOGIC;
		i_reset_n 						: IN 		STD_LOGIC;
		
		-- Note that avalon interconnect is 32-bit word addressable, so it requires 2 fewer bits to represent address location.
		i_avalon_chip_select			: IN 		STD_LOGIC;
		i_avalon_write					: IN 		STD_LOGIC;
		i_avalon_read					: IN 		STD_LOGIC;
		i_avalon_address 				: IN 		STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH-3 DOWNTO 0);
		i_avalon_byteenable			: IN 		STD_LOGIC_VECTOR(3 DOWNTO 0);
		i_avalon_writedata 			: IN 		STD_LOGIC_VECTOR(31 DOWNTO 0);
		o_avalon_readdata 			: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		o_avalon_waitrequest			: OUT 	STD_LOGIC;
		
		i_avalon_erase_chip_select	: IN 		STD_LOGIC;
		i_avalon_erase_write			: IN 		STD_LOGIC;
		i_avalon_erase_read			: IN 		STD_LOGIC;
		i_avalon_erase_byteenable	: IN 		STD_LOGIC_VECTOR(3 DOWNTO 0);
		i_avalon_erase_writedata 	: IN 		STD_LOGIC_VECTOR(31 DOWNTO 0);
		o_avalon_erase_readdata 	: OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		o_avalon_erase_waitrequest	: OUT 	STD_LOGIC;		
		
		-- Signals to be connected to Flash chip via proper I/O ports
		FL_ADDR 							: OUT 	STD_LOGIC_VECTOR(FLASH_MEMORY_ADDRESS_WIDTH - 1 DOWNTO 0);
		FL_DQ 							: INOUT	STD_LOGIC_VECTOR(FLASH_MEMORY_DATA_WIDTH - 1 DOWNTO 0);
		FL_CE_N,
		FL_OE_N,
		FL_WE_N,
		FL_RST_N 						: OUT 	STD_LOGIC
	);
END COMPONENT;

		-- Signals to/from Avalon Interface 
	signal	i_clock 							: STD_LOGIC;
	signal	i_reset_n 						: STD_LOGIC;
		
		-- Note that avalon interconnect is 32-bit word addressable, so it requires 2 fewer bits to represent address location.
	signal	i_avalon_chip_select			: STD_LOGIC;
	signal	i_avalon_write					: STD_LOGIC;
	signal	i_avalon_read					: STD_LOGIC;
	signal	i_avalon_address 				: STD_LOGIC_VECTOR(22-3 DOWNTO 0);
	signal	i_avalon_byteenable			: STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal	i_avalon_writedata 			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal	o_avalon_readdata 			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal	o_avalon_waitrequest			: STD_LOGIC;

	signal	i_avalon_erase_chip_select	: STD_LOGIC;
	signal	i_avalon_erase_write			: STD_LOGIC;
	signal	i_avalon_erase_read			: STD_LOGIC;
	signal	i_avalon_erase_byteenable	: STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal	i_avalon_erase_writedata 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal	o_avalon_erase_readdata 	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal	o_avalon_erase_waitrequest	: STD_LOGIC;		
		
		-- Signals to be connected to Flash chip via proper I/O ports
	signal	FL_ADDR 							: STD_LOGIC_VECTOR(22 - 1 DOWNTO 0);
	signal	FL_DQ 							: STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
	signal	FL_CE_N,
				FL_OE_N,
				FL_WE_N,
				FL_RST_N 						: STD_LOGIC;

begin

	u0 : Altera_UP_Flash_Memory_IP_Core_Avalon_Interface
	port map (
		i_clock 							=> i_clock,
		i_reset_n 						=> i_reset_n,
		
		-- Note that avalon interconnect is 32-bit word addressable, so it requires 2 fewer bits to represent address location.
		i_avalon_chip_select			=> i_avalon_chip_select,
		i_avalon_write					=> i_avalon_write,
		i_avalon_read					=> i_avalon_read,
		i_avalon_address 				=> i_avalon_address,
		i_avalon_byteenable			=> i_avalon_byteenable,
		i_avalon_writedata 			=> i_avalon_writedata,
		o_avalon_readdata 			=> o_avalon_readdata,
		o_avalon_waitrequest			=> o_avalon_waitrequest,
		
		i_avalon_erase_chip_select	=> i_avalon_erase_chip_select,
		i_avalon_erase_write			=> i_avalon_erase_write,
		i_avalon_erase_read			=> i_avalon_erase_read,
		i_avalon_erase_byteenable	=> i_avalon_erase_byteenable,
		i_avalon_erase_writedata 	=> i_avalon_erase_writedata,
		o_avalon_erase_readdata 	=> o_avalon_erase_readdata,
		o_avalon_erase_waitrequest	=> o_avalon_erase_waitrequest,

		-- Signals to be connected to Flash chip via proper I/O ports
		FL_ADDR 							=> FL_ADDR,
		FL_DQ 							=> FL_DQ,
		FL_CE_N							=> FL_CE_N,
		FL_OE_N							=> FL_OE_N,
		FL_WE_N							=> FL_WE_N,
		FL_RST_N							=> FL_RST_N
		);
		
	process begin
		i_clock <= '0';
		wait for 10 ns;
		i_clock <= '1';
		wait for 10 ns;
	end process;

	process begin
		i_reset_n <= '0';
		wait for 10 ns;
		i_reset_n <= '1';
		wait;
	end process;
	
	process begin
		i_avalon_chip_select <= '0';
		i_avalon_write <= '0';
		i_avalon_read <= '0';
		i_avalon_erase_chip_select <= '0';

		wait until FL_RST_N'event and FL_RST_N='1';
		
		i_avalon_chip_select <= '1';
		i_avalon_read <= '1';
		i_avalon_address <= "00000000000000000000";
		i_avalon_byteenable <= "1111";
		
		wait until  o_avalon_waitrequest'event and o_avalon_waitrequest='0';
		wait until  o_avalon_waitrequest'event and o_avalon_waitrequest='0';
		
		i_avalon_chip_select <= '0';
		i_avalon_read <= '0';
		
		wait;
	end process;
	
end sim;
