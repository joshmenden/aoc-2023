class AOC
  def extract_digits(str, single_digit: false, exclude_negative: false)
    regex = if single_digit && exclude_negative
              /\d/
            elsif single_digit
              /-?\d/
            elsif exclude_negative
              /\d+/
            else
              /-?\d+/
            end

    return str.scan(regex).map(&:to_i)
  end
end
