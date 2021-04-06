library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;

entity testbench is
    -- empty
end testbench;

architecture tb of testbench is

    -- DUT component
    component fp_adder is
        port (
            a, b : in std_logic_vector (31 downto 0);
            s : out std_logic_vector (31 downto 0)
        );
    end component;

    signal s_a, s_b, s_o : std_logic;
    signal e_a, e_b, e_o : std_logic_vector (7 downto 0);
    signal m_a, m_b, m_o : std_logic_vector (22 downto 0);

    signal a_in, b_in, o_out : std_logic_vector (31 downto 0);

begin
	
    a_in <= s_a & e_a & m_a;
    b_in <= s_b & e_b & m_b;
    s_o <= o_out (31);
    e_o <= o_out (30 downto 23);
    m_o <= o_out (22 downto 0);

    fpa : fp_adder port map(
        a => a_in,
        b => b_in,
        s => o_out
    );

    process
    variable my_line : line;
    begin

        s_a <= '0';
        s_b <= '0';
        e_a <= "10000101";
        e_b <= "10000011";
        m_a <= "10010001011001100110011";
        m_b <= "10011001010001111010111";

        wait for 1 ns;
        
        write(my_line, string'("Instructions example"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
        s_a <= '0';
        s_b <= '1';
        e_a <= "10000101";
        e_b <= "10000011";
        m_a <= "10010001011001100110011";
        m_b <= "10011001010001111010111";
        
        wait for 1 ns;
        
        write(my_line, string'("Instructions example but substraction"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
		s_a <= '0';
        s_b <= '1';
        e_a <= "11111111";
        e_b <= "11111111";
        m_a <= (others => '0');
        m_b <= (others => '0');
        
        wait for 1 ns;
        
        write(my_line, string'("+inf + -inf = NaN"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
		s_a <= '0';
        s_b <= '0';
        e_a <= "11111111";
        e_b <= "11111111";
        m_a <= (others => '0');
        m_b <= (others => '0');
        
        wait for 1 ns;
        
        write(my_line, string'("+inf + +inf = +inf"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
        s_a <= '1';
        s_b <= '1';
        e_a <= "11111111";
        e_b <= "11111111";
        m_a <= (others => '0');
        m_b <= (others => '0');
        
        wait for 1 ns;
        
        write(my_line, string'("-inf + -inf = -inf"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
        s_a <= '0';
        s_b <= '0';
        e_a <= "11111111";
        e_b <= "10000011";
        m_a <= (others => '0');
        m_b <= "10011001010001111010111";
        
        wait for 1 ns;
        
        write(my_line, string'("+inf + real = +inf"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
        s_a <= '1';
        s_b <= '0';
        e_a <= "11111111";
        e_b <= "10000011";
        m_a <= (others => '0');
        m_b <= "10011001010001111010111";
        
        wait for 1 ns;
        
        write(my_line, string'("-inf + real = -inf"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
        s_a <= '0';
        s_b <= '1';
        e_a <= "10000101";
        e_b <= "10000101";
        m_a <= "10010001011001100110011";
        m_b <= "10010001011001100110011";
        
        wait for 1 ns;
        
        write(my_line, string'("n - n = 0"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
        s_a <= '0';
        s_b <= '0';
        e_a <= "11111110";
        e_b <= "11111110";
        m_a <= "10000000000000000000000";
        m_b <= "10000000000000000000000";
        
        wait for 1 ns;
        
        write(my_line, string'("overflow = +inf"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
        s_a <= '1';
        s_b <= '1';
        e_a <= "11111110";
        e_b <= "11111110";
        m_a <= "10000000000000000000000";
        m_b <= "10000000000000000000000";
        
        wait for 1 ns;
        
        write(my_line, string'("-overflow = -inf"));
        writeline(output, my_line);
        bwrite(my_line, o_out);
        writeline(output, my_line);
        bwrite(my_line, e_o);
        writeline(output, my_line);
        bwrite(my_line, m_o);
        writeline(output, my_line);
        
        -- reset input signals
		s_a <= '0';
        s_b <= '0';
        e_a <= (others => '0');
        e_b <= (others => '0');
        m_a <= (others => '0');
        m_b <= (others => '0');
        
        wait;

    end process;
end architecture tb;
