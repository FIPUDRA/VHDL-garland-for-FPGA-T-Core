-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Thu Feb 24 15:17:30 2022"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY garland IS 
	PORT
	(
		button_0 :  IN  STD_LOGIC;
		button_1 :  IN  STD_LOGIC;
		i_clk :  IN  STD_LOGIC;
		sw :  IN  STD_LOGIC_VECTOR(0 TO 3);
		RGB_DIN :  OUT  STD_LOGIC;
		green_led :  OUT  STD_LOGIC_VECTOR(0 TO 3)
	);
END garland;

ARCHITECTURE bdf_type OF garland IS 

COMPONENT garland_logic
GENERIC (delay_max : INTEGER
			);
	PORT(i_clk : IN STD_LOGIC;
		 button_0 : IN STD_LOGIC;
		 button_1 : IN STD_LOGIC;
		 green_led : OUT STD_LOGIC_VECTOR(0 TO 3)
	);
END COMPONENT;

COMPONENT rgb_led
GENERIC (bit_counter_max : INTEGER;
			delay_max : INTEGER;
			long_timing : INTEGER;
			short_timing : INTEGER
			);
	PORT(i_clk : IN STD_LOGIC;
		 button_0 : IN STD_LOGIC;
		 i_led_data : IN STD_LOGIC_VECTOR(0 TO 23);
		 o_data : OUT STD_LOGIC;
		 feedback_ready : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT rgb_logic
GENERIC (bit_counter_max : INTEGER;
			delay_max : INTEGER;
			number_of_LEDs : INTEGER
			);
	PORT(i_clk : IN STD_LOGIC;
		 button_0 : IN STD_LOGIC;
		 button_1 : IN STD_LOGIC;
		 feedback_ready : IN STD_LOGIC;
		 sw : IN STD_LOGIC_VECTOR(0 TO 3);
		 led_data : OUT STD_LOGIC_VECTOR(0 TO 23)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(0 TO 23);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;


BEGIN 



b2v_inst1 : garland_logic
GENERIC MAP(delay_max => 25000000
			)
PORT MAP(i_clk => i_clk,
		 button_0 => button_0,
		 button_1 => button_1,
		 green_led => green_led);


b2v_inst2 : rgb_led
GENERIC MAP(bit_counter_max => 23,
			delay_max => 14000,
			long_timing => 40,
			short_timing => 15
			)
PORT MAP(i_clk => i_clk,
		 button_0 => button_0,
		 i_led_data => SYNTHESIZED_WIRE_0,
		 o_data => RGB_DIN,
		 feedback_ready => SYNTHESIZED_WIRE_1);


b2v_inst3 : rgb_logic
GENERIC MAP(bit_counter_max => 23,
			delay_max => 3125000,
			number_of_LEDs => 4
			)
PORT MAP(i_clk => i_clk,
		 button_0 => button_0,
		 button_1 => button_1,
		 feedback_ready => SYNTHESIZED_WIRE_1,
		 sw => sw,
		 led_data => SYNTHESIZED_WIRE_0);


END bdf_type;