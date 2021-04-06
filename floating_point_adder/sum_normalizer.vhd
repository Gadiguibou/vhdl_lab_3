library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sum_normalizer is
    port (
        s : in std_logic;
        original_e : in std_logic_vector (7 downto 0);
        raw_sum : in std_logic_vector (24 downto 0);
        final_sum : out std_logic_vector (31 downto 0)
    );
end entity sum_normalizer;

architecture behavioral of sum_normalizer is

    signal overflow : std_logic;
    signal temp : std_logic_vector (24 downto 0);
    signal overflow_adjusted_exp : std_logic_vector (7 downto 0);
    signal overflow_adjusted_sum : std_logic_vector (23 downto 0);
    signal zero_reference : std_logic_vector (23 downto 0);
    signal shift_needed : unsigned (4 downto 0);

    signal normalized_sum : std_logic_vector (23 downto 0);
    signal normalized_exp : std_logic_vector (7 downto 0);
begin

    overflow <= raw_sum(24);

    temp <= (others => '0') when overflow = '1' and original_e = x"FE" else
        std_logic_vector(shift_right(unsigned(raw_sum), 1)) when overflow = '1' else
        (others => '0');
    overflow_adjusted_sum <= (others => '0') when overflow = '1' and original_e = x"FE" else
        temp (23 downto 0) when overflow = '1' else
        raw_sum (23 downto 0);
    overflow_adjusted_exp <= x"FF" when overflow = '1' and original_e = x"FE" else
        std_logic_vector(unsigned(original_e) - 1) when overflow = '1' else
        original_e;

    -- overflow_shift : process (original_e, raw_sum)
    -- begin
    --     if overflow = '1' and original_e = x"FE" then
    --         temp <= (others => '0');
    --         overflow_adjusted_sum <= (others => '0');
    --         overflow_adjusted_exp <= x"FF";
    --     elsif overflow = '1' then
    --         temp <= std_logic_vector(shift_right(unsigned(raw_sum), 1));
    --         overflow_adjusted_sum <= temp (23 downto 0);
    --         overflow_adjusted_exp <= std_logic_vector(unsigned(original_e) - 1);
    --     else
    --         temp <= (others => '0');
    --         overflow_adjusted_sum <= raw_sum (23 downto 0);
    --         overflow_adjusted_exp <= original_e;
    --     end if;
    -- end process overflow_shift;

    zero_reference <= (others => '0');

    shift_needed <= "11111" when overflow_adjusted_sum = zero_reference else
        "10111" when overflow_adjusted_sum (23 downto 1) = zero_reference (23 downto 1) else
        "10110" when overflow_adjusted_sum (23 downto 2) = zero_reference (23 downto 2) else
        "10101" when overflow_adjusted_sum (23 downto 3) = zero_reference (23 downto 3) else
        "10100" when overflow_adjusted_sum (23 downto 4) = zero_reference (23 downto 4) else
        "10011" when overflow_adjusted_sum (23 downto 5) = zero_reference (23 downto 5) else
        "10010" when overflow_adjusted_sum (23 downto 6) = zero_reference (23 downto 6) else
        "10001" when overflow_adjusted_sum (23 downto 7) = zero_reference (23 downto 7) else
        "10000" when overflow_adjusted_sum (23 downto 8) = zero_reference (23 downto 8) else
        "01111" when overflow_adjusted_sum (23 downto 9) = zero_reference (23 downto 9) else
        "01110" when overflow_adjusted_sum (23 downto 10) = zero_reference(23 downto 10) else
        "01101" when overflow_adjusted_sum (23 downto 11) = zero_reference(23 downto 11) else
        "01100" when overflow_adjusted_sum (23 downto 12) = zero_reference(23 downto 12) else
        "01011" when overflow_adjusted_sum (23 downto 13) = zero_reference(23 downto 13) else
        "01010" when overflow_adjusted_sum (23 downto 14) = zero_reference(23 downto 14) else
        "01001" when overflow_adjusted_sum (23 downto 15) = zero_reference(23 downto 15) else
        "01000" when overflow_adjusted_sum (23 downto 16) = zero_reference(23 downto 16) else
        "00111" when overflow_adjusted_sum (23 downto 17) = zero_reference(23 downto 17) else
        "00110" when overflow_adjusted_sum (23 downto 18) = zero_reference(23 downto 18) else
        "00101" when overflow_adjusted_sum (23 downto 19) = zero_reference(23 downto 19) else
        "00100" when overflow_adjusted_sum (23 downto 20) = zero_reference(23 downto 20) else
        "00011" when overflow_adjusted_sum (23 downto 21) = zero_reference(23 downto 21) else
        "00010" when overflow_adjusted_sum (23 downto 22) = zero_reference(23 downto 22) else
        "00001" when overflow_adjusted_sum (23) = zero_reference(23) else
        "00000";

    normalized_exp <= overflow_adjusted_exp when overflow_adjusted_exp = x"FF" else
    	x"00" when shift_needed = "11111" or unsigned(overflow_adjusted_exp) < "000" & shift_needed else
        std_logic_vector(unsigned(overflow_adjusted_exp) - shift_needed);

    normalized_sum <= (others => '0') when shift_needed = "11111" else
        std_logic_vector(shift_left(unsigned(overflow_adjusted_sum), to_integer(unsigned(overflow_adjusted_exp)))) when unsigned(overflow_adjusted_exp) < "000" & shift_needed else
        std_logic_vector(shift_left(unsigned(overflow_adjusted_sum), to_integer(shift_needed)));

    -- normalize : process (overflow_adjusted_exp, overflow_adjusted_sum, shift_needed)
    -- begin
    --     if shift_needed = "11111" then
    --         normalized_exp <= x"00";
    --         normalized_sum <= (others => '0');
    --     elsif unsigned(overflow_adjusted_exp) < "000" & shift_needed then
    --         normalized_exp <= x"00";
    --         normalized_sum <= std_logic_vector(shift_left(unsigned(overflow_adjusted_sum), to_integer(unsigned(overflow_adjusted_exp))));
    --     else
    --         normalized_exp <= std_logic_vector(unsigned(overflow_adjusted_exp) - shift_needed);
    --         normalized_sum <= std_logic_vector(shift_left(unsigned(overflow_adjusted_sum), to_integer(shift_needed)));
    --     end if;
    -- end process normalize;

    final_sum <= s & normalized_exp & (normalized_sum (22 downto 0));

end architecture behavioral;
