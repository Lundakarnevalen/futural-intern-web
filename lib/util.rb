# -*- encoding : utf-8 -*-
class Array
  def to_hash
    self.inject({}) do |r, s|
      r[s[0]] = s[1]; r
    end
  end
end
      

