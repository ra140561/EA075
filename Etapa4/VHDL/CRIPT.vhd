LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Criptografador de caractere ASCII.

ENTITY CRIPT IS
PORT (	IN_CHAR, CRIPT_CHAR:	in std_logic_vector(7 downto 0);
	ENABLE:			in std_logic;
	OUT_CHAR:		out std_logic_vector(7 downto 0));
END CRIPT;

ARCHITECTURE CRIPTING OF CRIPT IS

SIGNAL ENABLE_8 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');

BEGIN
	ENABLE_8 <= (OTHERS => ENABLE);
	OUT_CHAR <= (IN_CHAR XOR CRIPT_CHAR) AND ENABLE_8;

END CRIPTING;