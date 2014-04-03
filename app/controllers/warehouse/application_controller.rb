class Warehouse::ApplicationController < ApplicationController
  # TODO only for dev
  before_filter :w_code
  skip_authorization_check

  def w_code
    return @warhouse_code = 0  if /fabriken/.match(request.fullpath)
    return @Warehouse_code = 1 if /festmasteriet/.match(request.fullpath)
    @Warehouse_code = -1
  end
end
