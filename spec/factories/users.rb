# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name                          "Kwesi Vii"
    email                         "kwesivii@foo.com"
    password                      "foobar"
    password_confirmation         "foobar"            
  end
end
