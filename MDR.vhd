--Memory data register
--store the data load from mem by "load" instruction
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity MDR is
   port(data_in: in std_logic_vector(31 DOWNTO 0);
        --ld:in std_logic;
        mdrenable: in std_logic;
        data_out: out std_logic_vector(31 DOWNTO 0));
end MDR;

ARCHITECTURE behavior_MDR of MDR is
    
   begin
       process(mdrenable)
           variable data: std_logic_vector(31 DOWNTO 0);
           begin
               if mdrenable='1' then
                   data := data_in;
               end if;
       end process;
end behavior_MDR;
