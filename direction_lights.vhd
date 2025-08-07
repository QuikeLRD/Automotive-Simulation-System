library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity direction_lights is
    port (
        		  
		  direction_switchL :	in STD_LOGIC;	--interruptor izquierda
		  direction_switchR :	in STD_LOGIC;	--interrruptor derecha
		  left_led			  : 	out STD_LOGIC;  --led direcional izquierda
		  right_led 		  : 	out STD_LOGIC;	--led direccional derecha
		  clk1_d				  :	in STD_LOGIC  --clk1	  
		  
		  
	);		
	 	 
end direction_lights;

architecture Behavioral of direction_lights is

	  
begin	
--------------------------------------------------------------------------------------------------------------------------
	process( direction_switchL, direction_switchR)
    begin
        -- Lógica para manejar las posiciones del interruptor
        if direction_switchL = '1' and direction_switchR = '0' then
            -- Interruptor hacia la izquierda
            left_led <= clk1_d;
            right_led <= '0';
        elsif direction_switchL = '0' and direction_switchR = '1' then
            -- Interruptor hacia la derecha
            left_led  <= '0';
            right_led <= clk1_d;
        else
            -- Interruptor en posición OFF (centro)
            left_led <=  '0';
            right_led <= '0';
        end if;
		end process;
		
			
---------------------------------------------------------------------------------------------------------------------------
end behavioral;