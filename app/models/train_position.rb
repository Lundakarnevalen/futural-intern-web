class TrainPosition < ActiveRecord::Base
  def as_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end
end
