-- WARNING: Do NOT edit the input and output ports in this file in a text
-- editor if you plan to continue editing the block that represents it in
-- the Block Editor! File corruption is VERY likely to occur.

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


-- Generated by Quartus Prime Version 18.1 (Build Build 625 09/12/2018)
-- Created on Thu Feb 17 18:36:52 2022

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--  Entity Declaration

ENTITY RGB_logic IS
-- {{ALTERA_IO_BEGIN}} DO NOT REMOVE THIS LINE!
GENERIC
(   
    bit_counter_max : INTEGER := 23;
    delay_max : INTEGER := 3572;
    number_of_LEDs : integer :=4
);
PORT
(
i_clk : IN STD_LOGIC;
button_0 : IN STD_LOGIC;
button_1 : IN STD_LOGIC;
sw : IN STD_LOGIC_VECTOR (0 to 3);
feedback_ready : IN STD_LOGIC;
led_data : OUT STD_LOGIC_VECTOR (0 to bit_counter_max)
);
-- {{ALTERA_IO_END}} DO NOT REMOVE THIS LINE!

END RGB_logic;


--  Architecture Body

ARCHITECTURE RGB_logic_architecture OF RGB_logic IS

type led_st_type is (st_idle, st_send, st_1_0, st_1_1, st_1_2, st_1_3, st_2_0, st_2_GR_1, st_2_GR_2, st_2_RB_1, st_2_RB_2, st_2_BG_1, st_2_BG_2, st_3, st_4, st_form_pocket, st_delay);
signal st: led_st_type:= st_idle;
type rgb_array_type is array (0 to number_of_LEDs-1) of std_logic_vector (0 to bit_counter_max);
signal GRB: rgb_array_type := (others => (others => '0'));
signal i: integer range 0 to number_of_LEDs-1 :=0;
signal green: unsigned (0 to 7):= (others => '0');
signal red: unsigned (0 to 7):= (others => '0');
signal blue: unsigned (0 to 7):= (others => '0');
signal menu: integer range 0 to 2 := 0;
signal count_for_st_1and2: integer range 0 to 6:= 0;
signal button_buff: std_logic;
signal button_buff_2: std_logic;
signal delay: integer range 0 to delay_max:=0;
BEGIN

logic:process(i_clk,button_0,button_1,sw, button_buff)
    begin
        button_buff <= button_1;

        if button_0 = '0' then
            led_data <= (others => '0');
            count_for_st_1and2<=0;
            menu <= 0;
        elsif rising_edge(i_clk) then

            button_buff <= button_1;
            button_buff_2 <= button_buff;
            
            if button_buff = '0' and button_buff_2 = '1'  then
                menu <= menu + 1;
                count_for_st_1and2 <= 0;
            end if;

            case st is
                when st_idle =>
                    if menu = 0 then 
                        st <= st_1_0;
                    elsif menu = 1 then 
                        st <= st_2_0;
                    elsif menu = 2 then st <= st_3;
                    elsif menu = 3 then st <= st_4;
                    end if;
                    
                when st_send =>
                    if feedback_ready = '1' then
                        led_data <= GRB(i);
                        if i = number_of_LEDs-1 then
                            i<= 0;
                            st<=st_delay;
                        else 
                            i<= i+1;
                        end if;
                    end if;

                when st_1_0 =>
                        if count_for_st_1and2 = 0 then
                            green <=    "00000000";
                            red <=      "00000000";
                            blue <=     "00010000";
                            count_for_st_1and2 <= 1;
                            st<=st_1_1;
                        elsif count_for_st_1and2 = 1 then 
                            st<=st_1_1;
                        elsif count_for_st_1and2 = 2 then 
                            st<=st_1_2;
                        elsif count_for_st_1and2 = 3 then 
                            st<=st_1_3;
                        end if;

                when st_1_1 =>
                    if green < "00010000" then
                        green <= green + 1;
                        blue <= blue - 1;
                        st<= st_form_pocket;
                    else
                        count_for_st_1and2<=2;
                        st<=st_1_0;
                    end if;
                
                when st_1_2 =>
                    if red < "00010000" then
                        green <= green - 1;
                        red <= red + 1;
                        st<= st_form_pocket;
                    else
                        count_for_st_1and2<=3;
                        st<=st_1_0;
                    end if;

                when st_1_3 =>
                    if blue < "00010000" then
                        blue <= blue + 1;
                        red <= red - 1;
                        st<= st_form_pocket;
                    else
                        count_for_st_1and2<=1;
                        st<=st_1_0;
                    end if;
                        
                when st_2_0 =>
                    if count_for_st_1and2 = 0 then
                        green <=    "00000000";
                        red <=      "00000000";
                        blue <=     "00000000";
                        count_for_st_1and2 <= 1;
                        st<=st_2_GR_1;
                    elsif count_for_st_1and2 = 1 then 
                        st<=st_2_GR_1;
                    elsif count_for_st_1and2 = 2 then 
                        st<=st_2_GR_2;
                    elsif count_for_st_1and2 = 3 then 
                        st<=st_2_RB_1;
                    elsif count_for_st_1and2 = 4 then 
                        st<=st_2_RB_2;
                    elsif count_for_st_1and2 = 5 then 
                        st<=st_2_BG_1;
                    elsif count_for_st_1and2 = 6 then 
                        st<=st_2_BG_2;
                    end if;

                when st_2_GR_1 =>
                    if green < "00010000" then
                        green <= green + 1;
                        red <= red +1;
                        st <= st_send;
                        GRB(0) <= std_logic_vector(green) & "00000000"  & "00000000";
                        GRB(1) <= "00000000" & std_logic_vector(red) & "00000000";
                        GRB(2) <= std_logic_vector(green) & "00000000" & "00000000";
                        GRB(3) <= "00000000" & std_logic_vector(red) & "00000000";
                    else
                        count_for_st_1and2<=2;
                        st<=st_2_0;
                    end if;

                when st_2_GR_2 =>
                    if green > "00000000" then
                        green <= green - 1;
                        red <= red -1;
                        st <= st_send;
                        GRB(0) <= std_logic_vector(green) & "00000000" & "00000000";
                        GRB(1) <= "00000000" & std_logic_vector(red) & "00000000";
                        GRB(2) <= std_logic_vector(green) & "00000000" & "00000000";
                        GRB(3) <= "00000000" & std_logic_vector(red) & "00000000";
                    else
                        count_for_st_1and2<=3;
                        st<=st_2_0;
                    end if;
                
                when st_2_RB_1 =>
                    if red < "00010000" then
                        red <= red + 1;
                        blue <= blue + 1;
                        st <= st_send;
                        GRB(0) <= "00000000" & std_logic_vector(red) & "00000000";
                        GRB(1) <= "00000000" & "00000000" & std_logic_vector(blue);
                        GRB(2) <= "00000000" & std_logic_vector(red) & "00000000";
                        GRB(3) <= "00000000" & "00000000" & std_logic_vector(blue);
                    else
                        count_for_st_1and2<=4;
                        st<=st_2_0;
                    end if;

                when st_2_RB_2 =>
                    if red > "00000000" then
                        red <= red - 1;
                        blue <= blue - 1;
                        st <= st_send;
                        GRB(0) <= "00000000" & std_logic_vector(red) & "00000000";
                        GRB(1) <= "00000000" & "00000000" & std_logic_vector(blue);
                        GRB(2) <= "00000000" & std_logic_vector(red) & "00000000";
                        GRB(3) <= "00000000" & "00000000" & std_logic_vector(blue);
                    else
                        count_for_st_1and2<=5;
                        st<=st_2_0;
                    end if;

                when st_2_BG_1 =>
                    if red < "00010000" then
                        blue <= blue + 1;
                        red <= red + 1;
                        st <= st_send;
                        GRB(0) <= "00000000" & "00000000" & std_logic_vector(blue);
                        GRB(1) <= std_logic_vector(green) & "00000000" & "00000000";
                        GRB(2) <= "00000000" & "00000000" & std_logic_vector(blue);
                        GRB(3) <= std_logic_vector(green) & "00000000" & "00000000";
                    else
                        count_for_st_1and2<=6;
                        st<=st_2_0;
                    end if;

                when st_2_BG_2 =>
                    if red > "00000000" then
                        blue <= blue - 1;
                        red <= red - 1;
                        st <= st_send;
                        GRB(0) <= "00000000" & "00000000" & std_logic_vector(blue);
                        GRB(1) <= std_logic_vector(green) & "00000000" & "00000000";
                        GRB(2) <= "00000000" & "00000000" & std_logic_vector(blue);
                        GRB(3) <= std_logic_vector(green) & "00000000" & "00000000";
                    else
                        count_for_st_1and2<=1;
                        st<=st_2_0;
                    end if;


                when st_3 =>
                    for i in 0 to number_of_LEDs-1 loop
                        if sw(i) = '1' then
                            GRB(i) <= "00000000" & "00010000" & "00000000";
                        else
                            GRB(i) <= "00000000" & "00000000" & "00000000";
                        end if;
                    end loop;
                    st <= st_send;
                
                when st_4 =>
                    if sw(i) = '1' then
                        GRB(i) <= "00010000" & "00000000" & "00000000";
                    else
                        GRB(i) <= "00000000" & "00010000" & "00000000";
                    end if;
                    st <= st_send;
                
                when st_form_pocket =>
                    for i in 0 to number_of_LEDs-1 loop
                        if sw(i) = '1' then
                            GRB(i) <= std_logic_vector(green) & std_logic_vector(red) & std_logic_vector(blue);
                        else
                            GRB(i) <= "00000000" & "00000000" & "00000000";
                        end if;
                    end loop;
                    st <= st_send;
                
                when st_delay =>
					if delay < delay_max then
						delay<=delay+1;
					else
						delay <= 0;
						st <=st_idle;
					end if;
            end case;
        end if;
    end process;
END RGB_logic_architecture;