library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux8 is
Port(
	I0, I1, I2, I3, I4, I5, I6, I7 : in STD_LOGIC_VECTOR(7 downto 0);
	sel : in STD_LOGIC_VECTOR(2 downto 0);
	
	o : out STD_LOGIC_VECTOR(7 downto 0)
);
end Mux8;

architecture Behavioral of Mux8 is

component Mux4
Port(
	I0, I1, I2, I3 : in STD_LOGIC_VECTOR(7 downto 0);
	sel : in STD_LOGIC_VECTOR(1 downto 0);
	
	o : out STD_LOGIC_VECTOR(7 downto 0)
);
end component;

component Mux2
Port(
	I0, I1 : in STD_LOGIC_VECTOR(7 downto 0);
	sel : in STD_LOGIC;
	
	o : out STD_LOGIC_VECTOR(7 downto 0)
);
end component;

signal o0, o1 : STD_LOGIC_VECTOR(7 downto 0);
signal sel_s : STD_LOGIC_VECTOR(1 downto 0);

begin

sel_s(0) <= sel(0);
sel_s(1) <= sel(1);

M4_0: Mux4 port map (I0, I1, I2, I3, sel_s, o0);
M4_1: Mux4 port map (I4, I5, I6, I7, sel_s, o1);

M2: Mux2 port map (o0, o1, sel(2), o);

end Behavioral;

