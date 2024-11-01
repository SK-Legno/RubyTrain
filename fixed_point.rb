class FixedPoint
  attr_reader :num, :den, :bits
  BIT_LIMIT = 61 # ビット数の制限を変更

  def initialize(input)
    @num, @den = parse(input)
    @bits = to_bits(@num, @den)
  end

  # 文字列表現で出力
  def to_s
    "#{@num}/#{@den} (#{to_f})"
  end

  # 小数表現で出力
  def to_f
    @num.to_f / @den
  end

  # ビット同士の加算
  def +(other)
    check!(other)
    # ビット数同士の加算
    result_bits = (self.bits + other.bits) % (2**BIT_LIMIT)
    FixedPoint.new(Rational(result_bits, 1)) # 分母を 1 にして新しいオブジェクトを生成
  end

  # ビット同士の減算
  def -(other)
    check!(other)
    # ビット数同士の減算
    result_bits = (self.bits - other.bits) % (2**BIT_LIMIT) # 負にならないようにモジュロ
    FixedPoint.new(Rational(result_bits, 1)) # 分母を 1 にして新しいオブジェクトを生成
  end

  # 比較
  def ==(other)
    other.is_a?(FixedPoint) && bits == other.bits
  end

  # 入力が分数であるかをチェック
  def check!(other)
    raise "Type mismatch: Expected fraction, got #{other.class}" unless other.is_a?(FixedPoint)
  end

  # 入力から分子・分母を取得
  def parse(input)
    case input
    when Rational
      [input.numerator, input.denominator]
    when Integer
      [input, 1]
    when Float
      float_to_fraction(input)
    else
      raise ArgumentError, "Invalid input type: #{input.class}"
    end
  end

  # Float を分数に変換
  def float_to_fraction(float)
    precision = 10**15 # 十分な精度を確保するためのスケール
    n = (float * precision).round
    d = precision
    gcd_val = gcd(n, d)
    [n / gcd_val, d / gcd_val]
  end

  # ユークリッドの互除法
  def gcd(a, b)
    b == 0 ? a : gcd(b, a % b)
  end

  # 分数をビット表現に変換
  def to_bits(num, den)
    mod = 2**BIT_LIMIT

    # num のモジュラ逆元を計算
    inverse = mod_inverse(den, mod)

    # a = (num * inverse) % mod
    a = (num * inverse) % mod

    # a をビット列に変換して返す
    a
  end

  # モジュラ逆元を求める
  def mod_inverse(a, mod)
    raise "偶数の逆元は存在しません" if a.even? && mod.even?
    g, x, _ = extended_gcd(a, mod)
    raise "逆元が存在しません: #{a} mod #{mod}" if g != 1
    x % mod
  end
  

  # 拡張ユークリッドの互除法
  def extended_gcd(a, b)
    if b == 0
      [a, 1, 0]
    else
      g, x, y = extended_gcd(b, a % b)
      [g, y, x - (a / b) * y]
    end
  end
end