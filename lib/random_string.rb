class RandomString < String
  def initialize(length = 40)
    super(new_random_string(length))
  end


  private
  def new_random_string(length = 40)
    string = ""
    string += random_string until string.length >= length
    return string[0, length]
  end

  def random_string
    string_pairs = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join ).scan(/.{2}/)
    random_strings = string_pairs.collect{|s| s[0,1].crypt(s)}
    random_string = random_strings.join
    return random_string.gsub(/[^A-Za-z0-9]/, "")
  end
end