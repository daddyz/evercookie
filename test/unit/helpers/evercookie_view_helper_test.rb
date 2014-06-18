require 'test_helper'
require 'action_view/test_case'

class EvercookieViewHelperTest < ActionView::TestCase

  include Evercookie::ViewHelper

  test 'that view have helpers' do
    assert self.methods.include?(:set_evercookie)
    assert self.methods.include?(:check_evercookie)
  end

  test 'that set_evercookie helper returns result' do
    result = set_evercookie(:testkey, :testvalue)
    assert_not_nil result
    assert_select 'script', 2
    assert result.include? "assets/ec.js"
    assert result.include? "ecc/set.js"
  end

  test 'that check_evercookie helper returns result' do
    result = check_evercookie(:testkey)
    assert_not_nil result
    assert_select 'script', 2
    assert result.include? "assets/ec.js"
    assert result.include? "ecc/get.js"
  end
end
