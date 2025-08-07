library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity head_lights is
    port (
        adc_value        : in  STD_LOGIC_VECTOR (7 downto 0); -- Valor del ADC
        car_on_signal    : in  STD_LOGIC;                     -- Señal de que el auto está encendido
        headlight_switch : in  STD_LOGIC;                     -- Interruptor de los faros
        quarter_lights   : out STD_LOGIC_VECTOR (1 downto 0); -- Cuartos
        normal_lights    : out STD_LOGIC_VECTOR (1 downto 0); -- Luces normales
        high_beam        : out STD_LOGIC_VECTOR (1 downto 0); -- Luces altas
        headlight_led    : out STD_LOGIC;                     -- Alerta de faros
        buzzer_alert     : out STD_LOGIC                      -- Buzzer de alerta
    );
end head_lights;

architecture Behavioral of head_lights is
begin
    process(car_on_signal, headlight_switch, adc_value)
    begin
        if car_on_signal = '1' and headlight_switch = '1' then
            -- Control de luces según el valor del ADC
            if unsigned(adc_value) < 31 then
                -- Poca luz, activar luces altas
                quarter_lights <= "00";
                normal_lights  <= "00";
                high_beam      <= "11";
            elsif unsigned(adc_value) >= 31 and unsigned(adc_value) <= 83 then
                -- Luz ambiente, activar luces normales
                quarter_lights <= "00";
                normal_lights  <= "11";
                high_beam      <= "00";
            else
                -- Mucha luz, solo activar cuartos
                quarter_lights <= "11";
                normal_lights  <= "00";
                high_beam      <= "00";
            end if;

            -- Apagar alertas cuando el auto está encendido y los faros funcionan correctamente
            headlight_led <= '0';
            buzzer_alert  <= '1';

        else
            -- Apagar las luces cuando el auto está apagado o el interruptor está desactivado
            quarter_lights <= "00";
            normal_lights  <= "00";
            high_beam      <= "00";

            -- Activar alerta si los faros siguen encendidos pero el auto está apagado
            if headlight_switch = '1' then
                headlight_led <= '1';
                buzzer_alert  <= '0';
            else
                headlight_led <= '0';
                buzzer_alert  <= '1';
            end if;
        end if;
    end process;
end Behavioral;
