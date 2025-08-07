library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ignition is
    port (
        clk           : in  STD_LOGIC;      -- Reloj
        reset         : in  STD_LOGIC;      -- Reset del sistema
        start_button  : in  STD_LOGIC;      -- interruptor de encendido/apagado
        seatbelt      : in  STD_LOGIC;      -- Estado del cinturón (1 = abrochado)
        ignition_on   : out STD_LOGIC;      -- Salida que indica que el led está encendido
        buzzer        : out STD_LOGIC;      -- Buzzer para alerta de cinturón
        led_red       : out STD_LOGIC;      -- LED rojo para alerta de cinturón
		  clk1			 : out STD_LOGIC;   	  --Salida de clk1
		  car_on			 : out STD_LOGIC --Salida general de encendido
		  
	);		
	 	 
end ignition;

architecture Behavioral of ignition is

	 signal cont3s : integer range 0 to 4 := 0;
	 signal bandera: STD_LOGIC := '0';
	 
	 
	 signal sec_counter  : INTEGER range 0 to 3 := 0;        -- Contador de 3 segundos
    signal buzzer_state : STD_LOGIC := '0';                 -- Estado del buzzer
	 signal activar     : std_logic := '1';        -- Control de activación del buzzer
    signal active 	   : STD_LOGIC := '0';
	 
	 
	--señales divisor de frecuencia	
	 SIGNAL counter : INTEGER range 0 to 99000000:= 0;           --COUNTER FOR SIGNAL NEW CLK
    SIGNAL pulse   : STD_LOGIC:= '0';
	 SIGNAL clk2 	 : STD_LOGIC;
	 	 
begin	
--------------------------------------------------------------------------------
     PROCESS(clk)
     BEGIN
       IF(rising_edge(clk)) THEN
            IF(counter = 25_000_000) THEN                         --TIME = 1 SEG
                pulse   <= NOT(pulse);
                counter <= 0;
            ELSE
                counter <= counter + 1;    
            END IF;
       END IF;
        clk1 <= pulse;
		  Clk2 <= pulse;
		  end process;
----------------------------------------------------------------------------------------------------------------- Control del buzzer con `activar`
    process(clk2, reset)
    begin
        if reset = '0' then
            sec_counter <= 0;
            buzzer_state <= '0';
            activar <= '1';
        elsif rising_edge(clk2) then
            if start_button = '1' and activar = '1' then
                -- Inicia el contador de 3 segundos
                sec_counter <= 0;
                buzzer_state <= '1';
                activar <= '0'; -- Deshabilitar el buzzer hasta reinicio del botón
            elsif sec_counter < 3 then
                sec_counter <= sec_counter + 1;
            else
                buzzer_state <= '0';
            end if;

            -- Rehabilitar `activar` cuando el botón se suelta
            if start_button = '0' then
                activar <= '1';
            end if;
        end if;
    end process;

    -- Salida del buzzer
    --------------------------------------------------------------------------------------------------

process (start_button)
begin

	if start_button = '1' then
		ignition_on  <= '1';
		car_on <= '1';
		buzzer <= buzzer_state;
---------------------------------------------------------------------------------------------------		  
		if seatbelt = '0' then
			
				led_red <= clk2;
			
		else 
			
				led_red <= '0';
		end if;
			
	else
		ignition_on  <= '0';
		led_red 		 <= '0';
		car_on  		 <= '0';
		buzzer <= '0';
		 
	end if;
	
	
end process;
end behavioral;	