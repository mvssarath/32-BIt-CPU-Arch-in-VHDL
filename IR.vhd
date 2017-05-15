--Instruction Register
--Store fetched Instructions
--one input and one output is instruction
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity IR is
    port(instr_in: in std_logic_vector(31 DOWNTO 0);
         irctrl: in std_logic;  --_vector(1 DOWNTO 0);
         instr_out: out std_logic_vector(31 DOWNTO 0));
end IR;

ARCHITECTURE behavior_IR of IR is
    signal instr: std_logic_vector(31 DOWNTO 0);
    begin
        process(irctrl)
            begin
            --store the instruction in IR
              if irctrl='0' then
                 instr <= instr_in;
            --output the instruction for decoding
              elsif irctrl='1' then
                  instr_out <= instr;
              end if;
          end process;       
end behavior_IR;
