class RolesController < ApplicationController
  authorize_resource

  def index
    @roles = Role.includes(:users => :karnevalist).order('name').all
  end

  def roles
    @karnevalist = Karnevalist.includes(:user => :roles).find params[:id]
  end

  def grant
    @karnevalist = Karnevalist.includes(:user => :roles).find params[:id]
    @role = Role.find params[:role_id]
    unless @karnevalist.user.roles.include? @role
      @karnevalist.user.roles << @role
    end
    handle_errors @karnevalist.user, 'Access tilldelades utan problem', 
                  :redirect => { :action => :roles }
  end

  def revoke
    @karnevalist = Karnevalist.includes(:user => :roles).find params[:id]
    @role = Role.find params[:role_id]
    @karnevalist.user.roles.delete @role
    handle_errors @karnevalist.user, 'Access återkallades utan problem',
                  :redirect => { :action => :roles }
  end
end
