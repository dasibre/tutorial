require 'spec_helper'

describe "AthenticationPages" do
         subject { page}
         
         describe "signin page" do
                  before { visit signin_path }
                  
                  it { should have_selector('h1', text: "Sign in") }
                  it { should have_selector('title', text: "Sign in") }
                  
         end
         
         describe "authorization" do
                  describe "for non-signed in users" do
                           let(:user) { FactoryGirl.create(:user) }
                           
                           describe "in the Users controller" do
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
                   before do
                          fill_in "Email",    with: user.email.upcase
                          fill_in "Password", with: user.password
                          click_button "Sign in"
                   end

                   it { should have_selector('title', text: user.name) }
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