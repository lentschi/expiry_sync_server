module TestHelper
  extend RSpec::Matchers
  
  # verify hash model instance representation
  def self.verify_obj_integrity(obj, modelName)
    obj.should have_key("id")
  end
  
  def self.verify_contained_obj_integrity(result, modelName)
    result.should have_key(modelName)
    verify_obj_integrity(result[modelName], modelName)
  end
  
  
  def self.reference_error_str(reference)
    "You need to specify what you mean by '#{reference}' (Never mentioned before)"
  end
end

World(TestHelper)