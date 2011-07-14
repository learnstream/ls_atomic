# SeedFu.quiet = true
#
Course.seed(:id) do |s|
  s.id    = 1
  s.name = "Mechanics"
  s.description = "Review of Newtonian Mechanics"
end

Course.seed(:id) do |s|
  s.id    = 2
  s.name = "Calculus Tutorials"
  s.description = "Tutorials on calculus, trigonometry, and other subjects. Credit for these excellent tutorials goes to the [HMC Math Department](http://www.math.hmc.edu/), where not otherwise indicated."
end

