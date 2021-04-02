library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity normal_adder is
    port (
        s_a, s_b : in std_logic;
        e_a, e_b : in std_logic_vector (7 downto 0);
        m_a, m_b : in std_logic_vector (22 downto 0);
        s : out std_logic_vector (31 downto 0)
    );
end entity normal_adder;

architecture rtl of normal_adder is

    signal s_h, s_l : std_logic;
    signal e_hl : std_logic_vector (7 downto 0);
    -- includes hidden bits
    signal m_h, m_l : std_logic_vector (23 downto 0);
    
begin
    
    -- prepare operands

end architecture rtl;