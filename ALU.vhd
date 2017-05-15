--ALU

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
entity ALU is
    port(instrtype: in std_logic_vector(2 DOWNTO 0);
         --statesig: in std_logic_vector(2 DOWNTO 0);
         srcA: in std_logic_vector(31 DOWNTO 0);
         srcB: in std_logic_Vector(31 DOWNTO 0);
         aluout: out std_logic_vector(31 DOWNTO 0));
end ALU;

ARCHITECTURE behavior_ALU of ALU is
   -- variable result: std_logic_vector(31 DOWNTO 0);
    begin
        process(instrtype)
            variable tempval: std_logic_vector(31 DOWNTO 0);
            begin
            ---add
           -- if statesig="011" then
            if instrtype="001" then
                aluout <= srcA+srcB;
            ---and
            elsif instrtype="010" then
                aluout <= srcA and srcB;
            ---slt
            elsif instrtype="011" then
                if srcA>=srcB then
                    aluout <= "00000000000000000000000000000000";
                else
                    aluout <="00000000000000000000000000000001";
                end if;
            ---nor
            elsif instrtype="100" then
                aluout <= srcA nor srcB;
            ---sub
            elsif instrtype="101" then
                aluout <= srcA-srcB;
            elsif instrtype="110" then
                tempval :=srcA;
                tempval(31 DOWNTO 16):=tempval(15 DOWNTO 0);
                tempval(15 DOWNTO 0):="0000000000000000";
                aluout <=tempval;
            end if;
       -- end if;
        end process;
end behavior_ALU;
