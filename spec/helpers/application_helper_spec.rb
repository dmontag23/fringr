describe ApplicationHelper do
	
	context "#full title helper" do
		it "should validate tab titles" do
	    expect(full_title).to eq "Fringr"
	    expect(full_title("Help")).to eq "Help | Fringr"
		end
	end
	
end