--select value for ALU source B
--
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity muxB is
    port( srcB: in std_logic_vector(31 DOWNTO 0);
          ivalue: in std_logic_vector(31 DOWNTO 0);
          selB: in std_logic;--0 choose sourceB value, 1 choose immediate value
          muxBout: out std_logic_vector(31 DOWNTO 0));
end muxB;

ARCHITECTURE behavior_muxB of muxB is
    begin
        process(selB)
            begin
                --output sourceB value
                if selB='0' then
                    muxBout <=srcB;
                --output immediate value
                elsif selB='1' then
                    muxBout <=ivalue;
                end if;
            end process;
end behavior_muxB;