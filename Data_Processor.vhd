library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Processor is
    port (
        humidity      : in  std_logic_vector(7 downto 0); -- Entrada del valor de humedad
        pwm_speed     : out std_logic_vector(7 downto 0) -- Salida de velocidad del PWM
    );
end entity Data_Processor;

architecture Behavioral of Data_Processor is
begin
    process(humidity)
    begin
        -- Determina la velocidad del PWM según el valor de humedad
        if unsigned(humidity) < 50 then
            pwm_speed <= "00010100"; -- Velocidad baja (20)
        elsif unsigned(humidity) < 80 then
            pwm_speed <= "01000000"; -- Velocidad media (64)
        else
            pwm_speed <= "10000000"; -- Velocidad alta (128)
        end if;
    end process;
end architecture Behavioral;
