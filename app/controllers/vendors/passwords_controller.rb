class Vendors::PasswordsController < Devise::PasswordsController
  protected

  def resource_name
    :vendor
  end

  def resource_class
    Vendor
  end

  def devise_mapping
    Devise.mappings[:vendor]
  end
end
