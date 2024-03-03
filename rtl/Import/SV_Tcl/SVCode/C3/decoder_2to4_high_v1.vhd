--File: decoder_2to4_high_v1.vhd
library ieee;
use ieee.std_logic_1164.all;

entity decoder_2to4_high_v1
  port (
    a  : in std_logic_vector(1 downto 0);
    en : in std_logic;
    y  : out std_logic_vector(3 downto 0)
  );
end entity;

architecture rtl of decoder_2to4_high_v1 is
begin
  y <= (others => '0') when not en else
       with a select
           y <= "0001" when "00",
                "0010" when "01",
                "0100" when "10",
                "1000" when "11",
                "0000" when others;
end architecture;
