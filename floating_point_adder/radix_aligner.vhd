library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity radix_aligner is
    port (
        s_a, s_b : in std_logic;
        e_a, e_b : in std_logic_vector (7 downto 0);
        m_a, m_b : in std_logic_vector (22 downto 0);
        s_h, s_l : out std_logic;
        e_hl : out std_logic_vector (7 downto 0);
        m_h, m_l : out std_logic_vector ()
    );
end entity radix_aligner;