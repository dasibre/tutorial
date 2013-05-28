require 'spec_helper'

describe "UserPages" do
         
         subject { page }
         
         describe "profile page" do
           let(:user) { FactoryGirl.create(:user) }
           let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
           let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

           before { visit user_path(user) }

           it { should have_selector('h1',    text: user.name) }
           it { should have_selector('title', text: user.name) }

            describe "microposts" do
                it { should have_content(m1.content) }
                it { should have_content(m2.content) }
                it { should have_content(user.microposts.count) }
            end
         end
         
  describe "index" do
           before do
                  sign_in(FactoryGirl.create(:user))
                  FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
                  FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
                  visit users_path
           end
           
           it { should have_title_tag("All users") }
           it { should have_selector('h1', text: "All users") }
              
              
              describe "micropost pagination" do
                    let(:user) { FactoryGirl.create(:user) }
                    before do
                           sign_in(user)
                           40.times { FactoryGirl.create(:micropost, user: user, content: "lorum ipsum") }
                           visit root_path
                           
                    end
  
                     it { should have_selector('div.pagination') }
                    
                     it "Should list each micropost" do
                        Micropost.paginate(page: 1).each do |item|
                          page.should have_selector('li', text: item.content)
                       end
                     end
              end
               describe "pagination" do
                    before(:all) { 30.times { FactoryGirl.create(:user) } }
                    after(:all)  { User.delete_all }
                    
                    it { should have_selector('div.pagination') }
                    
                    it "Should list each user" do
                       User.paginate(page: 1).each do |user|
                       page.should have_selector('li', text: user.name)
                    end
              end
              
              describe "delet links" do
                       it { should_not have_link('delete') }
                       
                       describe "as an admin user" do
                                let(:admin) { FactoryGirl.create(:admin) }
                                before do
                                  sign_in(admin) 
                                  visit users_path
                                end
                                
                               it { should have_link('delete', href: user_path(User.first)) }
                                 it "should be able to delete user" do
                                   expect { click_link('delete') }.to change(User, :count).by(-1)
                                 end
                               
                                it { should_not have_link('delete', href: user_path(admin)) }
                       end
              end
           end
        end
               describe "edit" do
                         let(:user) { FactoryGirl.create(:user) }
                                      before do
                                                sign_in(user)
                                                visit edit_user_path(user) 
                                      end
                                   describe "edit user page" do
                                    it { should have_selector('h1',    text: "Update your profile") }
                                    it { should have_selector('title', text: "Edit user") }
                                    it { should have_title_tag("Edit user") }
                                    it { should have_link('change', href: 'http://gravatar.com/emails') }
                                   end
           
            describe "with valid information" do
                    let(:new_name)  { "New Name" }
                    let(:new_email) { "new@example.com" }
                    before do
                       fill_in "Name",             with: new_name
                       fill_in "Email",            with: new_email
                       fill_in "Password",         with: user.password
                       fill_in "Confirmation", with: user.password
                       click_button "Save changes"
                    end

                      it { should have_selector('title', text: new_name) }
                      it { should have_selector('div.alert.alert-success') }
                      it { should have_link('Sign out', href: signout_path) }
                      specify { user.reload.name.should  == new_name }
                      specify { user.reload.email.should == new_email }
            end
    end       
         
  describe "sign up page" do
    before { visit signup_path }
    it { should have_selector('h1', text: "Sign Up") }
    it { should have_selector('title', text: full_title('Sign up')) } 
  end

  describe "user profile page" do
    let (:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }
	  it { should have_selector('h1', text: user.name) }
	  it { should have_selector('title', text: user.name) }
  end

   describe "signup" do
     before { visit signup_path }
     let(:submit) { "Create my account" }
    
            describe "with invalid information" do
	                      it "should not create a user" do
                        expect { click_button submit }.not_to change(User, :count)
            end
                         
            describe "after form submission with invalid/blank information" do
                     before { click_button submit }
                     
                     it { should have_content("error") }
                     it { should have_selector('h1', text: "Sign Up") }
                     it { should have_selector('div.alert.alert-error', text: "The form contains") }
            end
     end
    
	
     describe "with valid information" do
     	before do
	           fill_in "Name", 			with: "Example User"
	           fill_in "Email", 			with: "user@example.com"
	           fill_in "Password", 			with: "foobar"
	           fill_in "Confirmation",		with: "foobar"
	    end
	
	    it "should create a user" do
		     expect { click_button submit }.to change(User, :count).by(1)
	    end
         
       describe "after save" do
                before { click_button submit }
                let (:user) { User.find_by_email("user@example.com") }
                
                it { should have_selector('h1', text: user.name) }
                it { should have_selector('title', text: full_title(user.name)) }
                it { should have_link('Sign out') }
       end  
    end
  end
end
