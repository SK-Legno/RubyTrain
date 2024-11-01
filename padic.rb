class PAdic
    attr_reader :p, :digits
  
    def initialize(p, digits = [])
      @p = p
      @digits = remove_leading_zeros(digits)
    end
  
    # 不要な先頭のゼロを削除する
    def remove_leading_zeros(digits)
      digits.drop_while { |d| d == 0 }
    end
  
    def padded_digits(other)
      max_length = [@digits.size, other.digits.size].max
      [@digits + [0] * (max_length - @digits.size),
       other.digits + [0] * (max_length - other.digits.size)]
    end
  
    def +(other)
      raise "Different bases!" unless @p == other.p
  
      a, b = padded_digits(other)
      result = []
      carry = 0
  
      a.size.times do |i|
        sum = a[i] + b[i] + carry
        result << sum % @p
        carry = sum / @p
      end
  
      result << carry if carry > 0
      PAdic.new(@p, result)
    end
  
    def -(other)
      raise "Different bases!" unless @p == other.p
  
      a, b = padded_digits(other)
      result = []
      borrow = 0
  
      a.size.times do |i|
        diff = a[i] - b[i] - borrow
        if diff < 0
          diff += @p
          borrow = 1
        else
          borrow = 0
        end
        result << diff
      end
  
      PAdic.new(@p, result)
    end
  
    def *(other)
      raise "Different bases!" unless @p == other.p
  
      result = Array.new(@digits.size + other.digits.size, 0)
  
      @digits.each_with_index do |a, i|
        other.digits.each_with_index do |b, j|
          result[i + j] += a * b
          result[i + j + 1] += result[i + j] / @p
          result[i + j] %= @p
        end
      end
  
      PAdic.new(@p, result)
    end
  
    def inverse
      raise "非ゼロのp進数でなければなりません" if @digits[0] == 0
  
      a, b = @p, @digits.first
      x0, x1 = 0, 1
  
      while b > 0
        q = a / b
        a, b = b, a % b
        x0, x1 = x1, x0 - q * x1
      end
  
      x0 += @p if x0 < 0  # 符号調整
      PAdic.new(@p, [x0])
    end
  
    def hensel_lift(f, df, iterations = 1)
      x = self
  
      iterations.times do
        fx = f.call(x)
        dfx = df.call(x)
  
        delta = (fx * dfx.inverse) * PAdic.new(@p, [1])
        x = x - delta
      end
  
      x
    end
  
    def to_s
      @digits.reverse.join(", ")
    end
  end
  
  # --- テスト実行 ---
  
  num1 = PAdic.new(7, [3, 2])
  num2 = PAdic.new(7, [5, 1])
  
  sum = num1 + num2
  product = num1 * num2
  puts "7進法での加算結果: #{sum}"
  puts "7進法での乗算結果: #{product}"
  
  inv = num1.inverse
  puts "7進法での逆元: #{inv}"
  
  f = ->(x) { x * x - PAdic.new(7, [2]) }
  df = ->(x) { x * 2 }
  
  root = num1.hensel_lift(f, df, 5)
  puts "ヘンゼルの補題による解: #{root}"
  