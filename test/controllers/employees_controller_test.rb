require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:one)
  end

  test "should get index" do
    get employees_url
    assert_response :success
  end

  test "should get new" do
    get new_employee_url
    assert_response :success
  end

  test "should create employee" do
    assert_difference('Employee.count') do
      post employees_url, params: { employee: { city: @employee.city, country: @employee.country, date_of_birth: @employee.date_of_birth, designation: @employee.designation, email: @employee.email, employee_id: @employee.employee_id, first_name: @employee.first_name, last_name: @employee.last_name, mobile_number: @employee.mobile_number, pincode: @employee.pincode, state: @employee.state, status: @employee.status, street: @employee.street } }
    end

    assert_redirected_to employee_url(Employee.last)
  end

  test "should show employee" do
    get employee_url(@employee)
    assert_response :success
  end

  test "should get edit" do
    get edit_employee_url(@employee)
    assert_response :success
  end

  test "should update employee" do
    patch employee_url(@employee), params: { employee: { city: @employee.city, country: @employee.country, date_of_birth: @employee.date_of_birth, designation: @employee.designation, email: @employee.email, employee_id: @employee.employee_id, first_name: @employee.first_name, last_name: @employee.last_name, mobile_number: @employee.mobile_number, pincode: @employee.pincode, state: @employee.state, status: @employee.status, street: @employee.street } }
    assert_redirected_to employee_url(@employee)
  end

  test "should destroy employee" do
    assert_difference('Employee.count', -1) do
      delete employee_url(@employee)
    end

    assert_redirected_to employees_url
  end
end
