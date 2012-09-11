require 'test_helper'

class EvercookieControllerHelperTest < ActionController::TestCase

  include Evercookie::ControllerHelpers

  test 'that controller have helpers' do
    assert self.methods.include?(:evercookie_get_value)
    assert self.methods.include?(:evercookie_is_set?)
  end
end
