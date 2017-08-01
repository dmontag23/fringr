describe StaticPagesController do

	before do
 		@base_title = "Fringr"
	end

	context "#routes" do
	  it "should get root" do
 			get root_url
	    expect(response.status).to eq(200)
 			assert_select "title", "#{@base_title}"
	  end

	  it "should get about" do
 			get about_url
	    expect(response.status).to eq(200)
 			assert_select "title", "About | #{@base_title}"
	  end

	  it "should get contact" do
 			get contact_me_url
	    expect(response.status).to eq(200)
 			assert_select "title", "Contact | #{@base_title}"
	  end
	end

end