describe "User Delete Account" do
	
	fixtures :users

	before do
    @user = users(:michael)
    @other_user = users(:archer)
	end

	context "#user account" do
		it "should delete" do
	    expect do
	    	delete user_path(@user)
				expect(response).to redirect_to(login_path)
	    	delete user_path(@other_user)
				expect(response).to redirect_to(login_path)
				log_in_as (@user)
				expect(response).to redirect_to(root_path)
	    	delete user_path(@other_user)
				expect(response).to redirect_to(root_path)
			end.to_not change{ User.count }
			expect do
				delete user_path(@user)
				expect(flash.empty?).to be(false)
			end.to change{ User.count }.by(-1)
		end
	end

end