module RolesHelper
  def karnevalist_roles_path karnevalist, role = nil
    route = "/karnevalister/#{karnevalist.id}/roles"
    if role.nil?
      return route
    else 
      return route << "/#{role.id}"
    end
  end
end
