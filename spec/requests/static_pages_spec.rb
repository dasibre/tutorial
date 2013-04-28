require 'spec_helper'

describe "StaticPages" do
	let(:base_title) { "Ruby on Rails Tutorial" }
 
  subject { page}
    
  share_examples_for "all static pages" do
	it { should have_selector('h1', text: heading) }
	it { should have_selector('title', text: full_title(page_title)) }
  end
  
  it "should have the right linkes on the layout" do
  	visit root_path
	click_link "About"
	page.should have_selector('title', text: full_title("About"))
	click_link "Help"
	page.should have_selector('title', text: full_title("Help"))
	click_link 'Contact'
	page.should have_selector('title', text: full_title("Contact us"))
	click_link 'Home'
	page.should have_selector('title', text: full_title( ""))
	click_link "Sign up now"
	page.should have_selector('title', text: full_title('Sign up'))
	click_link "sample app"
	page.should have_selector('title', text: full_title(''))
  end

  describe "Home page" do
          before { visit root_path }
	  let (:heading) { "Welcome To" }
	  let (:page_title) { "" }
          it_should_behave_like "all static pages"
          #it {should have_selector('title', :text => "#{base_title}" ) }
          it { should_not have_selector('title', :text => "| Home" ) }
    
  end
  
  describe "Help page" do
           before { visit help_path }
	   let (:heading) { "Help" }
	   let (:page_title) { "Help" }
	   it_should_behave_like "all static pages"
           #it { should have_content('Help') }
           #it { should have_selector('title', :text => "#{base_title} | Help") }	
  end

  describe "About us page" do
       before { visit about_path }
       let (:heading) { "About Us" }
       let (:page_title) { "About us" }
       it_should_behave_like "all static pages"
       #it { should have_content('About Us') }
       #it { should have_selector('title', :text => "#{base_title} | About us") } 
  end

  describe "Contact us page" do
       before { visit contact_path }
       let (:heading) { "Contact us" }
       let (:page_title) { "Contact us" }
       it_should_behave_like "all static pages" # { should have_selector('h1', text: 'Contact us') }
        
  end

  

end
