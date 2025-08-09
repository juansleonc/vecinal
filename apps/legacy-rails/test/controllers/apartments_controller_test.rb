require 'test_helper'

class ApartmentsControllerTest < ActionController::TestCase
  setup do
    @apartment = apartments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apartments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apartment" do
    assert_difference('Apartment.count') do
      post :create, apartment: { apartment_number: @apartment.apartment_number, available_at: @apartment.available_at, bathrooms: @apartment.bathrooms, bedrooms: @apartment.bedrooms, building_id: @apartment.building_id, category: @apartment.category, description: @apartment.description, furnished: @apartment.furnished, pets: @apartment.pets, price: @apartment.price, secondary_email: @apartment.secondary_email, secondary_phone_number: @apartment.secondary_phone_number, show_contact: @apartment.show_contact, show_price: @apartment.show_price, size_ft2: @apartment.size_ft2, title: @apartment.title }
    end

    assert_redirected_to apartment_path(assigns(:apartment))
  end

  test "should show apartment" do
    get :show, id: @apartment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @apartment
    assert_response :success
  end

  test "should update apartment" do
    patch :update, id: @apartment, apartment: { apartment_number: @apartment.apartment_number, available_at: @apartment.available_at, bathrooms: @apartment.bathrooms, bedrooms: @apartment.bedrooms, building_id: @apartment.building_id, category: @apartment.category, description: @apartment.description, furnished: @apartment.furnished, pets: @apartment.pets, price: @apartment.price, secondary_email: @apartment.secondary_email, secondary_phone_number: @apartment.secondary_phone_number, show_contact: @apartment.show_contact, show_price: @apartment.show_price, size_ft2: @apartment.size_ft2, title: @apartment.title }
    assert_redirected_to apartment_path(assigns(:apartment))
  end

  test "should destroy apartment" do
    assert_difference('Apartment.count', -1) do
      delete :destroy, id: @apartment
    end

    assert_redirected_to apartments_path
  end
end
