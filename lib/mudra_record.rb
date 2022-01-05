module Mudra
  module Record
    def to_json
      attrs.to_json
    end

    def attrs
      _attrs = attributes
      _attrs['created_at'] = created_at.to_i
      _attrs['updated_at'] = updated_at.to_i
      _attrs['object']     = self.class.to_s
      _attrs
    end
  end

end
