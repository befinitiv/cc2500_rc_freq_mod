library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;





entity spi_mod is
	port(
		CSN : in std_logic;
		SCK : in std_logic;
		DIN : in std_logic;
		DOUT : out std_logic;
		DEBUG : out std_logic
);
end spi_mod;

architecture Behavioral of spi_mod is


signal overwrite_enable_fe, overwrite_enable_re : std_logic;
signal overwrite_value : std_logic;

signal sr : std_logic_vector(8-1 downto 0);
signal sr_cnt : integer range 0 to 15;


begin
    

DEBUG <= overwrite_enable_re;


overwrite_value <= '0';
DOUT <= overwrite_value when overwrite_enable_fe = '1' else DIN;




edge_trans : process(SCK)
begin
	if falling_edge(SCK) then
		overwrite_enable_fe <= overwrite_enable_re;
	end if;
end process;



detect_channel_write : process(SCK, CSN)
begin
	if CSN = '1' then
		overwrite_enable_re <= '0';
		sr_cnt <= 0;
	else
		if rising_edge(SCK) then
			sr(0) <= DIN;
			for i in 1 to 7 loop
				sr(i) <= sr(i-1);
			end loop;
			

			overwrite_enable_re <= '0';
			if sr_cnt = 7 and sr(6 downto 0) = x"05" and DIN = '0' then
				overwrite_enable_re <= '1';
			end if;

			if sr_cnt = 15 then
				sr_cnt <= 0;
			else
				sr_cnt <= sr_cnt + 1;
			end if;
			
		end if;
	end if;
end process;




end Behavioral;
