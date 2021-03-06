--Transmisor serial
--Diego Reyna Reyes A01657387
--Clase 14
--CDMX 25/02/2021

library ieee;
use ieee.std_logic_1164.all;


Entity RXSERIAL is
	Port(
		CLK 	: in std_logic;
		R		: in std_logic;
		RX 	: in std_logic;
		D 		: out std_logic_vector (7 downto 0);
		S		: out std_logic
		);
end RXSERIAL;

Architecture behavior of RXSERIAL is
	signal clk_2 : std_logic;
	type state_type is (IDLE, RECEIVE, STOP);
	signal estado : state_type;
	signal estado_anterior : std_logic;
Begin

	--Dividir frecuencia para el baud rate
	process (clk)
		variable cont : integer := 0;
	Begin
		if (rising_edge (CLK)) then
			cont := cont + 1;
			if (cont = (50000000)/(2*9600)) then
				cont := 0;
				clk_2 <= not clk_2;
			end if;
		end if;
	end process;
	
	process (clk_2,R)
		variable d_bit : integer range 0 to 8;
		variable d_copy : std_logic_vector (7 downto 0);--Copia de los datos recibidos
		
	Begin
		if (R = '1') then
			estado <= IDLE;
		elsif (rising_edge (clk_2)) then
			case estado is
				when IDLE =>
					S <= '0';
					d_bit := 0;
					if (RX = '0' and estado_anterior = '1') then	--Debido a que es asincrónico
						estado <= RECEIVE;
					else
						estado <= estado;
					end if;
					estado_anterior <= RX;
				when RECEIVE =>
					S <= '0';
					d_copy(d_bit) := RX;
					if (d_bit = 7) then		--7 bit sent
						estado <= STOP;
					else
						d_bit := d_bit + 1;
						estado <= estado;
					end if;
				when STOP =>
					if (RX = '1') then
						estado <= IDLE;
						D <= d_copy;
						S <= '1';
					else
						estado <= estado;
					end if;
					
				when others =>
					estado <= IDLE;
			end case;
		end if;
	end process;
end behavior;
