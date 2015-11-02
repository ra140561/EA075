LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Somador8b IS
PORT (	a, b:	in std_logic_vector(7 DOWNTO 0);
	cin: 	in std_logic;
	s:	out std_logic_vector(7 downto 0);
	cout: 	out std_logic);
END Somador8b;

ARCHITECTURE Somador8b_comportamento OF Somador8b IS

COMPONENT Somador1b IS
PORT (	x, y, cin: in std_logic;
			s, cout:	out std_logic);
END COMPONENT;

Signal cout1, cout2, cout3, cout4, cout5, cout6, cout7: STD_LOGIC;

BEGIN
	X1:	Somador1b PORT MAP(a(0), b(0), cin, s(0), cout1);
	X2:	Somador1b PORT MAP(a(1), b(1), cout1, s(1), cout2);
	X3:	Somador1b PORT MAP(a(2), b(2), cout2, s(2), cout3);
	X4:	Somador1b PORT MAP(a(3), b(3), cout3, s(3), cout4);
	X5:	Somador1b PORT MAP(a(4), b(4), cout4, s(4), cout5);
	X6:	Somador1b PORT MAP(a(5), b(5), cout5, s(5), cout6);
	X7:	Somador1b PORT MAP(a(6), b(6), cout6, s(6), cout7);
	X8:	Somador1b PORT MAP(a(7), b(7), cout7, s(7), cout);
END Somador8b_comportamento;