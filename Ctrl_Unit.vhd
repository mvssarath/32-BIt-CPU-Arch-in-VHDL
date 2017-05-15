--Control Unit
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity ctrlunit is
    port(clk: in std_logic;
         dataA,dataB:in std_logic_vector(31 DOWNTO 0);
         instr_out:in std_logic_vector(31 DOWNTO 0);
         ic_h,dc_h: in std_logic_vector(1 DOWNTO 0);
         xfersigout: in std_logic;
         --opcode: in std_logic_vector(5 DOWNTO 0);
         --funfield: in std_logic_vector(5 DOWNTO 0);
         cachetype: out std_logic;
         optype: out std_logic_vector(1 DOWNTO 0);
         instrtype: out std_logic_vector(2 DOWNTO 0);
         cacheoutsig: out std_logic;
         rfop: out std_logic;
         --statesig:out std_logic_vector(2 DOWNTO 0);
         pcctrl:out std_logic_vector(1 DOWNTO 0);
         irctrl: out std_logic;
         xfersigin: out std_logic_vector(2 DOWNTO 0);
         srcA,srcB: out std_logic_vector(31 DOWNTO 0);
         ivalueB: out std_logic_vector(31 DOWNTO 0);
         mem_op_ctrl: out std_logic;
         mdrenable: out std_logic;
         regA: out std_logic_vector(4 DOWNTO 0);
         regB: out std_logic_vector(4 DOWNTO 0);
         --imval:out std_logic_vector(31 DOWNTO 0);
         --jimval:out std_logic_vector(31 DOWNTO 0);
         sel1,selB,selA: out std_logic
          );
end ctrlunit;

ARCHITECTURE behavior_ctrlunit of ctrlunit is
    signal instatesig: std_logic_vector(2 DOWNTO 0);
    begin
        process(clk, instatesig,ic_h,dc_h,xfersigout)
            variable memref: std_logic_vector(1 DOWNTO 0);
            variable irvalue: std_logic_vector(31 DOWNTO 0);
            variable opcode: std_logic_vector(5 DOWNTO 0);
            variable funfield: std_logic_vector(5 DOWNTO 0);
            variable rs,rt,rd: std_logic_vector(4 DOWNTO 0);
            variable immvalue: std_logic_vector(31 DOWNTO 0) :="00000000000000000000000000000000";
            variable dataregA,dataregB: std_logic_vector(31 DOWNTO 0);
            variable muxsel1,muxselA,muxselB:std_logic;
            variable aluop:std_logic_vector(2 DOWNTO 0);
            variable jimmvalue: std_logic_vector(25 DOWNTO 0);
            begin
            if clk'event and clk='1' then
                --system initial state
                --initialize pc
                if instatesig="000" then
                    pcctrl<="00";
                    instatesig <="001";
                --Cycle 1 --instruction fetch
                elsif instatesig="001" then
                    --fetch istruction from I cache
                    --signal pc to output current address to cache
                    pcctrl<="10";
                    pcctrl<="01";
                    optype <= "00";
                    cachetype <='0';
                    --I cache  read hit
                    if ic_h="01" then
                        cacheoutsig <='1';
                        irctrl<='0';
                        instatesig <="010";
                    --I cache read miss
                    elsif ic_h="00" then
                        optype <="10";
                        cachetype<='0';
                        while xfersigout /='0' loop
                           xfersigin <="001" after 800ns;
                           xfersigin <="011" after 800ns;
                           xfersigin <="101" after 800ns;
                           xfersigin <="111" after 800ns;
                        end loop;
                        irctrl<='0';
                        instatesig <="010";
                    end if;
                --Cycle 2 --instruction decode and register read
                elsif instatesig="010" then
                    --instruction decode
                    --siganl IR to output instruction
                    irctrl<='1';
                    irvalue:=instr_out;
                    opcode:=irvalue(31 DOWNTO 26);
                    --1. load
                    if opcode="100011" then 
                          
                          rs:=irvalue(25 DOWNTO 21);
                          regA<=rs;
                          rfop<='0';
                          dataregA:=dataA;
                          rt:= irvalue(20 DOWNTO 16);
                          immvalue(15 DOWNTO 0):=irvalue(15 DOWNTO 0);
                          aluop:="001";
                          muxselB := '1';
                          memref:="01";
                    --2. store
                    elsif opcode="101011" then
                         -- rfop <='1';
                          rs:=irvalue(25 DOWNTO 21);
                          regA<=rs;
                          rfop<='1';
                          dataregA:=dataA;
                          rt:= irvalue(20 DOWNTO 16);
                          immvalue(15 DOWNTO 0):=irvalue(15 DOWNTO 0);
                          aluop:="001";
                          muxselB := '1';
                          memref:="11";
                    --3. R type
                    elsif opcode="000000" then
                           rs:=irvalue(25 DOWNTO 21);
                           rt:= irvalue(20 DOWNTO 16);
                           rd:=irvalue(15 DOWNTO 11);
                           funfield:=irvalue(5 DOWNTO 0);
                          regA<=rs;
                          regB<=rt;
                          rfop<='0';
                          dataregA:=dataA;
                          dataregB:=dataB;
                           --rfop<='0';
                          --add operation
                          if funfield="100000" then
                             instrtype<="001";
                           --and operation
                          elsif funfield="100100" then
                              aluop:="010";
                            --slt operation
                          elsif funfield="101010" then
                              aluop:="011";
                            --nor operation
                          elsif funfield="101101" then
                              aluop:="100";
                          end if;
                          muxselB:='0';
                          muxselA:='0';
                    --4. Branch
                    elsif opcode="000100" then
                          rfop<='0';
                          instrtype<="001";
                          selB<='1';
                          sel1<='1';   
                    --5. J type
                    elsif opcode="000010" then
                           immvalue(25 DOWNTO 0):=irvalue(25 DOWNTO 0);
                    
                          muxselA:='1';
                          muxselB:='1';
                          muxsel1:='1';
                    --6. JAL
                    elsif opcode="000011" then
                           jimmvalue:=irvalue(25 DOWNTO 0);
                    
                          muxselA:='1';
                          muxselB:='1';
                          muxsel1:='1';
                    end if;
                    instatesig<="011";
                --Cycle 3 --Execution in ALU
                elsif instatesig="011" then
                    srcA<=dataregA;
                    srcB<=dataregB;
                    ivalueB<="00000000000000"& immvalue&"00";
                    instatesig<="100";
                --Cycle 4 --Memory reference
                elsif instatesig="100" then
                   -- statesig<="100";
                    --For load 
                    if memref="01" then
                        sel1<='1';
                        optype<="00";
                        cachetype<='1';
                        --D cache read hit
                        if dc_h="01" then
                            mdrenable<='1';
                        --D cache read miss
                        elsif dc_h="10" then
                            --transfer data from mem to cache
                            optype<="00";
                            while xfersigout /='0' loop
                              xfersigin <="001" after 800ns;
                              xfersigin <="011" after 800ns;
                              xfersigin <="101" after 800ns;
                              xfersigin <="111" after 800ns;
                            end loop;
                        end if;
                    --For store    
                    elsif memref="11" then
                       sel1<='1';
                       optype<="01";
                       cachetype<='1';
                       --D cache write hit
                       if dc_h="11" then
                           cacheoutsig<='1';
                       --D cache write miss
                       elsif dc_h="10" then
                           --write into mem
                           mem_op_ctrl<='1';
                           --transfer block of data into cache
                           optype<="10";
                           while xfersigout /='0' loop
                              xfersigin <="001" after 800ns;
                              xfersigin <="011" after 800ns;
                              xfersigin <="101" after 800ns;
                              xfersigin <="111" after 800ns;
                           end loop;
                        end if;
                    end if;
                    instatesig<="101";
                ---Cycle 5 --Write back to register
                elsif instatesig="101" then
                        --statesig<="101";
                        rfop<='1';
                end if;
        end if;
        end process;
end behavior_ctrlunit;