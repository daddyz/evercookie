class IndexController < ApplicationController
  include Evercookie::ControllerHelpers

  def index
  end

  def set
  end

  def get
  end

  def get_detailed
  end

  def get_controller
    render text: "cookie value: #{evercookie_get_value(params[:ec_name])}"
  end

  def get_defined
    render text: "cookie present?: #{evercookie_is_set?(params[:ec_name]).to_s}"
  end

end
