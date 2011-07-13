User.seed(:id) do |s|
  s.id    = 1
  s.email = "admin@learnstream.org"
  s.password = "foobar"
  s.password_confirmation = "foobar"
  s.perm = "admin"
end

User.seed(:id) do |s|
  s.id    = 2
  s.email = "guest@learnstream.org"
  s.password = "guest"
  s.password_confirmation = "guest"
end
