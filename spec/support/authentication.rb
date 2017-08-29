def sign_in(user)
  visit user_session_path
  fill_in "user_email", 		  with: user.email
  fill_in "user_password",		with: user.password
  click_button "Sign in"
end

def sign_out
  visit root_path
  click_link "Sign out"
end
