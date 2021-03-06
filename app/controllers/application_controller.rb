class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :null_session, if: proc { |c| c.request.format == 'application/json' }

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

  rescue_from ActionController::RoutingError, with: -> { render_404  }

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render file: "#{Rails.root}/app/views/errors/404", layout: false, status: :not_found
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_url, alert: 'You are not authorized to access this page.'
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge(options)
  end

  helper_method :current_donor

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
    end

  private

    def current_donor
      Donor.current
    end

    def after_sign_out_path_for(_resource_or_scope)
      root_url(host: request.domain, subdomain: 'mande')
    end

    def set_locale
      if detect_browser.present?
        flash.clear
        flash[:alert] = detect_browser
      end
      I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
      session[:locale] = I18n.locale
    end

    def detect_browser
      lang = params[:locale] || locale.to_s
      if browser.firefox? && browser.platform.mac? && lang == 'km'
        "Khmer fonts for Firefox do not render correctly. Please use Google Chrome browser instead if you intend to use OSCaR in Khmer language."
      end
    end
end
