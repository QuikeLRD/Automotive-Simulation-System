library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Sensor_DHT11 is
    port (
        clk       : in  std_logic;       -- Reloj del sistema
        data_in   : in  std_logic;       -- Señal del sensor
        humidity  : out std_logic_vector(7 downto 0); -- Salida del valor de humedad
		  rh_2   	: in  std_logic_vector(7 downto 0) --valor de humedad
    );
end entity Sensor_DHT11;

architecture Behavioral of Sensor_DHT11 is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Lógica para leer el sensor usando la librería proporcionada
            humidity <= rh2(data_in); 
        end if;
    end process;
end architecture Behavioral;
