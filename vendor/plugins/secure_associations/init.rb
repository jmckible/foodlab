class << ActiveRecord::Base
  
  def belongs_to_with_protection(association_id, options = {}, &extension)
    protect = options.delete(:protected)
    belongs_to_without_protection(association_id, options, &extension)
    if protect
      reflection = create_belongs_to_reflection(association_id, options)
      attr_protected reflection.name.to_sym
      attr_protected reflection.primary_key_name.to_sym
    end
  end
  alias_method_chain :belongs_to, :protection
  
  def has_many_with_protection(association_id, options = {}, &extension)
    protect = options.delete(:protected)
    has_many_without_protection(association_id, options, &extension)
    if protect
      reflection = create_has_many_reflection(association_id, options, &extension)
      attr_protected reflection.name.to_sym
      attr_protected (reflection.name.to_s.singularize + '_ids').to_sym
    end
  end
  alias_method_chain :has_many, :protection  
end
