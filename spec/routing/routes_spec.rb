require "spec_helper"
describe "routes" do
  describe "routes for Devise" do
    it "routes /api/users/sign_in to the sessions controller" do
      { get: "/api/users/sign_in" }.
        should route_to(controller: "api/sessions", action: "new")
    end

    it "routes /api/users/sign_out to the sessions controller" do
      { delete: "/api/users/sign_out" }.
        should route_to(controller: "api/sessions", action: "destroy")
    end

    it "routes /api/users/password/new to the passwords controller" do
      { get: "/api/users/password/new" }.should route_to(controller: "api/passwords", action: "new")
    end
  end
end
