require 'spec_helper'

describe "MicropostPages" do
         
         subject { page }
         
         let(:user) { FactoryGirl.create(:user) }
         before { sign_in(user) }
         
         describe "mpost creation" do
             before { visit root_path }
             
             describe "with invalid information" do
                it "should not create a micropost" do
                   expect { click_button "Post" }.not_to change(Micropost, :count)
                end
             end  
             
             describe "error messages" do
               before { click_button "Post" }
               it { should have_content("error") }
             end  
             
             describe "with valid information" do
              before { fill_in 'micropost_content', with: "lorem ipsum" }
              it "should create a micropost" do
                expect { click_button "Post" }.to change(Micropost, :count).by(1)
              end
                 describe "sidebar mposts single count" do
                  let(:mposts) {user.microposts}
                  it { should have_selector("span", text: "#{mposts.count} micropost") }
                 end
            end 
         end
         
         describe "micropost destruction" do
                  let(:correct_user) { FactoryGirl.create(:user) }
                  let(:wrong_user)   { FactoryGirl.create(:user) }
                  
                  
                  describe "as correct user" do
                           before do
                            FactoryGirl.create(:micropost, user: correct_user)
                            sign_in(correct_user)
                           end
                           
                           it "should delete a micropost" do
                              visit root_path
                              expect { click_link "delete" }.to change(Micropost, :count).by(-1)
                           end
                  end
                  
                  describe "as wrong user" do
                           before do
                            sign_in(wrong_user)
                            FactoryGirl.create(:micropost, user: correct_user)
                            visit user_path(correct_user)
                           end
                           
                           it { should_not have_link('delete') }
                           
                  end
         end
         
         
end
