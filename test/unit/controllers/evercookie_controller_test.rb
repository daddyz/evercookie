require 'test_helper'

class EvercookieControllerTest < ActionController::TestCase

  test "should have route to set evercookie" do
    assert_routing '/evercookie/set',
                   { controller: "evercookie/evercookie", action: "set" }
  end

  test "should have route to get evercookie" do
    assert_routing '/evercookie/get',
                   { controller: "evercookie/evercookie", action: "get" }
  end

  test "should have route to save evercookie" do
    assert_routing '/evercookie/save',
                   { controller: "evercookie/evercookie", action: "save" }
  end

  test "should have route to ec_png evercookie" do
    assert_routing '/evercookie/ec_png',
                   { controller: "evercookie/evercookie", action: "ec_png" }
  end

  test "should have route to ec_cache evercookie" do
    assert_routing '/evercookie/ec_cache',
                   { controller: "evercookie/evercookie", action: "ec_cache" }
  end

  test "should have route to ec_etag evercookie" do
    assert_routing '/evercookie/ec_etag',
                   { controller: "evercookie/evercookie", action: "ec_etag" }
  end

  test "should set view variables on evercookie set and have right js" do
    @controller = Evercookie::EvercookieController.new

    session[Evercookie.hash_name_for_set] = {key: 'testkey', value: 'testvalue'}

    get :set, format: :js
    assert_response :success

    assert_equal assigns[:data], {'key' => 'testkey', 'value' => 'testvalue'}
    assert @response.body.include? "var ec = new evercookie()"
    assert @response.body.include? "ec.set('testkey', 'testvalue')"
  end

  test "should set view variables on evercookie get and have right js" do
    @controller = Evercookie::EvercookieController.new

    session[Evercookie.hash_name_for_get] = {key: 'testkey'}

    get :get, format: :js
    assert_response :success

    assert_equal assigns[:data], {'key' => 'testkey'}

    assert @response.body.include? "var ec = new evercookie()"
    assert @response.body.include? "ec.get('testkey')"
  end

  test "should set session variables on evercookie save if cookie present" do
    @controller = Evercookie::EvercookieController.new

    session[Evercookie.hash_name_for_get] = {key: 'testkey'}
    cookies[:testkey] = 'testvalue'

    get :save
    assert_response :success

    assert_equal session[Evercookie.hash_name_for_saved],
                 {'testkey' => 'testvalue'}
  end

  test "should not set session variables on save if cookie not present" do
    @controller = Evercookie::EvercookieController.new

    session[Evercookie.hash_name_for_get] = {key: 'testkey'}

    get :save
    assert_response :success

    assert session[Evercookie.hash_name_for_saved].nil?
  end
end
