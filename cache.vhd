--Cache
--Assumming in case of miss in cache, block of data or instructions firstly
--be carried into cache.
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity cache is
    port(
         cachetype: in std_logic;--0 is I cache, 1 is D cache
         xfersigin: in std_logic_vector(2 DOWNTO 0);
         addrin: in std_logic_vector(31 DOWNTO 0);
         datain: in std_logic_vector(31 DOWNTO 0);
         cacheoutsig: in std_logic;
         optype: in std_logic_vector(1 DOWNTO 0);--"00" is read, "01" is write, "10" is transfer, "11" is reset
         ic_h,dc_h:out std_logic_vector(1 DOWNTO 0);
         cacheout: out std_logic_vector(31 DOWNTO 0);
         addrout: out std_logic_vector(31 DOWNTO 0);
         xfersigout: out std_logic
          );
end cache;

ARCHITECTURE behavior_cache of cache is
    --D cache
    type dcacheblk is array(15 DOWNTO 0) of std_logic_vector(151 DOWNTO 0);
    --I cache
    type icacheblk is array(31 DOWNTO 0) of std_logic_vector(150 DOWNTO 0);
    begin
        process(optype, cachetype, xfersigin,cacheoutsig)
            --I cache declaration
            variable iblk: icacheblk;
            variable tot_iblk: integer;
            variable tempiblk_i: integer;
            variable tempiblk_v: std_logic_vector(31 DOWNTO 0);
            --D cache declaration
            variable dblk: dcacheblk;
            variable tot_dblk: integer;
            variable tempdblk_i: integer;
            variable tempdblk_v: std_logic_vector(31 DOWNTO 0);
            variable tempdata: std_logic_vector(31 DOWNTO 0);
            variable k: integer;
            begin
                   if optype="11" then
                       --reset D cache
                     --  for i in 0 to 15 loop
                       --  for j in 1 to 151 loop
                          
                       --   k:=j-1;
                        --  dblk(i)(j DOWNTO k):='0';
                       --   tot_dblk:=0;
                       --   tempdblk_i :=0;
                       --   tempdblk_v:="00000000000000000000000000000000";
                        --  tempdata:="00000000000000000000000000000000";
                        -- end loop;
                      -- end loop;
                       --reset I cache
                     --  for i in 0 to 31 loop
                       --   for j in 1 to 150 loop
                        
                        --  k:=j-1;
                      --    iblk(i)(j DOWNTO k):='0';
                         -- tot_iblk:=0;
                         -- tempiblk_i :=0;
                         -- tempiblk_v:="00000000000000000000000000000000";
                      --end loop;
                      -- end loop;
                    --cache read operation
                   elsif optype="00" then
                          --I cache read
                          if cachetype='0' then
                              tempiblk_i :=conv_integer(addrin(8 DOWNTO 4));
                              tempiblk_v :=addrin;
                              --check index to find the block
                              --check tag to see whether it is hit
                              if tempiblk_v(31 DOWNTO 9)=iblk(tempiblk_i)(150 DOWNTO 128) then
                                  --I cache read hit
                                  ic_h <="01";
                                  --get signal from control unit to output instruction
                                  if cacheoutsig='1' then
                                  if tempiblk_v(3 DOWNTO 2)="00" then
                                      cacheout <= iblk(tempiblk_i)(127 DOWNTO 96);
                                  elsif tempiblk_v(3 DOWNTO 2)="01" then
                                      cacheout <=iblk(tempiblk_i)(95 DOWNTO 64);
                                  elsif tempiblk_v(3 DOWNTO 2)="10" then
                                      cacheout <=iblk(tempiblk_i)(63 DOWNTO 32);
                                  else
                                      cacheout <=iblk(tempiblk_i)(31 DOWNTO 0);
                                  end if;
                                  end if;
                              else
                              --I cache read miss
                                  ic_h <="00";
                              end if;
                           --D cache read
                           else
                              tempdblk_i :=conv_integer(addrin(7 DOWNTO 4));
                              tempdblk_v :=addrin;
                              --check index to find the block
                              --check tag to see whether it is hit
                              if tempdblk_v(31 DOWNTO 8)=dblk(tempdblk_i)(151 DOWNTO 128) then
                                  --D cache read hit
                                  dc_h <="01";
                                  --get signal from control unit to output data
                                  if cacheoutsig='1' then
                                  if tempdblk_v(3 DOWNTO 2)="00" then
                                      cacheout <= dblk(tempiblk_i)(127 DOWNTO 96);
                                  elsif tempdblk_v(3 DOWNTO 2)="01" then
                                      cacheout <=dblk(tempdblk_i)(95 DOWNTO 64);
                                  elsif tempdblk_v(3 DOWNTO 2)="10" then
                                      cacheout <=dblk(tempdblk_i)(63 DOWNTO 32);
                                  else
                                      cacheout <=dblk(tempdblk_i)(31 DOWNTO 0);
                                  end if;
                                  end if;
                              else
                              --D cache read miss
                                  dc_h <="00";
                              end if;
                            end if;
                    --Cache write operation
                    elsif optype="01" then
                        --D cache write
                        tempdblk_i :=conv_integer(addrin(7 DOWNTO 4));
                        tempdblk_v :=addrin;
                        tempdata :=datain;
                        --check wether the word is in cache
                        if tempdblk_v(31 DOWNTO 8)=dblk(tempdblk_i)(151 DOWNTO 128) then
                            --D cache write hit
                            dc_h <="11";
                            if cacheoutsig='1' then
                            --write the word in cache
                               if tempdblk_v(3 DOWNTO 2)="00" then
                                   iblk(tempdblk_i)(127 DOWNTO 96):= tempdata;
                                --cacheout <=tempdata;
                               elsif tempdblk_v(3 DOWNTO 2)="01" then
                                   iblk(tempdblk_i)(95 DOWNTO 64):=tempdata;
                               elsif tempdblk_v(3 DOWNTO 2)="10" then
                                   iblk(tempdblk_i)(63 DOWNTO 32):=tempdata;
                               elsif tempdblk_v(3 DOWNTO 2)="11" then
                                   iblk(tempdblk_i)(31 DOWNTO 0):=tempdata;
                               end if;
                            --write the word into mem
                            cacheout <=tempdata;
                            addrout <=tempdblk_v;
                           end if;
                        else
                           --D cache write miss
                           dc_h <="10";
                        end if;
                     --Block of Data or Instructions transferred from mem to cache
                     elsif optype="10" then
                        --transfer instructions into I cache
                        if cachetype='0' then
                           tempiblk_i :=conv_integer(addrin(8 DOWNTO 4));
                           tempiblk_v :=addrin;
                           tempdata :=datain;
                           --store the block in I cache
                           if xfersigin="001" then
                               iblk(tempiblk_i)(127 DOWNTO 96):=tempdata;
                           end if;
                           if xfersigin="011" then
                               iblk(tempiblk_i)(95 DOWNTO 64) := tempdata;
                           end if;
                           if xfersigin="101" then
                               iblk(tempiblk_i)(63 DOWNTO 32) :=tempdata;
                           end if;
                           if xfersigin="111" then
                               iblk(tempiblk_i)(31 DOWNTO 0) :=tempdata;
                           end if;
                           xfersigout <='0';
                           --output the instruction
                           if tempiblk_v(3 DOWNTO 2)="00" then
                                 cacheout <= iblk(tempiblk_i)(127 DOWNTO 96);
                           elsif tempiblk_v(3 DOWNTO 2)="01" then
                                 cacheout <=iblk(tempiblk_i)(95 DOWNTO 64);
                           elsif tempiblk_v(3 DOWNTO 2)="10" then
                                 cacheout <=iblk(tempiblk_i)(63 DOWNTO 32);
                           else
                                 cacheout <=iblk(tempiblk_i)(31 DOWNTO 0);
                          end if;
                        --transfer data into D cache
                        else
                           tempdblk_i :=conv_integer(addrin(8 DOWNTO 4));
                           tempdblk_v :=addrin;
                           tempdata :=datain;
                           --store the block in D cache
                           if xfersigin="001" then
                               dblk(tempdblk_i)(127 DOWNTO 96):=tempdata;
                           end if;
                           if xfersigin="011" then
                               dblk(tempdblk_i)(95 DOWNTO 64) := tempdata;
                           end if;
                           if xfersigin="101" then
                               dblk(tempdblk_i)(63 DOWNTO 32) :=tempdata;
                           end if;
                           if xfersigin="111" then
                               dblk(tempdblk_i)(31 DOWNTO 0) :=tempdata;
                           end if;
                           xfersigout <='0';
                           --output data
                           if tempdblk_v(3 DOWNTO 2)="00" then
                                      cacheout <= dblk(tempiblk_i)(127 DOWNTO 96);
                           elsif tempdblk_v(3 DOWNTO 2)="01" then
                                      cacheout <=dblk(tempdblk_i)(95 DOWNTO 64);
                           elsif tempdblk_v(3 DOWNTO 2)="10" then
                                      cacheout <=dblk(tempdblk_i)(63 DOWNTO 32);
                           else
                                      cacheout <=dblk(tempdblk_i)(31 DOWNTO 0);
                           end if;
                        end if;
                    --else
                    end if;
            end process;
end behavior_cache;
                            
                       