--combine components together
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity cpu is
    port(statesig: in std_logic_vector(2 DOWNTO 0);
         instrtype: in std_logic_vector(2 DOWNTO 0);
         rfop,mdrenable, sel1, selA, selB: in std_logic;
         aluout: out std_logic_vector(31 DOWNTO 0)
          );
end cpu;

ARCHITECTURE behavior_cpu of cpu is
    component ALU is
        port(instrtype: in std_logic_vector(2 DOWNTO 0);
         --statesig: in std_logic_vector(2 DOWNTO 0);
         srcA: in std_logic_vector(31 DOWNTO 0);
         srcB: in std_logic_Vector(31 DOWNTO 0);
         aluout: out std_logic_vector(31 DOWNTO 0));
    end component ALU;
    component PC is
        port(pcctrl: in std_logic_vector(1 DOWNTO 0);
             newpc: out std_logic_vector(31 DOWNTO 0) );
    end component pc;
    component IR is
        port(instr_in: in std_logic_vector(31 DOWNTO 0);
             irctrl: in std_logic;
             instr_out:out std_logic_vector(31 DOWNTO 0)  );
    end component IR;
    component MDR is
        port(data_in: in std_logic_vector(31 DOWNTO 0);
             mdrenable: in std_logic;
             data_out: out std_logic_vector(31 DOWNTO 0)
              );
    end component;
    component mux1 is
        port(pcaddr: in std_logic_vector(31 DOWNTO 0);
             aluaddr: in std_logic_vector(31 DOWNTO 0);
             sel1: in std_logic;
             mux1out: out std_logic_vector(31 DOWNTO 0)
              );
    component RF is
        port(regA,regB: in std_logic_vector(4 DOWNTO 0);
             datain: in std_logic_vector(31 DOWNTO 0);
             rfop: in std_logic;
             dataA, dataB: out std_logic_vector(31 DOWNTO 0)
              );
    end component RF;
    component muxA is
        port(srcA: in std_logic_vector(31 DOWNTO 0);
             ivalueA: in std_logic_vector(31 DOWNTO 0) :="00000000000000000000000000000000";
             selA: in std_logic;
             muxAout: out std_logic_vector(31 DOWNTO 0)
               );
    end component muxA;
    component muxB is
        port(srcB: in std_logic_vector(31 DOWNTO 0);
             ivalueB: in std_logic_vector(31 DOWNTO 0);
             selB: in std_logic;
             muxBout: out std_logic_vector(31 DOWNTO 0)
              );
    end component muxB;
    --
    signal instrtype: std_logic_vector(2 DOWNTO 0);
    signal srcA,srcB,aluout: std_logic_vector(31 DOWNTO 0);
    signal newpc: std_logic_vector(31 DOWNTO 0);
    signal pcctrl: std_logic_vector(1 DOWNTO 0);
    signal irctrl: std_logic;
    signal instrin,instrout: std_logic_vector(31 DOWNTO 0);
    signal data_in,data_out: std_logic_vector(31 DOWNTO 0);
    signal mdrenable:std_logic;
    signal pcaddr,aluaddr,mux1out,srcA,ivalueA,muxAout,srcB,ivalueB,muxBout:std_logic_vector(31 DOWNTO 0);
    signal sel1,selA,selB:std_logic;
    signal regA,regB: std_logic_vector(4 DOWNTO 0);
    signal dataA,dataB,datain: std_logic_vector(31 DOWNTO 0);
    signal rfop: std_logic;
    begin
         alu: port map(instrtype,)