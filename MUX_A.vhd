--select value for ALU sourceA
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity muxA is
    port( srcA: in std_logic_vector(31 DOWNTO 0);
          ivalueA: in std_logic_vector(31 DOWNTO 0) :="00000000000000000000000000000000";
          selA: in std_logic;--0 choose sourceA value, 1 choose immediate value 0
          muxAout: out std_logic_vector(31 DOWNTO 0));
end muxA;

ARCHITECTURE behavior_muxA of muxA is
    begin
        process(selA)
            begin
                --output sourceA value
                if selA='0' then
                    muxAout <=srcA;
                --output immediate value 0
                elsif selA='1' then
                    muxAout <=ivalueA;
                end if;
            end process;
    end behavior_muxA;
