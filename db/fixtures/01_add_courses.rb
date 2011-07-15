# SeedFu.quiet = true
#
Course.seed(:id) do |s|
  s.id    = 1
  s.name = "Mechanics"
  s.description = "Review of Newtonian Mechanics. Lesson content and exercises drawn from [MIT OpenCourseWare](http://ocw.mit.edu/courses/physics/8-01sc-physics-i-classical-mechanics-fall-2010/) under a [Creative Commons](http://ocw.mit.edu/terms/index.htm#cc) license, as well as the [Khan academy](http://www.khanacademy.org/) (also licensed under a [Creative Commons](http://creativecommons.org/licenses/by-nc-sa/3.0/us/) license)."
end

Course.seed(:id) do |s|
  s.id    = 2
  s.name = "Calculus Tutorials"
  s.description = "Tutorials on calculus, trigonometry, and other subjects. Credit for these excellent tutorials and exercises goes to the [HMC Math Department](http://www.math.hmc.edu/), where not otherwise indicated."
end

