library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
Port(
	clk, reset, start : in STD_LOGIC;
	inst : in STD_LOGIC_VECTOR(7 downto 0);
	ZF, NF, OVF : in STD_LOGIC;

	dataOut_S : out STD_LOGIC_VECTOR(2 downto 0);
	address_S : out STD_LOGIC_VECTOR(1 downto 0);
	opc : out STD_LOGIC_VECTOR(2 downto 0);
	
	ADR_S : out STD_LOGIC_VECTOR(1 downto 0);
	RA_S : out STD_LOGIC_VECTOR(1 downto 0);
	RB_S : out STD_LOGIC;
	RC_S : out STD_LOGIC;
	ALU_A_S : out STD_LOGIC;
	ALU_B_S : out STD_LOGIC_VECTOR(1 downto 0);
	IC_S : out STD_LOGIC_VECTOR(1 downto 0);
	ADR_En,
	RA_En,
	RB_En,
	RC_En,
	IC_En,
	IDR_En,
	IR_En,
	PACR_En,
	IACR_En,
	RW : out STD_LOGIC;
	
	fetch : out STD_LOGIC;
	
	state_0,
	state_1,
	state_2,
	state_3,
	state_4,
	state_5,
	state_6 : out STD_LOGIC
);
end ControlUnit;

architecture Behavioral of ControlUnit is

-- components

component SevenState_sm is
port(
	clk : in STD_LOGIC;
	reset : in STD_LOGIC;
	start : in STD_LOGIC;
	
	S0, S1, S2, S3, S4, S5, S6 : out STD_LOGIC
);
end component;

component InstDecoder is
Port(
	inst : in STD_LOGIC_VECTOR(7 downto 0);
	
	add_RA_RB,
	add_RA_RC,
	add_RA_X,
	sub_RA_RB,
	sub_RA_RC,
	sub_RA_X,
	inc_RA,
	dec_RA,
	neg_RA,
	not_RA,
	and_RA_RB,
	and_RA_RC,
	or_RA_RB,
	or_RA_RC,	
	
	lod_X_RA,
	lod_X_RB,
	lod_X_RC,
	lod_X_ADR,
	
	str_X_mADR,
	lod_adr_ADR,
	
	lod_mADR_RA,
	str_RA_mADR,
	lod_mADR_RB,
	str_RB_mADR,
	lod_mADR_RC,
	str_RC_mADR,
	
	lod_ACR_RA,
	lod_ACR_ADR,
	str_ACR_mADR,
	
	str_IC_mADR,

	jmp_ADR,
	jmp_x,
	jmpz_x,
	jmpn_x,
	jmpo_x,
	hlt
	: out STD_LOGIC
);
end component;

component OpDecoder is
Port(
	En : in STD_LOGIC;
	ZF, NF, OVF : in STD_LOGIC;

	add_RA_RB,
	add_RA_RC,
	add_RA_X,
	sub_RA_RB,
	sub_RA_RC,
	sub_RA_X,
	inc_RA,
	dec_RA,
	neg_RA,
	not_RA,
	and_RA_RB,
	and_RA_RC,
	or_RA_RB,
	or_RA_RC,	
	
	lod_X_RA,
	lod_X_RB,
	lod_X_RC,
	lod_X_ADR,
	
	str_X_mADR,
	lod_adr_ADR,
	
	lod_mADR_RA,
	str_RA_mADR,
	lod_mADR_RB,
	str_RB_mADR,
	lod_mADR_RC,
	str_RC_mADR,
	
	lod_ACR_RA,
	lod_ACR_ADR,
	str_ACR_mADR,
	
	str_IC_mADR,

	jmp_ADR,
	jmp_x,
	jmpz_x,
	jmpn_x,
	jmpo_x : in STD_LOGIC;
	
	dataOut_S : out STD_LOGIC_VECTOR(2 downto 0);
	address_S : out STD_LOGIC_VECTOR(1 downto 0);
	opc : out STD_LOGIC_VECTOR(2 downto 0);
	
	ADR_S : out STD_LOGIC_VECTOR(1 downto 0);
	RA_S : out STD_LOGIC_VECTOR(1 downto 0);
	RB_S : out STD_LOGIC;
	RC_S : out STD_LOGIC;
	ALU_A_S : out STD_LOGIC;
	ALU_B_S : out STD_LOGIC_VECTOR(1 downto 0);
	IC_S : out STD_LOGIC_VECTOR(1 downto 0);
	ADR_En,
	RA_En,
	RB_En,
	RC_En,
	IC_En,
	IDR_En,
	IR_En,
	ACR_En,
	RW : out STD_LOGIC
);
end component;

-- signals

signal
add_RA_RB,
add_RA_RC,
add_RA_X,
sub_RA_RB,
sub_RA_RC,
sub_RA_X,
inc_RA,
dec_RA,
neg_RA,
not_RA,
and_RA_RB,
and_RA_RC,
or_RA_RB,
or_RA_RC,	
lod_X_RA,
lod_X_RB,
lod_X_RC,
lod_X_ADR,
str_X_mADR,
lod_adr_ADR,
lod_mADR_RA,
str_RA_mADR,
lod_mADR_RB,
str_RB_mADR,
lod_mADR_RC,
str_RC_mADR,
lod_ACR_RA,
lod_ACR_ADR,
str_ACR_mADR,
str_IC_mADR,
jmp_ADR,
jmp_x,
jmpz_x,
jmpn_x,
jmpo_x,
hlt : STD_LOGIC;

signal dataOut_S_aux : STD_LOGIC_VECTOR(2 downto 0);
signal address_S_aux : STD_LOGIC_VECTOR(1 downto 0);
signal opc_aux : STD_LOGIC_VECTOR(2 downto 0);
signal ADR_S_aux : STD_LOGIC_VECTOR(1 downto 0);
signal RA_S_aux : STD_LOGIC_VECTOR(1 downto 0);
signal RB_S_aux : STD_LOGIC;
signal RC_S_aux : STD_LOGIC;
signal ALU_A_S_aux : STD_LOGIC;
signal ALU_B_S_aux : STD_LOGIC_VECTOR(1 downto 0);
signal IC_S_aux : STD_LOGIC_VECTOR(1 downto 0);
signal
ADR_En_aux,
RA_En_aux,
RB_En_aux,
RC_En_aux,
IC_En_aux,
IDR_En_aux,
IR_En_aux,
PACR_En_aux,
IACR_En_aux,
RW_aux : STD_LOGIC;

signal
fetchInst,
S1,
S2,
fetchData,
decode,
S5,
S6 : STD_LOGIC;

signal 
incIC,
saveIC : STD_LOGIC;

signal
IC_En_active,
IDR_En_active,
IR_En_active : STD_LOGIC;

signal sm_clk : STD_LOGIC;

begin

fetch <= fetchInst or fetchData;

sm_clk <= clk and (not hlt);

-- Seven State State Machine
SSSM: SevenState_sm port map(
	sm_clk,
	reset,
	start,
	
	fetchInst,
	S1,
	S2,
	fetchData,
	decode,
	S5,
	S6
);

-- Instruction Decoder
ID: InstDecoder port map(
	inst,
	
	add_RA_RB,
	add_RA_RC,
	add_RA_X,
	sub_RA_RB,
	sub_RA_RC,
	sub_RA_X,
	inc_RA,
	dec_RA,
	neg_RA,
	not_RA,
	and_RA_RB,
	and_RA_RC,
	or_RA_RB,
	or_RA_RC,	

	lod_X_RA,
	lod_X_RB,
	lod_X_RC,
	lod_X_ADR,

	str_X_mADR,
	lod_adr_ADR,

	lod_mADR_RA,
	str_RA_mADR,
	lod_mADR_RB,
	str_RB_mADR,
	lod_mADR_RC,
	str_RC_mADR,

	lod_ACR_RA,
	lod_ACR_ADR,
	str_ACR_mADR,
	
	str_IC_mADR,

	jmp_ADR,
	jmp_x,
	jmpz_x,
	jmpn_x,
	jmpo_x,
	hlt
);

-- Operation Decoder
OD: OpDecoder port map(
	
	decode,
	ZF,
	NF,
	OVF,
	
	add_RA_RB,
	add_RA_RC,
	add_RA_X,
	sub_RA_RB,
	sub_RA_RC,
	sub_RA_X,
	inc_RA,
	dec_RA,
	neg_RA,
	not_RA,
	and_RA_RB,
	and_RA_RC,
	or_RA_RB,
	or_RA_RC,	

	lod_X_RA,
	lod_X_RB,
	lod_X_RC,
	lod_X_ADR,

	str_X_mADR,
	lod_adr_ADR,

	lod_mADR_RA,
	str_RA_mADR,
	lod_mADR_RB,
	str_RB_mADR,
	lod_mADR_RC,
	str_RC_mADR,

	lod_ACR_RA,
	lod_ACR_ADR,
	str_ACR_mADR,
	
	str_IC_mADR,

	jmp_ADR,
	jmp_x,
	jmpz_x,
	jmpn_x,
	jmpo_x,
	
	dataOut_S_aux,
	address_S_aux,
	opc_aux,
	ADR_S_aux,
	RA_S_aux,
	RB_S_aux,
	RC_S_aux,
	ALU_A_S_aux,
	ALU_B_S_aux,
	IC_S_aux,
	ADR_En_aux,
	RA_En_aux,
	RB_En_aux,
	RC_En_aux,
	IC_En_aux,
	IDR_En_aux,
	IR_En_aux,
	PACR_En_aux,
	RW_aux
);

-- states
incIC <= S1 or S5;
saveIC <= S2 or S6;

-- actives
IC_En_active <= IC_En_aux or saveIC;
IDR_En_active <= IDR_En_aux or fetchData;
IR_En_active <= IR_En_aux or fetchInst;

-- outputs
dataOut_S <= dataOut_S_aux;

opc(0) <= opc_aux(0);
opc(1) <= opc_aux(1) or incIC;
opc(2) <= opc_aux(2);

address_S <= address_S_aux;
RA_S <= RA_S_aux;
ADR_S <= ADR_S_aux;
RB_S <= RB_S_aux;
RC_S <= RC_S_aux;
ALU_A_S <= ALU_A_S_aux or incIC;
ALU_B_S <= ALU_B_S_aux;
IC_S <= IC_S_aux;
ADR_En <= ADR_En_aux and (not clk);
RA_En <= RA_En_aux and (not clk);
RB_En <= RB_En_aux and (not clk);
RC_En <= RC_En_aux and (not clk);
IC_En <= IC_En_active and (not clk);
IDR_En <= IDR_En_active and (not clk);
IR_En <= IR_En_active and (not clk);
PACR_En <= PACR_En_aux and (not clk);
IACR_En <= incIC and (not clk);
RW <= RW_aux and (not clk);

state_0 <= fetchInst;
state_1 <= S1;
state_2 <= S2;
state_3 <= fetchData;
state_4 <= decode;
state_5 <= S5;
state_6 <= S6;

end Behavioral;

