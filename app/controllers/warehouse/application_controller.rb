class Warehouse::ApplicationController < ApplicationController
  # TODO only for dev
  before_filter :w_code
  skip_authorization_check
  include Warehouse::ApplicationHelper

  def w_code
    return @warehouse_code = 0 if /fabriken/.match(request.fullpath)
    return @warehouse_code = 1 if /festmasteriet/.match(request.fullpath)
    @warehouse_code = -1
  end
end
