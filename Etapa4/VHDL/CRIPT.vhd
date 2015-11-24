LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Criptografador de caractere ASCII.

ENTITY CRIPT IS
PORT (	IN_CHAR, CRIPT_CHAR:	in std_logic_vector(7 downto 0);
	OUT_CHAR:		out std_logic_vector(7 downto 0));
END CRIPT;

ARCHITECTURE CRIPTING OF CRIPT IS

BEGIN
	OUT_CHAR <= IN_CHAR XOR CRIPT_CHAR;

END CRIPTING;