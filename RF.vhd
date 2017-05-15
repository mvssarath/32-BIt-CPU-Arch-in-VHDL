-- Register file
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity RF is
    port(regA: in std_logic_vector(4 DOWNTO 0);
         regB: in std_logic_vector(4 DOWNTO 0);
         rfop: in std_logic;--0 means register read. 1 means register write.
         datain: in std_logic_vector(31 DOWNTO 0);
         dataA: out std_logic_vector(31 DOWNTO 0);
         dataB: out std_logic_vector(31 DOWNTO 0)
          );
end RF;

ARCHITECTURE behavior_RF of RF is
    begin
        process(rfop)
            type regfile is array(31 DOWNTO 0) of std_logic_vector(31 DOWNTO 0);
            variable regs: regfile; 
            variable regAaddr: integer;
            variable regBaddr: integer;
            begin
                --register read
                if rfop='0' then
                    regAaddr:= conv_integer(regA);
                    regBaddr:= conv_integer(regB);
                    dataA <= regs(regAaddr);
                    dataB <= regs(regBaddr);
                elsif rfop='1' then
                    regAaddr := conv_integer(regA);
                    regs(regAaddr):=datain;
                end if;
            end process;
    end behavior_RF;
                    