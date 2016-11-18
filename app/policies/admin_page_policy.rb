class AdminPagePolicy < Struct.new(:user, :admin_page)
  def show?
    user.admin?
  end
end