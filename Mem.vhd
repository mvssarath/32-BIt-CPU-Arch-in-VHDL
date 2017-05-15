--Memory
--Mem is divided into two parts. One for instruction, one for data.
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
entity Mem is
    port(--clk: in std_logic;
         memxferin: in std_logic;
         mem_in: in std_logic_vector(7 DOWNTO 0);
         dc_w_h: in std_logic;
         addr_in: in std_logic_vector(31 DOWNTO 0);
         mem_op_ctrl: in std_logic;
         addr_out: out std_logic_vector(31 DOWNTO 0);
         mem_out: out std_logic_vector(7 DOWNTO 0);
         memxferout: out std_logic
            );
         
end Mem;

ARCHITECTURE behavior_Mem of Mem is
    type memaddr is array(2047 DOWNTO 0) of std_logic_vector(7 DOWNTO 0);--array type ;
    
    begin
    process(memxferin, mem_op_ctrl)
        variable addr: memaddr;
        variable tot_addr: integer;
        variable tempaddr: integer;
        begin
    --Mem read
    if mem_op_ctrl='0' then
        tempaddr := conv_integer(addr_in);
        for i in tempaddr to tempaddr+15 loop
           --output the content of mem to cache
           mem_out <= addr(i);
           addr_out <= conv_std_logic_vector(i,32);
        end loop;
    --Mem write
    elsif mem_op_ctrl='1' then
        if tot_addr<2048 then
           tempaddr := conv_integer(addr_in);
           if tempaddr<=tot_addr then
               --I 
               if dc_w_h='1' then
                   --write the word into mem
                   for i in tempaddr to tempaddr+3 loop
                      addr(i) :=mem_in;
                   end loop;
                elsif dc_w_h='0' then
                    --write the word into mem
                    for i in tempaddr to tempaddr+3 loop
                      addr(i) :=mem_in;
                    end loop;
                    --bring one block to cache
                    for i in tempaddr to tempaddr+15 loop
                       mem_out <= addr(i);
                       addr_out <= conv_std_logic_vector(i,32);
                    end loop; 
                              
                else
                   --report 
                   addr_out <="00000000000000000000000000000000";
                   mem_out <="00000000";
                end if;
            elsif tempaddr>tot_addr then
                --write the word into mem
                for i in tempaddr to tempaddr+3 loop
                   addr(i) :=mem_in;
                end loop;
                --tot_addr+4
                tot_addr :=tot_addr+4;
            else
               --report
               addr_out <="00000000000000000000000000000000";
               mem_out <="00000000";
           end if;
        elsif tot_addr=2048 then
            tempaddr := conv_integer(addr_in);
            if tempaddr <=tot_addr then
                if dc_w_h='1' then
                    --write the word into mem
                    for i in tempaddr to tempaddr+3 loop
                      addr(i) :=mem_in;
                    end loop;
                elsif dc_w_h='0' then
                    --write the word into mem
                    for i in tempaddr to tempaddr+3 loop
                      addr(i) :=mem_in;
                    end loop;
                    --bring one block into cache
                    for i in tempaddr to tempaddr+15 loop
                       mem_out <= addr(i);
                       addr_out <= conv_std_logic_vector(i,32);
                    end loop;
                else
                   -- report
                   addr_out <="00000000000000000000000000000000";
                   mem_out <="00000000";
                end if;
            elsif tempaddr>tot_addr then
                --report mem full
                addr_out <="00000000000000000000000000000000";
               mem_out <="00000000";
            else
           --report mem full
           addr_out <="00000000000000000000000000000000";
               mem_out <="00000000";
            end if;
       else
       --report error
       addr_out <="00000000000000000000000000000000";
       mem_out <="00000000";
       end if;
   end if;
   end process;
 end behavior_Mem;