
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

 
ENTITY main_test IS
END main_test;
 
ARCHITECTURE behavior OF main_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Main
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         start : IN  std_logic;
         run : IN  std_logic;
         step : IN  std_logic;
         regA : OUT  std_logic_vector(7 downto 0);
         regB : OUT  std_logic_vector(7 downto 0);
         regC : OUT  std_logic_vector(7 downto 0);
         regIC : OUT  std_logic_vector(7 downto 0);
         regIR : OUT  std_logic_vector(7 downto 0);
         regIDR : OUT  std_logic_vector(7 downto 0);
         regIACR : OUT  std_logic_vector(7 downto 0);
         regPACR : OUT  std_logic_vector(7 downto 0);
			regADR : OUT  std_logic_vector(7 downto 0);
			
			state_0, state_1, state_2, state_3, state_4, state_5, state_6 : out STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';
   signal run : std_logic := '0';
   signal step : std_logic := '0';

 	--Outputs
   signal regA : std_logic_vector(7 downto 0);
   signal regB : std_logic_vector(7 downto 0);
   signal regC : std_logic_vector(7 downto 0);
   signal regIC : std_logic_vector(7 downto 0);
   signal regIR : std_logic_vector(7 downto 0);
   signal regIDR : std_logic_vector(7 downto 0);
   signal regIACR : std_logic_vector(7 downto 0);
   signal regPACR : std_logic_vector(7 downto 0);
	signal regADR : std_logic_vector(7 downto 0);
	
	signal state_0, state_1, state_2, state_3, state_4, state_5, state_6 : STD_LOGIC;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Main PORT MAP (
          clk => clk,
          reset => reset,
          start => start,
          run => run,
          step => step,
          regA => regA,
          regB => regB,
          regC => regC,
          regIC => regIC,
          regIR => regIR,
          regIDR => regIDR,
          regIACR => regIACR,
          regPACR => regPACR,
			 regADR => regADR,
	
			state_0 => state_0,
			state_1 => state_1,
			state_2 => state_2,
			state_3 => state_3,
			state_4 => state_4,
			state_5 => state_5,
			state_6 => state_6
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
		run <= '1';
		step <= '0';
      wait for 100 ns;	
		
		reset <= '0';
      wait for clk_period*10;

      -- insert stimulus here 
		start <= '1';
		wait for clk_period*4;
		
		start <= '0';

      wait;
   end process;

END;
