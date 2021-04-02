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

    component radix_aligner is
        port (
            s_a, s_b : in std_logic;
            e_a, e_b : in std_logic_vector (7 downto 0);
            m_a, m_b : in std_logic_vector (22 downto 0);
            s_h, s_l : out std_logic;
            e_hl : out std_logic_vector (7 downto 0);
            m_h, m_l : out std_logic_vector (23 downto 0)
        );
    end component;

    component sum_normalizer is
        port (
            s : in std_logic;
            original_e : in std_logic_vector (7 downto 0);
            raw_sum : in std_logic_vector (24 downto 0);
            final_sum : out std_logic_vector (31 downto 0)
        );
    end component;

    signal s_h, s_l : std_logic;
    signal e_hl : std_logic_vector (7 downto 0);
    -- these include the hidden bits
    signal m_h, m_l : std_logic_vector (23 downto 0);
    signal sum_not_normalized : std_logic_vector (24 downto 0);

begin

    -- prepare operands
    ra : radix_aligner port map(
        s_a => s_a,
        s_b => s_b,
        e_a => e_a,
        e_b => e_b,
        m_a => m_a,
        m_b => m_b,
        s_h => s_h,
        s_l => s_l,
        e_hl => e_hl,
        m_h => m_h,
        m_l => m_l
    );

    sum_not_normalized <= std_logic_vector(unsigned('0' & m_h) - unsigned('0' & m_l)) when s_h /= s_l else
        std_logic_vector(unsigned('0' & m_h) + unsigned('0' & m_l));

    sn : sum_normalizer port map(
        s => s_h,
        original_e => e_hl,
        raw_sum => sum_not_normalized,
        final_sum => s
    );

end architecture rtl;
