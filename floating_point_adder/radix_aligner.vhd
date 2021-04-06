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
        m_h, m_l : out std_logic_vector (23 downto 0)
    );
end entity radix_aligner;

architecture behavioral of radix_aligner is

    signal sm_a, sm_b : std_logic_vector (30 downto 0);
    signal should_swap : std_logic;
    signal e_h, e_l : std_logic_vector (7 downto 0);
    signal m_h1, m_l1 : std_logic_vector (22 downto 0);
    signal m_h2, m_l2 : std_logic_vector (23 downto 0);
    signal implied_bit_h, implied_bit_l : std_logic;
    signal shift_needed : unsigned (7 downto 0);

begin

    -- find which is highest
    sm_a <= e_a & m_a;
    sm_b <= e_b & m_b;

    should_swap <= '1' when sm_a < sm_b else
        '0';

    s_h <= s_b when should_swap = '1' else
        s_a;
    s_l <= s_a when should_swap = '1' else
        s_b;
    e_h <= e_b when should_swap = '1' else
        e_a;
    e_l <= e_a when should_swap = '1' else
        e_b;
    e_hl <= e_h;
    m_h1 <= m_b when should_swap = '1' else
        m_a;
    m_l1 <= m_a when should_swap = '1' else
        m_b;

    -- find implied bits
    implied_bit_h <= '0' when e_h = x"00" else
        '1';
    implied_bit_l <= '0' when e_l = x"00" else
        '1';
    m_h2 <= implied_bit_h & m_h1;
    m_l2 <= implied_bit_l & m_l1;

    -- determine shift amount
    shift_needed <= unsigned(e_h) - unsigned(e_l);

    -- shift lowest operand
    m_l <= std_logic_vector(shift_right(unsigned(m_l2), to_integer(shift_needed)));
    m_h <= m_h2;
end architecture behavioral;
