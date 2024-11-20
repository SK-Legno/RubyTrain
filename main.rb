class BinFrac
  attr_reader :num, :den, :exp_bits, :inv_bits

  def initialize(num, den)
    @num = num
    @den = den
    @exp = 1
    @C = Array.new(64, 0)  # C0~C63 を 0 で初期化
    @E = Array.new(64, 0)  # E1~E64 を 0 で初期化

    @den_bit = @den.to_s(2).chars.map(&:to_i).reverse
    reduce_fraction
    odd_con
    binary_con
    output
  end

  private

  #def +(other)
    #result = self.@C + other.@C
    #BinFrac.new()
  #end

  #def -(other)
    
  #end

  def reduce_fraction
    gcd = @num.gcd(@den)
    @num /= gcd
    @den /= gcd
  end

  def output
    puts "分数: #{@num}/#{@den}"
    puts "2^#{@exp - 1} = #{@exp}"
    puts "E配列: #{@E.inspect}"
    puts "C配列: #{@C.inspect}"
  end

  def odd_con
    while @den.even? && @den != 2
      @den /= 2
      @exp <<= 1
    end
  end

  def binary_con

    # 1. 初期化
    @C[0] = 1
    @E[0] = 0
    sum_b = 0
  
  # b 配列のビットが立っている位置を特定
  b_indices = (0...@den_bit.size).select { |i| @den_bit[i] == 1 }

  # 2. 逐次計算
  (1...64).each do |i|
    # sum_b をビットが立っている箇所のみ計算
    sum_b = b_indices.select { |j| j <= i }.map { |j| @C[i - j] }.sum
  
      
      # C の計算
      if (@E[i] + sum_b) % 2 != 0
        @C[i] = 1
        @E[i+1] = (@E[i] + sum_b + 1) / 2
      else
        @E[i+1] = (@E[i] + sum_b) / 2
      end
    end
  end
end

# 使用例
frac1 = BinFrac.new(1, 3)
frac2 = BinFrac.new(1, 5)
frac3 = BinFrac.new(1, 15)
