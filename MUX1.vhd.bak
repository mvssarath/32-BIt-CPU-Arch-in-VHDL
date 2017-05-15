--select the address between PC and AlU branch address
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity mux1 is
    port( pcaddr: in std_logic_vector(31 DOWNTO 0);
          aluaddr: in std_logic_vector(31 DOWNTO 0);
          sel1: in std_logic;--0 choose pc address, 1 choose ALU address
          mux1out: out std_logic_vector(31 DOWNTO 0));
end mux1;

ARCHITECTURE behavior_mux1 of mux1 is
    begin
        process(sel1)
            begin
                if sel1='0' then
                    mux1out <=pcaddr;
                elsif sel1='1' then
                    mux1out <=aluaddr;
                end if;
            end process;
    end behavior_mux1;