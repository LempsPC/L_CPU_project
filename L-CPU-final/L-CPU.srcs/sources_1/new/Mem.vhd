library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Mem is 
  generic (BitWidth: integer);
  port ( RdAddress: in std_logic_vector (BitWidth-1 downto 0);
         Data_in: in std_logic_vector (BitWidth-1 downto 0);
			WrtAddress: in std_logic_vector (BitWidth-1 downto 0);
         clk: in std_logic;
         RW: in std_logic;
         rst: in std_logic;
         Data_Out: out std_logic_vector (BitWidth-1 downto 0) 
    );
end Mem;

architecture beh of Mem is

  type Mem_type is array (0 to (2**BitWidth)-1) of std_logic_vector(BitWidth-1 downto 0);
   signal Mem : Mem_type;
   
begin
 
 
 MemProcess: process(clk,rst) is

  begin
    if rst = '1' then 
      Mem <= (  
      0 => "00010111", --17laeme M-registrisse aadressi, kust laadida
      1 => "00100100", --24esimese teguri aadress
      2 => "00001001", --09laeme andmed mälust aadressiga 24h
      3 => "00010111", --17laeme M-registrisse aadressi, kust laadida
      4 => "00100101", --25teise teguri aadress
      5 => "00001011", --0blaeme andmed mälust aadressiga 25h
      6 => "00110111", --kopeerime A sisu M’ registrisse
      7 => "01000010", --kopeerime C sisu B’ registrisse
      8 => "11111011", --dekrementeerime B väärtust, tulemus C'sse
      9 => "00110010", --kopeerime A sisu B'sse
      10 => "10100001", --liidame A ja B, tulemus A'sse
      11 => "01000010", --42 kopeerime c väärtuse C'sse
      12 => "11111011", --FB dekrementeerime B väärtust, tulemus C'sse
      13 => "01001010", --4A kopeerime M väärtuse B'sse
      14 => "01011000", --58 jump if tulemus on 0
      15 => "00010010", --12 aadress, kuhu hüpada, dec'is on see 18
      16 => "01110000", --70 hüppame tagasi aadressile, kust liitsime
      17 => "00001010", --0Aaadress, kuhu hüppame, Dec'is on see 10
      18 => "00010111",
      19 => "00100110",
      20 => "00110011",
      21 => "00100000",
      
      36 => "00001000",
      37 => "00000100",
 
      others => "00000000");
    elsif rising_edge(clk) then
      if RW = '1' then
        Mem(to_integer(unsigned(WrtAddress(7 downto 0)))) <= Data_in;
      end if;
  
    end if;
  end process MemProcess;

  Data_Out <= Mem(to_integer(unsigned(RdAddress(7 downto 0))));
  
end beh;