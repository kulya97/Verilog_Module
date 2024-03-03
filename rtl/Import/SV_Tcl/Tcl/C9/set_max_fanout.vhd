--File: set_max_fanout.vhd
signal dv : std_logic;
signal validForEgressFifo: std_logic_vector(7 downto 0);
attribute MAX_FANOUT : integer;
attribute MAX_FANOUT of dv : signal is 5;
attribute MAX_FANOUT of validForEgressFifo : signal is 5;
