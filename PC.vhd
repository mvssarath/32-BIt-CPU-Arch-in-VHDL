--Program Counter
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity pc is
   port( --statesig: in std_logic_vector(2 DOWNTO 0);
         pcctrl: in std_logic_vector(1 DOWNTO 0);--00: initialize pc, 01: pc+4, 10: output new pc, 11:reset pc
         newpc: out std_logic_vector(31 DOWNTO 0) );
end pc;

ARCHITECTURE behavior_pc of pc is
   BEGIN
       process(pcctrl)
           variable num4 : std_logic_vector(31 downto 0) :="00000000000000000000000000000100";
           variable temp: std_logic_vector(31 DOWNTO 0);
           BEGIN
               --PC initialization
               if pcctrl="00" then
                    temp:="00000000000000000000000000000000";
                -- pc address+4
               elsif pcctrl="01" then
                    --newpc <= temp;
                    temp:=temp+num4;
                    --newpc <= temp;
                --ouput pc address
               elsif pcctrl="10" then
                    newpc <=temp;
                --reset pc
                elsif pcctrl="11" then
                    temp:="00000000000000000000000000000000";
               end if;
       end process;
end behavior_pc;