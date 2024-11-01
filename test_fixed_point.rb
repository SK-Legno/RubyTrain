require_relative "fixed_point"
require "minitest/autorun"

class TestFixedPoint < Minitest::Test
  def setup
    @f1 = FixedPoint.new(Rational(1, 3))  # 分数
    #@f5 = FIxedPoint.new(10 ** (-16))
  end

  def test_add_fractions
    result = @f1 + @f1 + @f1
    puts "Addition: #{@f1} + #{@f1} + #{@f1} = #{result}"  # 計算結果を表示
    assert_equal FixedPoint.new(1), result, "1/3 + 1/3 + 1/3 should be 1"
  end
end
