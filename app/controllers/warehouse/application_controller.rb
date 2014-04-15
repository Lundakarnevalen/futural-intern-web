# -*- encoding : utf-8 -*-
class Warehouse::ApplicationController < ApplicationController
  before_filter :w_code
  load_and_authorize_resource
  include Warehouse::ApplicationHelper

  def w_code
    return @warehouse_code = 0 if /fabriken/.match(request.fullpath)
    return @warehouse_code = 1 if /festmasteriet/.match(request.fullpath)
    @warehouse_code = -1
  end
end
