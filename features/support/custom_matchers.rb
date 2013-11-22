RSpec::Matchers.define :be_integer_valued do 
  match do |str|
    begin
      Integer(str)
      true
    rescue ArgumentError, TypeError
      false
    end
  end
end