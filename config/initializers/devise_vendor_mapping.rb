Rails.application.config.to_prepare do
  Devise::Mailer.class_eval do
    def devise_mapping
      Devise.mappings[:vendor]
    end
  end
end
