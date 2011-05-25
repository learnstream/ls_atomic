Factory.define :user do |user|
  user.email                 "foo@bar.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end


Factory.define :course do |course|
  course.name         "TestCourse"
  course.description  "CoolCourse"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end
