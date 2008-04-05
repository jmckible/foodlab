module Generator
  def self.random_string
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("1".."9").to_a
    string = ""
    1.upto(6) { |i| string << chars[rand(chars.size-1)] }
    string
  end
end