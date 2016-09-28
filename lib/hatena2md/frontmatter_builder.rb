class FrontmatterBuilder
  def initialize
    @params = []
  end

  def method_missing(name, arg)
    @params << [name, arg]
    self
  end

  def build
    built = "---\n"
    @params.each do |key_and_value|
      built << "#{key_and_value[0]}: #{key_and_value[1]}\n"
    end
    built << "---\n"
  end
end
