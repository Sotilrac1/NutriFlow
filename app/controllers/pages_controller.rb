# LEGAL NOTE: The privacy policy view is a GDPR-aware starting template for
# NutriFlow's actual data practices — not legal advice. Carlos and Victor
# should read it fully and adjust before launch, especially [PLACEHOLDER] items.

class PagesController < ApplicationController
  # Public page — must be reachable without authentication (App Store review
  # will fetch this URL anonymously).
  skip_before_action :authenticate_user!, only: :privacy_policy, raise: false

  layout "landing"

  def privacy_policy
  end
end
