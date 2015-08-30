library ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
--USE ieee.std_logic_arith.ALL;

entity spi_mod_tb is
end spi_mod_tb;

architecture Behavioral of spi_mod_tb is

component spi_mod
	port(
		CSN : in std_logic;
		SCK : in std_logic;
		DIN : in std_logic;
		DOUT : out std_logic;
		DEBUG : out std_logic
	);
end component;


	signal sm_csn : std_logic;
	signal sm_sck : std_logic;
	signal sm_din : std_logic;
	signal sm_dout : std_logic;


	procedure send_byte(constant b : in std_logic_vector(7 downto 0); signal sck, d : out std_logic) is
	begin
		for i in 7 downto 0 loop
			sck <= '0';
			d <= b(i);
			wait for 1 us;
			sck <= '1';
			wait for 1 us;
		end loop;

		sck <= '0';
	end procedure;

begin



uut : spi_mod
port map(
	CSN		=> sm_csn,
	SCK		=> sm_sck,
	DIN		=> sm_din,
	DOUT	=> sm_dout
);

	
	stim_process : process
	begin
		sm_csn <= '1';
		sm_sck <= '0';
		sm_din <= '0';

		wait for 10 us;
		sm_csn <= '0';
		wait for 1 us;
		
		--this sequence is a write to another register with the value 0xa.
		--this is to see if the circuit ignores this write.
		send_byte(x"CA", sm_sck, sm_din);
		wait for 5 us;
		send_byte(x"0A", sm_sck, sm_din);
		wait for 5 us;

		send_byte(x"0A", sm_sck, sm_din);
		wait for 5 us;
		send_byte("11110111", sm_sck, sm_din);
	
		send_byte(x"7F", sm_sck, sm_din);
		wait for 5 us;
		send_byte(x"12", sm_sck, sm_din);
		wait for 5 us;
		send_byte(x"0A", sm_sck, sm_din);		
		wait for 5 us;
		send_byte(x"76", sm_sck, sm_din);

		wait for 10 us;
		sm_csn <= '1';

	end process;


end Behavioral;

