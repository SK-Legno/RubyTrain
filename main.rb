class BinFrac
    attr_reader :num, :den, :exp_bits, :inv_bits
  
    def initialize(num, den)
      @num = num
      @den = den
      @exp = 1
      reduce_fraction
      odd_con
      #binary_con
      output
    end
  
    private

    def reduce_fraction
      gcd = @num.gcd(@den)
      @num /= gcd
      @den /= gcd
    end

    def output
      puts "分数: #{@num}/#{@den}"
      puts "2^#{@exp} = #{2**@exp}"
    end
  
    def odd_con
      while @den.even?
        @den /= 2
        @exp = @exp << 1
      end

      while @num.even?

      end
    end

    def binary_con

    end

  end
  
  # 使用例
  frac = BinFrac.new(1, 7)

  frac = BinFrac.new(1, 4)
  