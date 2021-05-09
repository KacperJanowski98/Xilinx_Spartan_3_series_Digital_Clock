library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Digital_Clock is
	port ( clock : in std_logic;   
          clockDigital : inout std_logic;
			 clock2 : inout std_logic;
			 alarm : inout std_logic := '0';
			 dzwonek : out std_logic := '0';
			 ONOFFalarm : in std_logic := '1';
			 set : inout std_logic := '0';
			 resetAlarm : in std_logic := '0';
			 minAlarm : inout std_logic_vector(5 downto 0):="000000";
			 hourAlarm : inout std_logic_vector(4 downto 0):="00000";	
			 sec : inout std_logic_vector(5 downto 0):="000000";
			 min : inout std_logic_vector(5 downto 0):="000000";
			 hour : inout std_logic_vector(4 downto 0):="00000");			 
end Digital_Clock;

architecture Behavioral of Digital_Clock is
component jkff  
   PORT (clock : in std_logic;      
	  	  J : in std_logic;  
	  	  K : in std_logic;  
	     Q : out std_logic);  
end component;

signal temp : std_logic_vector(3 downto 0) := "0000";  
signal SEC1,MIN1,HOUR1 : integer range 0 to 60 := 0;
signal MINalarm1,HOURalarm1 : integer range 0 to 60 := 0;

begin 

sec <= conv_std_logic_vector(SEC1,6);
min <= conv_std_logic_vector(MIN1,6);
hour <= conv_std_logic_vector(HOUR1,5);
minAlarm <= conv_std_logic_vector(MINalarm1,6);
hourAlarm <= conv_std_logic_vector(HOURalarm1,5);

clock2 <= clock when set = '1' else clockDigital;
	
	JKFFA : jkff port map (clock =>clock, J=>'1', K=>'1', Q =>temp(3)); 
	JKFFB : jkff port map (clock =>temp(3), J=>'1', K=>'1', Q =>temp(2)); 
	JKFFC : jkff port map (clock =>temp(2), J=>'1', K=>'1', Q =>temp(1));  
	JKFFD : jkff port map (clock =>temp(1), J=>'1', K=>'1', Q =>temp(0));  
	  
	clockDigital <= temp(0); 
			
	process(clock2, set) 
	begin
		if (rising_edge(clock2) and set = '0') then
			SEC1 <= SEC1 + 1;
				if(SEC1 = 59) then
					SEC1<=0;
					MIN1 <= MIN1 + 1;
				end if;
				if(MIN1 = 59) then
					HOUR1 <= HOUR1 + 1;
					MIN1 <= 0;
				end if;
				if(HOUR1 = 23) then
					HOUR1 <= 0;
				end if;
		
		elsif (rising_edge(clock2) and set = '1') then
			SEC1 <= SEC1 + 1;
				if(SEC1 = 59) then
					SEC1<=0;
					MIN1 <= MIN1 + 1;
				end if;
				if(MIN1 = 59) then
					HOUR1 <= HOUR1 + 1;
					MIN1 <= 0;
				end if;
				if(HOUR1 = 23) then
					HOUR1 <= 0;
				end if;
		end if;

	end process;
	
	process(clock, resetAlarm) -- set / reset alarm
	begin
		if (resetAlarm = '1') then
			MINalarm1 <= 0;
			HOURalarm1 <= 0;
		elsif (rising_edge(clock) and alarm = '1') then
			MINalarm1 <= MINalarm1 + 1;
			if (MINalarm1 = 59) then
				HOURalarm1 <= HOURalarm1 + 1;
				MINalarm1 <= 0;
			if (HOURalarm1 = 23) then
				HOURalarm1 <= 0;
			end if;
			end if;
		end if;
	end process;
	
	dzwonek <= '1' when (min = minAlarm and hour = hourAlarm and ONOFFalarm = '1') or
            	(min = minAlarm + 1 and hour = hourAlarm and ONOFFalarm = '1') else '0';
 
end Behavioral;


