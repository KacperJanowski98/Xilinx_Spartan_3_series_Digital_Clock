library IEEE;  
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
entity jkff is  
	port (J : in STD_LOGIC;  
         K : in STD_LOGIC;  
         clock : in STD_LOGIC;    
         Q : out STD_LOGIC );  
end jkff;  

architecture Behavioral of jkff is  
signal JK    : std_logic_vector(1 downto 0) := "00";  
signal qsig  : std_logic := '0';
  
begin  
    JK  <= J & K;  
process(clock)  
begin  
    if (rising_edge(clock))then  
        case (JK) is  
            when "00"   => qsig <= qsig;      
            when "01"   => qsig <= '0';  
            when "10"   => qsig <= '1';  
            when others => qsig <= not qsig;  
        end case;  
    end if;  
end process;  
Q <= qsig;  
end Behavioral; 
