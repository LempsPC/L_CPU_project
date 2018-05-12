--siia tuleb L-prose esimene katsetus e. kuidas see tööle hakkab
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
 
-----------------------------------------
 
entity L_CPU is
port(   reset: in std_logic;
    clk: in std_logic;
    Flags: out std_logic_vector(4 downto 0);
    debug: in std_logic;
    Data_to_ram_debug, Aadress_to_ram_debug : in std_logic_vector(7 downto 0 )
    );
end L_CPU;  
 
architecture beh of L_CPU is


component Mem is 
      generic (BitWidth: integer := 8);
      port ( RdAddress: in std_logic_vector (BitWidth-1 downto 0);
             Data_in: in std_logic_vector (BitWidth-1 downto 0);
             WrtAddress: in std_logic_vector (BitWidth-1 downto 0);
             clk: in std_logic;
             RW: in std_logic;
             rst: in std_logic;
             debug : in std_logic;
             Data_Out: out std_logic_vector (BitWidth-1 downto 0);
             Data_in_debug: in std_logic_vector (BitWidth-1 downto 0);
             WrtAddress_debug: in std_logic_vector (BitWidth-1 downto 0) 
        );
end component Mem; 
 
function add_sub (a1, b1: std_logic_vector(7 downto 0); carry_in, ctrl : std_logic) return std_logic_vector is --inspired by Hardi
    variable a1_temp, b1_temp, sum_temp : std_logic_vector(9 downto 0);
begin
    a1_temp := '0' & a1 & '1';
    if ctrl = '0' then
        b1_temp := '0' & b1 & carry_in; --liitmine, B seadistamine
    else
        b1_temp := not(std_logic_vector('0' & b1) ) & carry_in + "10"; --lahutamine, B seadistamine
    end if;
    sum_temp := a1_temp + b1_temp;
        
    return sum_temp (9 downto 1);    
    
end add_sub; 
 
TYPE State_type IS(PC_to_MAR, RAM_to_MDR, MDR_to_IR, Decode_IR, MDR_to_regX, ALU_A_B, JMP_w_FLAGS, M_to_PC, X_to_Y, M_to_MAR, MDR_to_PC, regC_to_RAM, END_Command);
signal state, next_state : State_type := PC_to_MAR; 
 
signal inner_flags, operators : std_logic_vector(2 downto 0) := (others => '0');
signal inputs : std_logic_vector(4 downto 0) := (others => '0');
signal RegA, RegB, RegC, RegM, MAR, IR, MDR : std_logic_vector(7 downto 0) := (others => '0');
signal read_write : std_logic := '0';
signal data_to_ram, data_from_ram, ram_address : std_logic_vector(7 downto 0 ) := (others => '0');

signal PC :  std_logic_vector(7 downto 0) := "00000000";
--signal Data_to_ram_debug, Aadress_to_ram_debug : std_logic_vector (7 downto 0);

 
begin

Flags <= inputs;

Memory: Mem
Port map(clk => clk,
         RW => read_write,
         RdAddress => ram_address,
         WrtAddress => ram_address,
         rst => reset,
         Data_in => data_to_ram,
         Data_out => data_from_ram,
         debug => debug,
         Data_in_debug => Data_to_ram_debug,
         WrtAddress_debug => Aadress_to_ram_debug
         );



process (state)

variable ALU_OUT, RegTemp : std_logic_vector(7 downto 0) := (others => '0');
variable ADD_SUB_OUT : std_logic_vector(8 downto 0) := (others => '0');

begin
    case state is
   
        when PC_to_MAR =>
            if inputs = "00101" then
                next_state <= regC_to_RAM;
                read_write <= '1';
            else
                next_state <= RAM_to_MDR;
            end if;
 
            MAR <= PC;
            ram_address <= PC;
           
        when RAM_to_MDR =>
            if inputs(3 downto 0) = "0000" then
             next_state <= MDR_to_IR;
            elsif (inputs(3 downto 0) = "0001" or inputs(3 downto 0) = "0010") then
             next_state <= MDR_to_regX;
            elsif (inputs(3 downto 0) = "1011" or inputs(3 downto 0) = "1100" or inputs(3 downto 0) = "1101" or inputs(3 downto 0) = "1110") then
             next_state <= MDR_to_PC;
            else
             next_state <= MDR_to_IR;
            end if;
            if not(inputs = "00001") then
            PC <= PC +1;
            end if;
            MDR <= data_from_ram;
            --Instruction copy from main memory into Memory data register
        when MDR_to_IR =>
            next_state <= Decode_IR;
            IR <= MDR;
            inputs <= MDR(7 downto 3);
            operators <= MDR(2 downto 0);
            
            
            
        when Decode_IR =>
            case inputs is
              when "00000" =>
                  next_state <= PC_to_MAR;
              when "00001" =>
                  next_state <= M_to_MAR;
              when "00010" =>
                  next_state <= PC_to_MAR;
              when "00100" =>
                  next_state <= M_to_MAR;
              when "00101" =>
                  next_state <= PC_to_MAR;
              when "00110" =>
                  next_state <= X_to_Y;
              when "00111" =>
                  next_state <= X_to_Y;
              when "01000" =>
                  next_state <= X_to_Y;
              when "01001" =>
                  next_state <= X_to_Y;
              when "01011" =>
                  next_state <= JMP_w_FLAGS; 
              when "01100" =>
                  next_state <= JMP_w_FLAGS; 
              when "01101" =>
                  next_state <= JMP_w_FLAGS; 
              when "01110" =>
                  next_state <= PC_to_MAR; --tingimusteta hüpe aadressile, mida näitab järgmine mälupesa
              
              when "10000" =>
                  next_state <= ALU_A_B;  
              when "10001" =>
                  next_state <= ALU_A_B; 
              when "10010" =>
                  next_state <= ALU_A_B; 
              when "10011" =>
                  next_state <= ALU_A_B;
              when "10100" =>
                  next_state <= ALU_A_B; 
              when "10101" =>
                  next_state <= ALU_A_B;
              when "10110" =>
                  next_state <= ALU_A_B;
              when "10111" =>
                  next_state <= ALU_A_B;
              when "11000" =>
                  next_state <= ALU_A_B;
              when "11001" =>
                  next_state <= ALU_A_B;
              when "11010" =>
                  next_state <= ALU_A_B;
              when "11011" =>
                  next_state <= ALU_A_B;
              when "11100" =>
                  next_state <= ALU_A_B;
              when "11101" =>
                  next_state <= ALU_A_B;
              when "11110" =>
                  next_state <= ALU_A_B;                            
              when "11111" =>
                  next_state <= ALU_A_B; 
                        
              when others =>
                  next_state <= PC_to_MAR;
              end case;
              --this microcommand does nothing, only decides
        
        when MDR_to_regX =>
            RegTemp := MDR;
            case operators is
                when "001" =>
                    RegA <= RegTemp;
                when "010" =>
                    RegB <= RegTemp;
                when "011" =>
                    RegC <= RegTemp;
                when "100" =>
                    MAR <= RegTemp;
                when "101" =>
                    MDR <= RegTemp;
                when "110" =>
                    IR <= RegTemp;
                when "111" =>
                     RegM <= RegTemp;
                when others =>                
                end case; 
                
            next_state <= END_Command;
        
        when ALU_A_B =>
            next_state <= END_Command;
            
            case inputs is
                when "10000" =>
                    ALU_OUT := RegA and RegB;
                when "10001" =>
                    ALU_OUT := RegA or RegB;
                when "10010" =>
                    ALU_OUT := RegA nor RegB;
                when "10011" =>
                    ALU_OUT := RegA xor RegB;
                when "10100" =>
                    --ALU_OUT := std_logic_vector( unsigned(RegA) + unsigned(RegB) ); --liitmine ülekandeta
                    ADD_SUB_OUT := add_sub(RegA, RegB, '0', '0'); --liitjaA, liitjaB, carry_in, 0/liida 1/lahuta
                    ALU_OUT := ADD_SUB_OUT(7 downto 0);
                    
                    if ADD_SUB_OUT(8) = '1' then
                        inner_flags(1) <= '1';
                    else
                        inner_flags(1) <= '0';
                    end if;
                    
                when "10101" =>
                    --ALU_OUT := std_logic_vector( unsigned(RegA) - unsigned(RegB) ); --lahutamine
                    
                    ADD_SUB_OUT := add_sub(RegA, RegB, inner_flags(1), '1'); --liitjaA, liitjaB, carry_in, 0/liida 1/lahuta
                    ALU_OUT := ADD_SUB_OUT(7 downto 0);
                                        
                    if ADD_SUB_OUT(8) = '1' then
                        inner_flags(1) <= '1';
                    else
                        inner_flags(1) <= '0';
                    end if;
                    
                when "10110" =>
                    --compare A ja B, uuri täpsemalt, kuidas
                    --ALU_OUT :=  (others => '0');
                    if RegA < RegB then
                        ALU_OUT := "00000100";
                    elsif RegA > RegB then
                        ALU_OUT := "00000001";
                    elsif RegA = RegB then
                        ALU_OUT := "00000010";
                        --flagidesse lisamine
                        inner_flags(0) <= '1';
                    else
                        ALU_OUT := "00000000";
                        
                    end if;
                        
                    
                when "10111" =>
                    ALU_OUT := std_logic_vector( unsigned(RegA) + unsigned(RegB) +1 ); --liitmine ülekandega
                
                when "11000" =>
                    ALU_OUT := (RegA(0) & RegA(7 downto 1)); --A ringnihe paremale
                when "11001" =>
                    ALU_OUT := (RegB(0) & RegB(7 downto 1));  --B ringnihe paremale   
                when "11010" =>
                    ALU_OUT := (RegA(6 downto 0) & RegA(7));  --A ringnihe paremale 
                when "11011" =>
                    ALU_OUT := (RegB(6 downto 0) & RegB(7));  --B ringnihe vasakule
                when "11100" =>
                    ALU_OUT := not RegA;  -- A inverteerimine
                when "11101" =>
                    ALU_OUT := not RegB;  -- B inverteerimine
                when "11110" =>
                    ALU_OUT := std_logic_vector( unsigned(RegB) +1 ); --B inkrementeerimine
                when "11111" =>
                    ALU_OUT := std_logic_vector( unsigned(RegB) -1 ); --B dekrementeerimine        
                 
                when others =>
                    --do nothing, set ALU output to 0
                    ALU_OUT :=  (others => '0');
            end case;
            --tulemregistri dekoodri umb
            --kaudne simulatsioon :D
            
            --lippudesse kirjutamine:
            if ALU_OUT = "00000000" then
                inner_flags(2) <= '1';
            else
                inner_flags(2) <= '0';
            end if;
            
            if RegA = RegB then
                inner_flags(0) <= '1';
            else
                inner_flags(0) <= '0';
            end if;
            
            
            case operators is
                when "001" =>
                    RegA <= ALU_OUT;
                when "010" =>
                    RegB <= ALU_OUT;
                when "011" =>
                    RegC <= ALU_OUT;
                when "100" =>
                    MAR <= ALU_OUT;
                when "101" =>
                    MDR <= ALU_OUt;
                when "110" =>
                    IR <= ALU_OUT;
                when "111" =>
                    RegM <= ALU_OUT;
                when others =>
                    
                    
            end case;
        
        when JMP_w_FLAGS =>
            --jump tingimuse kontrollimine inner flags: [null, ületäitumine, võrdne]
            --kui tingimus ei ole täidetud, lõpetame käsu
            --kui tingimus on täidetud, hüppame järgmise käsuga sinna, kuhu näitab M-register
            if ( inputs = "01011" AND inner_flags(2) = '0') then
                next_state <= END_Command;
                PC <= PC+1;
            elsif( inputs = "01011" AND inner_flags(2) = '1') then
                next_state <= PC_to_MAR;
            elsif( inputs = "01100" AND inner_flags(1) = '0' ) then
                next_state <= END_Command;
                PC <= PC+1;
            elsif( inputs = "01100" AND inner_flags(1) = '1') then
                next_state <= PC_to_MAR;
            elsif( inputs = "01101" AND inner_flags(0) = '0') then
                next_state <= END_Command;
                PC <= PC+1;
            elsif( inputs = "01101" AND inner_flags(0) = '1') then
                next_state <= PC_to_MAR;
            
            else
                next_state <= END_Command;
            end if;
            
        when M_to_PC =>
            next_state <= END_Command;
            PC <= regM;
            
        when MDR_to_PC =>
            next_state <= END_Command;
            PC <= MDR;
        
        when X_to_Y =>
            
            case inputs is
                when "00110" =>
                    RegTemp := RegA;
                when "00111" =>
                    RegTemp := RegB;
                when "01000" =>
                    RegTemp := RegC;
                when "01001" =>
                    RegTemp := RegM;
                when others =>
                    RegTemp := (others => '0');
            end case;
            
            case operators is
                when "001" =>
                    RegA <= RegTemp;
                when "010" =>
                    RegB <= RegTemp;
                when "011" =>
                    RegC <= RegTemp;
                when "100" =>
                    MAR <= RegTemp;
                when "101" =>
                    MDR <= RegTemp;
                when "110" =>
                    IR <= RegTemp;
                when "111" =>
                     RegM <= RegTemp;
                when others =>                
            end case; 
            next_state <= END_Command;
        
        
        when M_to_MAR =>
            
            if ( inputs = "00001" ) then
                
                next_state <= RAM_to_MDR;
            elsif (inputs = "00100") then
                read_write <= '1';
                next_state <= regC_to_RAM;
            else
                next_state <= END_Command;
            end if;
            MAR <= RegM; --RegM kopeerimine MAR'i
            ram_address <= RegM;
            
        when regC_to_RAM =>
            data_to_ram <= regC;
            next_state <= END_Command;
            if inputs = "00101" then  --vahetu mälupöörduskorral liigutaks PC 1 võrra edasi, muidu loeme järgmiseks käsuks andmebaiti, mida just kirjutasime
                PC <= PC +1;
            end if;
        
        when END_Command =>
            next_state <= PC_to_MAR;
            IR <= (others => '0'); -- IR peaks käsu lõpus olema 0, muidu CPu ei saa aru, et käsk on lõppenud, sellega ka inputid lähevad 0'ks
            operators <= (others => '0'); --tulemregistri dekooder ka 0'i
            inputs <= "00000"; --selle muudan ka siin kohe ära, lihtsam
            read_write <= '0'; 
            data_to_ram <= (others => '0');
        when others =>
            next_state <= END_Command;
       
       
               
   
    end case;
 
end process;
 
process (clk)
begin
    if rising_edge(clk) then
        state <= next_state;
    end if;
end process;


 
end beh;

