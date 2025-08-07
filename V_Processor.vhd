library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity V_Processor is
port(
		  clk              : in  std_logic; -- Reloj principal
        reset            : in  std_logic; -- Reset global
        start_button     : in  std_logic; -- Botón de encendido
        seatbelt         : in  std_logic; -- Señal del cinturón
        buzzer           : out std_logic; -- Buzer de alarma
        ignition_on      : out std_logic; -- LED de ignición 
        led_red          : out STD_LOGIC;  -- LED de alerta
		  
		  
		  door_pilot       : in  std_logic; -- Puerta piloto
        door_copilot     : in  std_logic; -- Puerta copiloto
        door_trunk       : in  std_logic; -- Cajuela
        ldr_door         : in  std_logic; -- LDR para las puertas
        cabin_lights     : out std_logic_vector (1 downto 0); -- Luces de la cabina
        trunk_lights     : out std_logic; -- Luces de la cajuela
		  
		  flash_button  	 : in  STD_LOGIC;		--Interruptor de luces intermitentes
		  hazard_left   	 : out STD_LOGIC;    --Luz intermitente izquierda
		  hazard_right     : out STD_LOGIC;   --Luz intermitente derecha
		   	  
				  
		  ir_left          : in  std_logic; -- Sensor IR izquierdo
        ir_right         : in  std_logic; -- Sensor IR derecho           
        led_sensor_blind : out STD_LOGIC; -- LED DE ALERTA SENSOR TRASERO
		

		  left_led			 : out std_logic;		--led direccional izquierda
		  right_led		    :	out std_logic;		--led direccional derecha
		  direction_switchL : in std_logic;     --switch de dirección L 		  
		  direction_switchR : in std_logic;     --switch de dirección R
		
		  headlight_switch : in  STD_LOGIC;  -- Interruptor de los faros
		  adc_value			 : in  STD_LOGIC_VECTOR (7 downto 0);	--Valor del adc
        quarter_lights   : out STD_LOGIC_VECTOR (1 downto 0);  -- Cuartos 
        normal_lights    : out STD_LOGIC_VECTOR (1 downto 0);  -- Luces normales
        high_beam        : out STD_LOGIC_VECTOR (1 downto 0);  -- Luces altas
        headlight_led    : out STD_LOGIC; -- Alerta de faros
        buzzer_alert     : out STD_LOGIC; -- buzer de alerta
		  
		  data	   		 : inout  std_logic;			--Entrada del sensor de humedad
		  pwm_out			 : out    std_logic;			--Salida pwm para el control del servo
		  enable_humity	 : in	 	 std_logic;			--Inicia el proceso de adquisición al ponerse en 1
		  error_humity		 : out 	 std_logic;			--bit que indica si hubo un error al leer la humedad
		  fin					 : out 	 std_logic			--bit que indica el fin de la adquisición
	
        		  
);

end V_Processor;

architecture Behavioral of V_Processor is

component ignition    
port(
        clk           : in  STD_LOGIC;   -- Reloj
        reset         : in  STD_LOGIC;   -- Reset del sistema
        start_button  : in  STD_LOGIC;   -- interruptor de encendido/apagado
        seatbelt      : in  STD_LOGIC;   -- Estado del cinturón (1 = abrochado)
        ignition_on   : out STD_LOGIC;   -- Salida que indica que el led está encendido
        buzzer        : out STD_LOGIC;   -- Buzzer para alerta de cinturón
        led_red       : out STD_LOGIC;   -- LED rojo para alerta de cinturón
		  car_on        : out STD_LOGIC;   --Salida de encendido
		  clk1			 : out STD_LOGIC
    );
end component;

component interior_lights
port(
        door_pilot    : in  STD_LOGIC;  -- Señal que indica si la puerta del piloto está abierta
        door_copilot  : in  STD_LOGIC;  -- Señal que indica si la puerta del copiloto está abierta
        door_trunk    : in  STD_LOGIC;  -- Señal que indica si la cajuela está abierta
        ldr_door      : in  STD_LOGIC;  -- Señal del sensor de luz para la cabina
        lights_cabin  : out STD_LOGIC_vector (1 downto 0);  -- Estado de las luces interiores (1 = encendidas)
        lights_trunk  : out STD_LOGIC   -- Estado de las luces de la cajuela (1 = encendidas)
		  
    );
end component;

component hazard_lights

port(
		  clk				 : in  STD_LOGIC;	 	--reloj
		  reset         : in  STD_LOGIC;		--reset del sistema
		  flash_button  : in  STD_LOGIC;		--Interruptor de luces intermitentes
		  hazard_left   : out STD_LOGIC;    --Luz intermitente izquierda
		  hazard_right  : out STD_LOGIC;    --Luz intermitente derecha
		  clk1         : in  STD_LOGIC     --reloj dividido
		  
);
end component;

component blind_spot_sensors
port(
        
        ir_left       : in  STD_LOGIC;  -- Sensor IR izquierdo (1 = detecta objeto)
        ir_right      : in  STD_LOGIC;  -- Sensor IR derecho (1 = detecta objeto)
        led_sensor    : out STD_LOGIC;  -- LED indicador para punto ciego izquierdo
		  car_on			 : in  STD_LOGIC -- Señal de encendido  
    );
end component;   



component direction_lights
port(
		  direction_switchL :	in STD_LOGIC;	--interruptor izquierda
		  direction_switchR :	in STD_LOGIC;	--interrruptor derecha
		  left_led			  : 	out STD_LOGIC;  --led direcional izquierda
		  right_led 		  : 	out STD_LOGIC;	--led direccional derecha
		  clk1_d				  :	in STD_LOGIC  --clk1	
);
end component;


component head_lights
port (
	 
		  
		  adc_value        : in  STD_LOGIC_VECTOR (7 downto 0); 	--Valor del ADC
		  car_on_signal	 : in  STD_LOGIC;   							--Señal de que el auto esta encendido
        headlight_switch : in  STD_LOGIC;  							-- Interruptor de los faros
        quarter_lights   : out STD_LOGIC_VECTOR (1 downto 0);  -- Cuartos 
        normal_lights    : out STD_LOGIC_VECTOR (1 downto 0);  -- Luces normales
        high_beam        : out STD_LOGIC_VECTOR (1 downto 0);  -- Luces altas
        headlight_led    : out STD_LOGIC; -- Alerta de faros
        buzzer_alert     : out STD_LOGIC -- buzer de alerta
	);

end component;

component  Data_Processor
port(
		  humidity      : in  std_logic_vector(7 downto 0); -- Entrada del valor de humedad
        pwm_speed     : out std_logic_vector(7 downto 0) -- Salida de velocidad del PWM

	);
end component;

component PWM_Controller
port(
		  clk       : in  std_logic;          -- Reloj del sistema
        pwm_speed : in  std_logic_vector(7 downto 0); -- Velocidad del PWM
        pwm_out   : out std_logic           -- Salida PWM
	);
end component;	
	
	
	
component  LIBRERIA_DHT11_REVA
port(
		CLK 	 : IN  	STD_LOGIC;							-- Reloj del FPGA.
	   RESET  : IN  	STD_LOGIC;							-- Resetea el proceso de adquisición, el reset es asíncrono y activo en alto.
	   ENABLE : IN 	STD_LOGIC;							-- Habilitador, inicia el proceso de adquisición cuando se pone a '1'.
	   DATA 	 : INOUT STD_LOGIC;							-- Puerto bidireccional de datos.
	   ERROR  : OUT 	STD_LOGIC;							-- Bit que indica si hubo algún error al verificar el Checksum.
	   RH 	 : OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- Valor de la humedad relativa.
	   TEMP 	 : OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0); -- Valor de la temperatura.
	   FIN 	 : OUT 	STD_LOGIC							-- Bit que indica fin de adquisición.

	);	
end component;	
	
--  Señales internas
    
	 signal clk1_G					: std_logic; -- reloj dividido
	 signal car_on_G        	: std_logic; -- Encendido del carro
	 
	 
    signal pwm_speed_signal 	: std_logic_vector(7 downto 0);
	 
	 signal rh						: std_logic_vector(7 downto 0);
	 signal temp				   : std_logic_vector(7 downto 0);
	    
begin

-- ====================================================================
    -- Instanciar el módulo de encendido (ignition)
    -- ====================================================================
 ignition_inst: ignition
        port map (
            clk           => clk,
            reset         => reset,
            start_button  => start_button,
            seatbelt      => seatbelt,
            ignition_on   => ignition_on,
            led_red       => led_red, 
				buzzer        => buzzer,
				clk1          => clk1_G,
				car_on        => car_on_G
            
        );
		
 -- ====================================================================
    -- Instanciar el módulo de luces interiores (interior_lights)
    -- ====================================================================
    interior_lights_inst: interior_lights
        port map (
            door_pilot    => door_pilot,
            door_copilot  => door_copilot,
            door_trunk    => door_trunk,
            ldr_door      => ldr_door,
            lights_cabin  => cabin_lights,
            lights_trunk  => trunk_lights
        );
		  
-- ====================================================================
-- Instanciar el módulo de luces intermitentes (hazard_lights)
-- ====================================================================
    hazar_lights_inst: hazard_lights
    
         port map (
            clk             => clk,
            reset           => reset,
            flash_button    => flash_button,
            hazard_left     => hazard_left,
            hazard_right    => hazard_right,
				clk1           => clk1_G
        );
 -- ====================================================================
 -- Instanciar el módulo de punto ciego (blindspot_sensors)
 -- ====================================================================
    blindspot_sensors_inst: blind_spot_sensors
        port map (
           
            ir_left       => ir_left,
            ir_right      => ir_right,
				car_on        => car_on_G,
            led_sensor    => led_sensor_blind
        );
		  
-- ====================================================================
-- Instanciar el módulo de luces de dirección
-- ====================================================================
    direction_lights_inst: direction_lights
        port map (
       
        direction_switchL => direction_switchL,
		  direction_switchR => direction_switchR,
        
        left_led          => left_led,
        right_led         => right_led,     
		  clk1_d				  => clk1_G	
		  );  
		  
	-- ====================================================================
   -- Instanciar el módulo de faros(headlights)
   -- ====================================================================
    head_lights_inst: head_lights
        port map (
           
            car_on_signal    => car_on_G,
            headlight_switch => headlight_switch,
            adc_value        => adc_value,            
            quarter_lights   => quarter_lights,
            normal_lights    => normal_lights,
            high_beam        => high_beam,
            headlight_led    => headlight_led,
            buzzer_alert     => buzzer_alert 
		  
		  );
		  


    -- Instanciación del Procesador de Datos
    Processor_Inst : Data_Processor
        port map (
            humidity  => rh,
            pwm_speed => pwm_speed_signal
        );

    -- Instanciación del Controlador PWM
		PWM_Inst : PWM_Controller
        port map (
            clk       => clk,
            pwm_speed => pwm_speed_signal,
            pwm_out   => pwm_out
        );
		  
-- ====================================================================
-- Instanciar la libreria para leer el sensor de humedad
-- ====================================================================
    LIBRERIA_DHT11_REVA_inst: LIBRERIA_DHT11_REVA
	port map(
	
				CLK		=>		clk,
				RESET		=>		reset,
				ENABLE	=>		enable_humity,
				DATA		=>	 	data,
				ERROR		=>		error_humity,
				RH			=>		rh,
				TEMP		=>		temp,
				FIN		=>		fin
				
	);
		 
	
end Behavioral;


