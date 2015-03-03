module DeviseForm
  def login_user
    @user = create(:user)
    visit "/users/login"
    page.should have_content("Email")
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
  end
end
