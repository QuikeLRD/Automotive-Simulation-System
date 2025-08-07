library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blind_spot_sensors is
    port (
       
        ir_left       : in  STD_LOGIC;  -- Sensor IR izquierdo (1 = detecta objeto)
        ir_right      : in  STD_LOGIC;  -- Sensor IR derecho (1 = detecta objeto)
		  car_on			 : in  STD_LOGIC;	 -- Señal de encendido de carro;
        led_sensor    : out STD_LOGIC  -- LED indicador para punto ciego izquierdo
        
    );
end blind_spot_sensors;

architecture Behavioral of blind_spot_sensors is
begin
--------------------------------------------------------------------------------    
process(ir_left, ir_right, car_on)
begin
    if car_on = '1' and (ir_left = '0' or ir_right = '0') then 
        led_sensor <= '1';
    else
        led_sensor <= '0';
    end if;
end process;

	
	     
end Behavioral;