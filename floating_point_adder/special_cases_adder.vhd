library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity special_cases_adder is
    port (
        s_a, s_b : in std_logic;
        e_a, e_b : in std_logic_vector (7 downto 0);
        m_a, m_b : in std_logic_vector (22 downto 0);
        s : out std_logic_vector (31 downto 0)
    );
end entity special_cases_adder;

architecture rtl of special_cases_adder is

begin

    main : process
    begin
        -- if any of the operands is NaN => output is NaN
        if (e_a = b"1111_1111" and m_a /= b"000_0000_0000_0000_0000_0000") or (e_b = b"1111_1111" and m_b /= b"000_0000_0000_0000_0000_0000") then
            s <= b"0_1111_1111_000_0000_0000_0000_0000_0001";
            -- if both operands are infinity:
        elsif (e_a = b"1111_1111" and m_a = b"000_0000_0000_0000_0000_0000") and (e_b = b"1111_1111" and m_b = b"000_0000_0000_0000_0000_0000") then
            -- if their signs are different => output is NaN
            if s_a /= s_b then
                s <= b"0_1111_1111_000_0000_0000_0000_0000_0001";
                -- if their signs are the same => output is infinity of the same sign as the inputs
            else
                s <= s_a & b"1111_1111_000_0000_0000_0000_0000_0000";
            end if;
            -- if the first operand only is infinity and the second is a real number => output is infinity
        elsif (e_a = b"1111_1111" and m_a = b"000_0000_0000_0000_0000_0000") then
            s <= s_a & b"1111_1111_000_0000_0000_0000_0000_0000";
            -- if the second operand only is infinity and the first is a real number => output is infinity
        elsif (e_b = b"1111_1111" and m_b = b"000_0000_0000_0000_0000_0000") then
            s <= s_b & b"1111_1111_000_0000_0000_0000_0000_0000";
            -- all special cases should be covered here
        end if;
    end process main;

end architecture rtl;
