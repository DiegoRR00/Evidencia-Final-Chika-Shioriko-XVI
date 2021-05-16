--Descripción
--Diego Reyna Reyes A01657387
--Nombre actividad
--CDMX dd/mm/aaaa

library ieee;
use ieee.std_logic_1164.all;


Entity CONTROLLER is
	Port(
		CLK : in std_logic;
		RST : in std_logic;
		
		--SPI
		MOSI 			: out std_logic;
		MISO 			: in std_logic;
		SCLK 			: out std_logic;
		CS 			: out std_logic;
		INT1			: in std_logic;
		INTBYPASS 	: in std_logic;
		
		--Serial
		TX : out std_logic;
		
		--Prueba
		V : out std_logic_vector(7 downto 0);
		mode_test : out std_logic;
		c_test : out std_logic
	);
end CONTROLLER;

Architecture behavior of CONTROLLER is
	Component spi_master is
    port (
		clk	: in std_logic;
		rst	: in std_logic;
      mosi	: out std_logic;
		miso 	: in std_logic;
		sclk_out : out std_logic; 
		cs_out	: out std_logic;
		int1 	: in std_logic;
		int2 	: in std_logic;
		go		: in std_logic;
		pol	: in std_logic;
		pha   : in std_logic;
		bytes : in std_logic_vector (3 downto 0);
		rxData: out std_logic_vector(7 downto 0);
		txData: in  std_logic_vector(7 downto 0);
		rxDataReady: out std_logic
		);
	end component;
	
	Component accel_driver is
	port (
		rst			:		in std_logic;
		clk			:		in std_logic;
		int1			:		in std_logic;
		rxDataReady	:		in	std_logic;
		go				:		out std_logic;
		pol			:		out std_logic;
		pha			:		out std_logic;
		bytes 		:		out std_logic_vector (3 downto 0);
		txData 		:		out std_logic_vector (7 downto 0);
		rxData		: 		in std_logic_vector ( 7 downto 0);
		accel_data	:		out std_logic_vector (47 downto 0);

		m				: out std_logic;
		c				: out std_logic;
		intBypass   : in std_logic
	);
	end component;
	Component TXSERIAL is
	Port(
		CLK 	: in std_logic;
		D 		: in std_logic_vector (7 downto 0);
		E 		: in std_logic;
		R		: in std_logic;
		TX 	: out std_logic
		);
	end component;
	Component PROMEDIO is
		Port(
			RX : in std_logic;
			CLK : in std_logic;
			R : in std_logic;
			P : out std_logic_vector(7 downto 0);
			E : out std_logic
		);
	end component;
	--Signal
	signal mosi_int : std_logic;
	signal sckl_int : std_logic;
	signal sckl_spi : std_logic;
	signal cs_int : std_logic;
	signal go : std_logic;
	signal pol : std_logic;
	signal pha : std_logic;
	signal bytes : std_logic_vector (3 downto 0);
	signal rx_Data : std_logic_vector (7 downto 0);
	signal rx_Data_Ready : std_logic;
	signal tx_Data : std_logic_vector (7 downto 0);
	signal int1_int : std_logic;
	signal accel_data : std_logic_vector(47 downto 0);
	signal mode : std_logic;
	signal c_int : std_logic;
	signal enable : std_logic;
	signal clk_2 : std_logic; -- 9600 baud
	signal enable_tx : std_logic;
	signal accel2prom : std_logic;
	signal average : std_logic_vector(7 downto 0);
	signal ave_cont : std_logic;
Begin
	U0 : entity work.spi_master(FSM_1P) port map(CLK, RST, mosi_int, MISO, sckl_spi, cs_int, '0', '0', go, pol, pha, bytes, rx_Data, tx_Data, rx_Data_ready);
	U1 : entity work.accel_driver(FSM_1P) port map(RST, CLK, int1_int, rx_Data_Ready, go, pol, pha, bytes, tx_Data, rx_Data, accel_data, mode, c_int, INTBYPASS);
	U2 : TXSERIAL port map (CLK, accel_data(23 downto 16), enable_tx, RST, accel2prom);
	U3 : PROMEDIO port map (accel2prom, CLK, RST, average, ave_cont);
	
	process(CLK, RST)
	Begin
		if(RST = '1') then
			sckl_int <= '1';
			int1_int <= '0';
		elsif (CLK'event and CLK = '1') then
			sckl_int <= sckl_spi;
			int1_int <= INT1;
		end if;
	end process;
	--Envio datos a promedio
	process(clk_2)
		variable counter : integer := 0;
	Begin
		if (rising_edge(clk_2)) then
			counter := counter + 1;
			if(counter < 3) then
				enable_tx <= '1';
			elsif (counter = 12) then
				counter := 0;
				enable_tx <= '0';
			else
				enable_tx <= '0';
			end if;
		end if;
	end process;
	
	--I/O with int
	MOSI <= mosi_int;
	SCLK <= sckl_int;
	CS <= cs_int;
	mode_test <= mode;
	c_test <= c_int;
	
	process (ave_cont)
		variable counter : integer := 0;
	Begin
		if (rising_edge(ave_cont)) then
			counter := counter + 1;
			if(counter = 8) then
				enable <= '1';
				counter := 0;
			else
				enable <= '0';
			end if;
		end if;
	end process;
	
	U4 : TXSERIAL port map(CLK, average, enable, RST, TX);
	
	--Make 9600 baud clk
	process (CLK)
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
	
	V <= accel_data(23 downto 16);
end behavior;
