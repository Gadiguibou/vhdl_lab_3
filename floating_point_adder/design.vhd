library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fp_adder is
    port (
        a, b : in std_logic_vector (31 downto 0);
        s : out std_logic_vector (31 downto 0));
end fp_adder;

architecture behavioral of fp_adder is
    -- components
    component special_cases_adder is
        port (
            s_a, s_b : in std_logic;
            e_a, e_b : in std_logic_vector (7 downto 0);
            m_a, m_b : in std_logic_vector (22 downto 0);
            s : out std_logic_vector (31 downto 0)
        );
    end component;

    component normal_adder is
        port (
            s_a, s_b : in std_logic;
            e_a, e_b : in std_logic_vector (7 downto 0);
            m_a, m_b : in std_logic_vector (22 downto 0);
            s : out std_logic_vector (31 downto 0)
        );
    end component;

    -- split input signals into their parts
    signal s_a, s_b : std_logic;
    signal e_a, e_b : std_logic_vector (7 downto 0);
    signal m_a, m_b : std_logic_vector (22 downto 0);

    -- output signals
    signal special_cases_output : std_logic_vector (31 downto 0);
    signal normal_adder_output : std_logic_vector (31 downto 0);
begin
    -- split input signals into their parts
    s_a <= a (31);
    s_b <= b (31);
    e_a <= a (30 downto 23);
    e_b <= b (30 downto 23);
    m_a <= a (22 downto 0);
    m_b <= b (22 downto 0);

    sca : special_cases_adder port map(
        s_a => s_a,
        s_b => s_b,
        e_a => e_a,
        e_b => e_b,
        m_a => m_a,
        m_b => m_b,
        s => special_cases_output
    );

    na : normal_adder port map(
        s_a => s_a,
        s_b => s_b,
        e_a => e_a,
        e_b => e_b,
        m_a => m_a,
        m_b => m_b,
        s => normal_adder_output
    );

    s <= special_cases_output when e_a = b"1111_1111" or e_b = b"1111_1111" else
        normal_adder_output;

end architecture behavioral;