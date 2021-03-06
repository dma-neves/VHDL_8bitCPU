
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAM32 is
Port(
	adr : in STD_LOGIC_VECTOR(4 downto 0);
	En : in STD_LOGIC;
	R : in STD_LOGIC;
	rw : in STD_LOGIC;
	DI : in STD_LOGIC_VECTOR(7 downto 0);
	DO : out STD_LOGIC_VECTOR(7 downto 0)
);
end RAM32;

architecture Behavioral of RAM32 is

component Mem32b
Port(
	adr : in STD_LOGIC_VECTOR(4 downto 0);
	R : in STD_LOGIC;
	rw : in STD_LOGIC;
	DI : in STD_LOGIC;
	DO : out STD_LOGIC
);
end component;

signal e_rw : STD_LOGIC;
signal e_DO : STD_LOGIC_VECTOR(7 downto 0);

begin

e_rw <= rw and En;

MEM32_0: Mem32b port map (adr, R, e_rw, DI(0), e_DO(0));
MEM32_1: Mem32b port map (adr, R, e_rw, DI(1), e_DO(1));
MEM32_2: Mem32b port map (adr, R, e_rw, DI(2), e_DO(2));
MEM32_3: Mem32b port map (adr, R, e_rw, DI(3), e_DO(3));
MEM32_4: Mem32b port map (adr, R, e_rw, DI(4), e_DO(4));
MEM32_5: Mem32b port map (adr, R, e_rw, DI(5), e_DO(5));
MEM32_6: Mem32b port map (adr, R, e_rw, DI(6), e_DO(6));
MEM32_7: Mem32b port map (adr, R, e_rw, DI(7), e_DO(7));

DO(0) <= e_DO(0) and En;
DO(1) <= e_DO(1) and En;
DO(2) <= e_DO(2) and En;
DO(3) <= e_DO(3) and En;
DO(4) <= e_DO(4) and En;
DO(5) <= e_DO(5) and En;
DO(6) <= e_DO(6) and En;
DO(7) <= e_DO(7) and En;

end Behavioral;

