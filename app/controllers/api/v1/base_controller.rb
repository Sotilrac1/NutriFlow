class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
  respond_to :json

  # Override ApplicationController's allow_browser which is HTML-only
  skip_before_action :verify_authenticity_token, raise: false

  # ApplicationController#require_onboarding_complete! redirects to the web
  # onboarding page (edit_onboarding_path) for any signed-in user whose
  # profile isn't onboarding_complete?. That's an HTML-only web flow — the
  # API has no such page to redirect to, so every JSON request from a user
  # mid-onboarding was getting a 302 instead of a response. Mobile clients
  # read onboarding_complete? off the profile payload themselves instead.
  skip_before_action :require_onboarding_complete!

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Not found" }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { errors: e.record.errors }, status: :unprocessable_entity
  end

  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: e.message }, status: :bad_request
  end

  private

  def pagy_meta(pagy)
    { current_page: pagy.page, total_pages: pagy.pages, total_count: pagy.count }
  end
end
