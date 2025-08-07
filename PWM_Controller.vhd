library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PWM_Controller is
    port (
        clk       : in  std_logic;          -- Reloj del sistema
		  pwm_speed : in  std_logic_vector(7 downto 0); -- Velocidad del PWM
        pwm_out   : out std_logic           -- Salida PWM para el servo
    );
end entity PWM_Controller;

architecture Behavioral of PWM_Controller is
    signal counter : unsigned(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if counter < unsigned(pwm_speed) then
                pwm_out <= '1';
            else
                pwm_out <= '0';
            end if;
            counter <= counter + 1;
        end if;
    end process;
end architecture Behavioral;