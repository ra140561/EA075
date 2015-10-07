LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Código que realiza a conexão entre as entradas das chaves e os LED’s.

ENTITY Somador1b IS
PORT (	x, y, cin: in std_logic;
			s, cout:	out std_logic);
END Somador1b;

ARCHITECTURE Somador1b_comportamento OF Somador1b IS
BEGIN
	s <= (x XOR y) XOR cin;
	cout <= ((x XOR y) AND cin) OR (x AND y);
END Somador1b_comportamento;