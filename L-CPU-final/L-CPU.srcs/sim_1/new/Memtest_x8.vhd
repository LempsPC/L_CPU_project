----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2018 03:40:47 PM
-- Design Name: 
-- Module Name: Memtest_x8 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memtest_x8 is
--  Port ( );
end Memtest_x8;

architecture Behavioral of Memtest_x8 is

component Mem is 
  generic (BitWidth: integer := 8);
  port ( RdAddress: in std_logic_vector (7 downto 0);
         Data_in: in std_logic_vector (7 downto 0);
	     WrtAddress: in std_logic_vector (7 downto 0);
         clk: in std_logic;
         RW: in std_logic;
         rst: in std_logic;
         Data_Out: out std_logic_vector (7 downto 0) 
    );
end component Mem;

signal clk, RW, rst : std_logic := '0';
signal Data_in, RdAddress, WrtAddress, Data_out : std_logic_vector (7 downto 0) := "00000000";

begin

UUT: Mem
Port map(clk => clk,
         RW => RW,
         RdAddress => RdAddress,
         WrtAddress => WrtAddress,
         rst => rst,
         Data_in => Data_in,
         Data_out => Data_out);
stimuli: process
begin
    clk <= '0';
    RW <= '1';
    Data_in <= "01100110";
    wait for 10ns;
    clk <= '1';
    wait for 10ns;
    clk <= '0';
    RW <= '0';
    Data_in <= (others => '0');
    
    wait;
end process;
end Behavioral;
