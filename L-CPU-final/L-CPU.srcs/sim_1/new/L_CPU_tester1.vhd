----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2018 12:25:36 PM
-- Design Name: 
-- Module Name: L_CPU_tester1 - Behavioral
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

entity L_CPU_tester1 is
--  Port ( );
end L_CPU_tester1;

architecture Behavioral of L_CPU_tester1 is

component  L_CPU is
port(   reset: in std_logic;
    clk: in std_logic;
    Flags: out std_logic_vector(4 downto 0));
end component L_CPU;  

signal reset : std_logic := '0';
signal clk : std_logic := '0';
signal Flags : std_logic_vector(4 downto 0);

begin

UUT: L_CPU
Port map(reset => reset,
         clk => clk,
         Flags => Flags);
stimuli: process

begin
    clk <= '0';
    reset <='1';
    wait for 10ns;
    reset <= '0';
    wait for 10ns;
    for i in 0 to 255 loop
        clk <= '1';
        wait for 10ns;
        clk <= '0';
        wait for 10ns;
    end loop;
    wait;
    
end process;
end Behavioral;
