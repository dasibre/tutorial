require 'spec_helper'

describe "AthenticationPages" do
         subject { page}
         
         describe "signin page" do
                  before { visit signin_path }
                  
                  it { should have_selector('h1', text: "Sign in") }
                  it { should have_selector('title', text: "Sign in") }
                  
         end
         
         describe "authorization" do
                  describe "delete request for admin user" do
                                    let(:admin) { FactoryGirl.create(:admin) }
                                    
                                    before do
                                           sign_in(admin)
                                           delete user_path(admin)
                                    end
                                    
                                    it { should redirect_to(users_path) }
                    end
         
                  describe "visiting sign up page for signed in users" do
                           let(:user) { FactoryGirl.create(:user) }
                           before do
                                  sign_in(user)
                                  visit signup_path
                           end 
                           
                           it { should have_content("Please logout") }
                           
                            it "should redirect to root path" do
                               post "/users"
                               expect { response.should redirect_to(root_path) }
                            end
                  end
                  describe "as a non-admin user" do
                           let(:user) { FactoryGirl.create(:user) }
                           let (:non_admin) { FactoryGirl.create(:user) }
                           
                           before { sign_in non_admin }
                                  describe "submitting delete request to Users#destroy action" do
                                    before { delete user_path(user) }
                                    it { should redirect_to(root_path) }
                                  end
                           
                  end
                  describe "for non-signed in users" do
                           let(:user) { FactoryGirl.create(:user) }
                           
                           describe "in the Microposts controller" do
                               
                               describe "when submitting to create action" do
                                 before { post microposts_path }
                                 specify { response.should redirect_to(signin_path) }
                               end
                               
                               describe "when submitting to destroy action" do
                                 before { delete micropost_path(FactoryGirl.create(:micropost)) }
                                 specify { response.should redirect_to(signin_path) }
                               end
                           
                           
                            end
                           describe "When trying to visit a proected page" do
                                    before do
                                           visit edit_user_path(user)
                                           sign_in(user)
                                    end
                                    
                                    describe "after sign in" do
                                           
                                           it { should have_selector('h1', text: "Update your profile")}
                                           it { should have_title_tag(full_title("Edit user")) }
                                    end
                                    
                                    describe "when sining in again" do
                                             before do
                                               click_link "Sign out" 
                                               sign_in(user)
                                              end
                                              
                                              it "should render the default profile page" do
                                                 page.should have_title_tag(user.name)
                                              end
                                             
                                    end
                           end
                           
                          
                           describe "in the Users controller" do
                                    describe "when visiting user index" do
                                          before { visit users_path }
                                           it { should have_title_tag("Sign in") }
                                    end
                                    describe "visiting the edit page" do
                                             before { visit edit_user_path(user) }
                                             it { should have_selector('title', text: "Sign in") }
                                    end
                                    describe "submitting to the update action" do
                                             before { put user_path(user) }
                                             specify { response.should redirect_to(signin_path) }
                                    end
                           end
                  end
                  
                  describe "as wrong user" do
                           let(:user) { FactoryGirl.create(:user) }
                           let (:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
                           before { sign_in(user) }
                           
                           describe "visiting User#edit page" do
                                    before { visit edit_user_path(wrong_user) }
                                    
                                    it { should_not have_title_tag(full_title("Edit user"))}
                                    it { should have_selector("h1", text: user.name)}
                           end
                           
                           describe "submitting to Update action" do
                                    before { put user_path(wrong_user) }
                                    specify { response.should redirect_to(root_path) }
                           end
                  end
         end
         describe "sign in" do
                  before { visit signin_path }
                  
                  describe "with invalid information" do
                       before { click_button "Sign in" }
                       it { should have_selector('title', text: 'Sign in') }
                       it { should have_selector('div.alert.alert-error', text: 'Invalid') }
                  end
                  
                  describe "after visiting another page" do #flash persistence test
                    before { click_link "Home" }
                    it { should_not have_selector('div.alert.alert-error') }
                  end
                  
                  
               describe "with valid information" do
                   let(:user) { FactoryGirl.create(:user) }
                   before { sign_in(user) }

                   it { should have_selector('title', text: user.name) }
                   it { should have_link('Users', href: users_path) }
                   it { should have_link('Profile', href: user_path(user)) }
                   it { should have_link('Settings', href: edit_user_path(user)) }
                   it { should have_link('Sign out', href: signout_path) }
                   it { should_not have_link('Sign in', href: signin_path) }
                        
                  
                describe "followed by signout" do
                         before { click_link "Sign out" }
                         
                         it { should have_link("Sign in") }
                end
         end
         end
end
