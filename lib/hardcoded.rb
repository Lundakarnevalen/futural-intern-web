# Support code for hardcoded attribute names. 
# Warning, may contain traces of metaprogramming!

module Hardcoded
  # This is mixed into a model, allowing it to declare hardcoded attributes.
  # NB: `self` refers to at least three different objects here.

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def hardcoded sym, dict
      # Define getter.
      self.send :define_method, sym do
        PrivateMethods.value_or_death self[sym], dict
      end

      # Define setter.
      self.send :define_method, "#{sym}=" do |val|
        self[sym] = PrivateMethods.key_or_death val, dict
      end
    end
  end

  class PrivateMethods
    def self.key_or_death key, dict
      if dict.has_key? key
        key
      else
        fail ValueError, "No hardcoded translation for #{key.inspect}"
      end
    end

    def self.value_or_death key, dict
      dict[key_or_death(key, dict)]
    end
  end
end

