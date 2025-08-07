library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hazard_lights is
    port (
        clk        	 : in  STD_LOGIC;  -- Reloj principal
        reset      	 : in  STD_LOGIC;  -- Señal de reinicio 
		  flash_button  : in  STD_LOGIC;	 --Interruptor de luces intermitentes
		  hazard_left   : out STD_LOGIC;  --Luz intermitente izquierda
		  hazard_right  : out STD_LOGIC;  --Luz intermitente derecha
		  clk1          : in  STD_LOGIC	 --Reloj dividido 
		  
		  
		  );
		  
end hazard_lights;

architecture Behavioral of hazard_lights is
    
    signal button_stable  : STD_LOGIC := '0'; -- Botón después de antirrebotes
    signal led_state      : STD_LOGIC := '0'; -- Estado del LED
    signal debounce_count : INTEGER range 0 to 1000000 := 0; -- Contador para antirrebotes
    constant debounce_limit : INTEGER := 500000; -- Límite para filtrar rebotes
begin
    -- ====================================================================
    -- Proceso de antirrebotes
    -- ====================================================================
    
	 process(clk, reset)
    begin
        if reset = '0' then
            button_stable <= '0';
            debounce_count <= 0;
        elsif rising_edge(clk) then
            if flash_button = button_stable then
                debounce_count <= 0; -- Si no hay cambios, reiniciar el contador
            else
                debounce_count <= debounce_count + 1;
                if debounce_count >= debounce_limit then
                    button_stable <= flash_button; -- Actualizar el estado estable
                    debounce_count <= 0;
                end if;
            end if;
        end if;
    end process;

    -- ====================================================================
    -- Proceso para alternar el LED
    -- ====================================================================
    process(flash_button)
	 begin
		if flash_button <= '0' then
	 	 
		hazard_left  <= clk1;
		hazard_right <= clk1;
	  
		else
			hazard_left  <= '0';
			hazard_right <= '0';
		end if;
	 end process;
	 ------------------------------------------------------------------------
	 end Behavioral;