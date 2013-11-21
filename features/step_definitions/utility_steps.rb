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


# verify hash model instance representation
def verify_obj_integrity(obj, modelName)
  obj.should have_key("id")
  obj["id"].should be_integer_valued
end

def verify_contained_obj_integrity(result, modelName)
  result.should have_key(modelName)
  verify_obj_integrity(result[modelName], modelName)
end


def reference_error_str(reference)
  "You need to specify what you mean by '#{reference}' (Never mentioned before)"
end