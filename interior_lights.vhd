library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity interior_lights is
    port (
           
	 
		  door_pilot    : in  STD_LOGIC;  -- Señal que indica si la puerta del piloto está abierta
        door_copilot  : in  STD_LOGIC;  -- Señal que indica si la puerta del copiloto está abierta
        door_trunk    : in  STD_LOGIC;  -- Señal que indica si la cajuela está abierta
        ldr_door      : in  STD_LOGIC;  -- Señal del sensor de luz para la cabina
        lights_cabin  : out STD_LOGIC_vector(1 downto 0);  -- Estado de las luces interiores (1 = encendidas)
        lights_trunk  : out STD_LOGIC   -- Estado de las luces de la cajuela (1 = encendidas)
		  
		  );
end interior_lights;
architecture Behavioral of interior_lights is
begin		  
-- ====================================================================
-- Lógica combinacional para encender las luces de la cabina
 -- ====================================================================
    process(door_pilot, door_copilot, ldr_door)
    begin
        if ldr_door = '1' and (door_pilot = '0' or door_copilot = '0') then
            lights_cabin <= "11"; -- Enciende las luces de la cabina
        else
            lights_cabin <= "00"; -- Apaga las luces de la cabina
        end if;
    end process;

    -- ====================================================================
    -- Lógica combinacional para encender las luces de la cajuela
    -- ====================================================================
    process(door_trunk, ldr_door)
    begin
        if ldr_door ='1' and door_trunk  = '1' then
            lights_trunk <= '1'; -- Enciende las luces de la cajuela
        else
            lights_trunk <= '0'; -- Apaga las luces de la cajuela
        end if;
    end process;
	 end behavioral;

---------------------------------------------------------------------------------------------