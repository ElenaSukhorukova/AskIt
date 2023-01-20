def sign_in(user)
  visit new_session_path

  within("#new_session") do
    fill_in :session_email, with: user.email 
    fill_in :session_password, with: user.password
  end
  
  click_button I18n.t('submit.log_in')
end
