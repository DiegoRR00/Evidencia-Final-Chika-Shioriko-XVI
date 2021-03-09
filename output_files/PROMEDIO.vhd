--Saca el promedio de 15 datos
--Diego Reyna Reyes A01657387
--Nombre actividad
--CDMX dd/mm/aaaa

library ieee;
use ieee.std_logic_1164.all;
use ieee.Numeric_Std.all;


Entity PROMEDIO is
	Port(
		RX : in std_logic;
		CLK : in std_logic;
		R : in std_logic;
		P : out std_logic_vector(7 downto 0);
		E : out std_logic
	);
end PROMEDIO;

Architecture behavior of PROMEDIO is
	Component RXSERIAL is
		Port(
			CLK 	: in std_logic;
			R		: in std_logic;
			RX 	: in std_logic;
			D 		: out std_logic_vector (7 downto 0);
			S		: out std_logic
			);
	end component;
	Signal D	: std_logic_vector (7 downto 0);
	Signal S : std_logic;
	signal s_ant : std_logic;
	type state_type is (START, RECEIVE, SEND);
	signal estado : state_type;
Begin
	U0 : RXSERIAL port map (CLK, R, RX, D, S);
	
	process(R, S, CLK)
		variable counter : integer := 0;
		variable data : integer := 0;
		variable promedio : integer := 0;
	Begin
		if (R = '1') then
			P <= "00000000";
		elsif (rising_edge(CLK)) then
			case estado is
				when START =>
					E <= '1';
					if(S = '0' and s_ant = '1') then
						estado <= RECEIVE;
						counter := 0;
						data := 0;
					end if;
				when RECEIVE =>
					E <= '0';
					if(S = '1' and s_ant = '0') then
						data := data + to_integer(unsigned(D));
						counter := counter + 1;
						if (counter = 13) then
							estado <= SEND;
						else
							estado <= estado;
						end if;
					end if;
				when SEND =>
					E <= '1';
					estado <=START;
					promedio := data / 13;
					P <= std_logic_vector(to_unsigned(promedio,8));
				when others =>
					estado <= START;
			end case;
			s_ant <= S;
		end if;
	end process;
end behavior;