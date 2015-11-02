LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Parte3 IS
PORT(	IN_KEYBOARD:	IN STD_LOGIC_VECTOR(16 DOWNTO 0);
	OUT_ASCII:	OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END Parte3;

ARCHITECTURE Parte3_Behavior OF Parte3 IS

	COMPONENT Somador8b IS
	PORT (	a, b:	in std_logic_vector(7 DOWNTO 0);
		cin: 	in std_logic;
		s:	out std_logic_vector(7 downto 0);
		cout: 	out std_logic);
	END COMPONENT;

	COMPONENT Decode IS
	PORT (	IN_KEYBOARD:	in std_logic_vector(16 downto 0);
		OUT_KEY:	out std_logic_vector(7 downto 0));
	END COMPONENT;

	SIGNAL A: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SPACE: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL IS_SPACE: STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
	SIGNAL OUT_KEY0, OUT_KEY1: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL FIM: STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '1');

	SIGNAL 	C_OUT0, C_OUT1: STD_LOGIC := '0';

BEGIN

	A <= "01000001"; --registrador do valor do caractere 'A' em ASCII
	SPACE <= "00100000"; --registrador do valor do caractere ' ' (space) em ASCII

	DEC: DECODE PORT MAP(IN_KEYBOARD, OUT_KEY0);

	ADD_Q: SOMADOR8B PORT MAP(OUT_KEY0, A, '0', OUT_KEY1, C_OUT1);

	IS_SPACE <= (OTHERS => ((NOT IN_KEYBOARD(16)) AND IN_KEYBOARD(10)));
	
	PROCESS (IN_KEYBOARD)
	BEGIN

		IF(((NOT IN_KEYBOARD(16)) AND IN_KEYBOARD(15)) = '1') THEN --SE A TECLA "FIM" FOI PRESSIONADA
			FIM <= (OTHERS => '0');				--NADA SERA IMPRESSO
		END IF;

		IF(((NOT IN_KEYBOARD(16)) AND IN_KEYBOARD(14)) = '1') THEN--A TECLA 14 SERA A A TECLA RESET
			FIM <= (OTHERS => '1');	
		END IF;

	END PROCESS;

	OUT_ASCII <= (((NOT IS_SPACE) AND OUT_KEY1) OR (IS_SPACE AND SPACE)) AND FIM;--CONDICOES PARA IMPRESSAO

end Parte3_Behavior;
