describe UserMailer do

	fixtures :users
	
	context "account activation" do
		it "should validate email body" do
	    user = users(:michael)
	    user.activation_token = User.new_token
	    mail = UserMailer.account_activation(user)
	    expect("Fringr - Account Activation").to eq mail.subject
	    expect([user.email]).to eq mail.to
	    expect(["noreply@fringr.com"]).to eq mail.from
	    expect(mail.body.encoded).to include user.name
	    expect(mail.body.encoded). to include user.activation_token
	    expect(mail.body.encoded).to include CGI.escape(user.email)
		end
	end

	context "password reset" do
		it "should validate email body" do
	    user = users(:michael)
	    user.reset_token = User.new_token
	    mail = UserMailer.password_reset(user)
	    expect("Fringr - Password Reset").to eq mail.subject
	    expect([user.email]).to eq mail.to
	    expect(["noreply@fringr.com"]).to eq mail.from
	    expect(mail.body.encoded).to include user.reset_token
	    expect(mail.body.encoded).to include CGI.escape(user.email)
		end
	end

end