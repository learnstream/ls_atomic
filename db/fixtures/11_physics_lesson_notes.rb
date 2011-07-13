# DO NOT MODIFY THIS FILE, it was auto-generated.
#
# Date: 2011-07-13 15:26:08 -0700
# Seeding Note
# Written with the command:
#
#   ./script/SeedDataWriter 
#
Note.seed(:id,
  {:id=>220408914, :content=>"MIT - Position, Velocity, Acceleration", :is_document=>false, :event_token=>"45991292"},
  {:id=>203022391, :content=>"You should always begin a problem by defining a coordinate system. Here, Lewin defines \\( + \\hat{x} \\) to be up to the right.", :is_document=>false, :event_token=>"68772121"},
  {:id=>107831800, :content=>"Average velocity: \\[ \\bar{v}_{t_1, t_2} = \\frac{ v_{t_2} - v_{t_1}}{t_2 - t_1} \\]", :is_document=>false, :event_token=>"53139804"},
  {:id=>122319442, :content=>"Velocity is a vector quantity, thus a negative velocity means motion in the negative \\( \\hat{x} \\) direction. This comes out nicely in the way that the average velocity is defined as a change in displacement over a change in time.", :is_document=>false, :event_token=>"97686364"},
  {:id=>75434387, :content=>"On a graph of position-time, average velocity is just the slope of the line connecting two points on the graph.", :is_document=>false, :event_token=>"284691222"},
  {:id=>204290936, :content=>"There is a big difference between speed and velocity! Speed is a scalar quantity, measuring how fast an object travels but says nothing about its direction -- it is the magnitude of the velocity. Thus, if an object travels out some distance and then back to its starting point, it will have a zero average velocity (since the net displacement is zero) but its speed will be non-negative.", :is_document=>false, :event_token=>"25966915"},
  {:id=>128560527, :content=>"The instantaneous velocity is just the derivative of position, \\[ \\mathbf v = \\frac{d \\mathbf x}{dt}  \\]", :is_document=>false, :event_token=>"191196525"},
  {:id=>225468780, :content=>"End of introduction to velocity", :is_document=>false, :event_token=>"118412074"},
  {:id=>282611744, :content=>"Introduction to average acceleration", :is_document=>false, :event_token=>"4581221"},
  {:id=>44940970, :content=>"Average acceleration: \\[ \\bar{a}_{t_1,t_2} = \\frac{a_{t_2} - a_{t_1}}{t_2-t_1} \\]", :is_document=>false, :event_token=>"313985694"},
  {:id=>108077592, :content=>"Acceleration has units of meters per second squared.", :is_document=>false, :event_token=>"169534600"},
  {:id=>8020593, :content=>"Instantaneous acceleration is just \\[ \\mathbf a = \\frac{d \\mathbf v}{dt}  = \\frac{d^2 \\mathbf x}{dt^2}  \\]", :is_document=>false, :event_token=>"197353634"},
  {:id=>89879460, :content=>"End of Lesson", :is_document=>false, :event_token=>"293365013"},
  {:id=>180792645, :content=>"Example: \\( x(t) = 8- 6t+t^2 \\)", :is_document=>false, :event_token=>"34006924"},
  {:id=>263171275, :content=>"\\[ v(t) = \\frac{dx}{dt} = 2 t - 6 \\]", :is_document=>false, :event_token=>"49163741"},
  {:id=>55006915, :content=>"\\[ a(t) = \\frac{dv}{dt} = 2 \\]", :is_document=>false, :event_token=>"285848185"},
  {:id=>6232870, :content=>"Types of questions in kinematics: What is the velocity or acceleration at time \\( t \\)? What is the time when the position or velocity is a certain value?", :is_document=>false, :event_token=>"193075015"},
  {:id=>78864708, :content=>"Making position, velocity, and acceleration graphs.", :is_document=>false, :event_token=>"69496662"},
  {:id=>122580691, :content=>"General expression for position and velocity under constant acceleration.", :is_document=>false, :event_token=>"74938869"},
  {:id=>245870596, :content=>"\\[ x(t) = C_1 + C_2 t + C_3 t^2 \\]", :is_document=>false, :event_token=>"232570457"},
  {:id=>29652294, :content=>"\\[ v(t) = \\frac{dx}{dt} = C_2 + 2 C_3 t \\]", :is_document=>false, :event_token=>"59917784"},
  {:id=>85884226, :content=>"\\[ a(t) = \\frac{dv}{dt} = 2 C_3 \\]", :is_document=>false, :event_token=>"199285000"},
  {:id=>199668222, :content=>"End of Lesson", :is_document=>false, :event_token=>"271416540"},
  {:id=>174350303, :content=>"Introduction to vectors and vector addition", :is_document=>false, :event_token=>"47614130"},
  {:id=>189712115, :content=>"When writing out solutions, an \"x\" on the paper indicates a vector going *into* the page, while a dot indicates a vector coming out of the page.", :is_document=>false, :event_token=>"140688073"},
  {:id=>47874274, :content=>"In general, Learnstream will use \"math boldface\" to denote vectors. Thus, \\( \\mathbf a \\) is the vector \\( \\vec{a} \\).", :is_document=>false, :event_token=>"223280273"},
  {:id=>44010139, :content=>"Adding vectors - The sum of two vectors \\( \\mathbf A \\) and \\( \\mathbf B \\) can be found by placing them head-to-tail and drawing the \"resultant\" as shown. This is useful for understanding the geometric significance.", :is_document=>false, :event_token=>"32824100"},
  {:id=>123562658, :content=>"A \"negative\" sign in front of a vector simply means the vector is flipped by \\( 180^\\circ \\).", :is_document=>false, :event_token=>"283418008"},
  {:id=>161723936, :content=>"Subtracting vectors can be achieved by adding the negative of the vector you want to subtract.", :is_document=>false, :event_token=>"52690240"},
  {:id=>170636447, :content=>"The triangle inequality addresses this idea -- \\[ |\\mathbf A + \\mathbf B| \\le |\\mathbf A| + |\\mathbf B| \\]", :is_document=>false, :event_token=>"34513872"},
  {:id=>166326590, :content=>"Decomposition of vectors - We can \"project\" a vector onto each axis to get its component in each of the orthogonal axis directions \\( \\hat{x}, \\hat{y}, \\hat{z} \\). This is called \"vector decomposition.\"", :is_document=>false, :event_token=>"20258825"},
  {:id=>129638866, :content=>"Any vector \\( \\mathbf A \\) can be decomposed such that \\[ \\mathbf A = A_x \\hat{x} + A_y \\hat{y} + A_z \\hat{z} \\]", :is_document=>false, :event_token=>"295230329"},
  {:id=>238271940, :content=>"The magnitude of a vector \\( \\mathbf A \\) is just \\[ |A| = \\sqrt{A_x^2 + A_y^2 + A_z^2} \\]", :is_document=>false, :event_token=>"82804925"},
  {:id=>153728983, :content=>"The magnitude of \\( \\mathbf A = 3 \\uvec x - 5 \\uvec y + 6 \\uvec z \\) is just \\[ |\\mathbf A| = \\sqrt{3^2 + (-5)^2 + 6^2} = \\sqrt{70} \\] ", :is_document=>false, :event_token=>"271584242"},
  {:id=>45760723, :content=>"End of Lesson", :is_document=>false, :event_token=>"188812562"},
  {:id=>36543625, :content=>"Multiplication of vectors", :is_document=>false, :event_token=>"78309380"},
  {:id=>116817967, :content=>"The dot product (sometimes called \"scalar product\") is defined as \\[ \\mathbf A \\cdot \\mathbf B = A_x B_x + A_y B_y + A_z B_z \\] Intuitively, the dot product is multiplying parallel components of vectors, and the result is always a scalar.", :is_document=>false, :event_token=>"284124896"},
  {:id=>261941789, :content=>"The dot product can also be found by \\[ \\mathbf A \\cdot \\mathbf B = |A||B| \\cos \\theta \\] where \\( \\theta \\) is the angle between the two vectors when they are put tail to tail. Both above definitions are equivalent, and sometimes one is easier to compute than the other.", :is_document=>false, :event_token=>"84789136"},
  {:id=>270625582, :content=>"Example", :is_document=>false, :event_token=>"106175801"},
  {:id=>303246007, :content=>"The dot product of perpendicular vectors is always 0", :is_document=>false, :event_token=>"310648455"},
  {:id=>301575331, :content=>"Cross product explanation.", :is_document=>false, :event_token=>"192838521"},
  {:id=>169236003, :content=>"Geometric definition of cross product - \\[ \\mathbf A \\times \\mathbf B = |A||B| \\sin \\theta \\]", :is_document=>false, :event_token=>"170286278"},
  {:id=>19405138, :content=>"Right hand rule for determining the direction of a cross product. The result of \\( \\mathbf A \\times \\mathbf B \\) is *always* perpendicular to both \\( \\mathbf A \\) and \\( \\mathbf B \\)!", :is_document=>false, :event_token=>"93680239"},
  {:id=>25049141, :content=>"\\[ \\mathbf A \\times \\mathbf B = - \\mathbf B \\times \\mathbf A \\]", :is_document=>false, :event_token=>"16261465"},
  {:id=>45351440, :content=>"Difference between left-handed and right-handed coordinate systems is very important! We always use a right-handed coordinate system, such that \\[ \\hat{x} \\times \\hat{y} = + \\hat{z} \\]", :is_document=>false, :event_token=>"58935153"},
  {:id=>74675130, :content=>"End of Lesson", :is_document=>false, :event_token=>"257301725"},
  {:id=>24538925, :content=>"Problem setup: An ice skater is on an ice rink, holding a \\( 0.15 \\text{ kg } \\) ball. She throws the ball exactly straight forward, with a velocity of \\( 35 \\text{ m/s } \\). The combined mass of the skater and the ball is \\( 50 \\text{ kg }\\). We want to calculate her velocity after she throws the ball.", :is_document=>false, :event_token=>"37090012"},
  {:id=>70654749, :content=>"We define our coordinate system -- \\( +\\hat{x} \\) is to the right.", :is_document=>false, :event_token=>"196562040"},
  {:id=>295520118, :content=>"It is usually best to work symbolically, and plug in numbers at the end. This reduces rounding errors, and allows you to see the abstract relationships more easily.", :is_document=>false, :event_token=>"299882652"},
  {:id=>28071160, :content=>" \\[ v_{f, \\text{skater}} = - \\frac{v_{f,\\text{ball}} m_{\\text{ball}}}{m_{\\text{skater}}} \\] ", :is_document=>false, :event_token=>"41078368"},
  {:id=>81947700, :content=>"You can think about Newton's third law in terms of conservation of momentum. If two bodies interact with each other in the absence of external forces, momentum must be conserved. If Object 2 experiences a change in momentum \\( \\Delta p_2 \\) from the force exerted by Object 1, to conserve momentum it must be that Object 1 experiences a change in momentum \\( \\Delta p_1 = - \\Delta p_2 \\). But, this change in momentum must arise from a force exerted by Object 2, and since the changes in momentum are equal and opposite, the forces that produced them must also be equal and opposite as is required by Newton's third law!", :is_document=>false, :event_token=>"284175258"},
  {:id=>108963887, :content=>"End of Lesson", :is_document=>false, :event_token=>"49358909"},
  {:id=>6880625, :content=>"Beginning of lesson on Newton's Laws", :is_document=>false, :event_token=>"243993977"},
  {:id=>93546032, :content=>"Newton's first law originated with Galileo's Law of Inertia.", :is_document=>false, :event_token=>"20271254"},
  {:id=>229531267, :content=>"Newton's first law: **Bodies at rest will remain at rest, and bodies in motion will continue to move at constant velocity along a straight line unless acted upon by an external force.**", :is_document=>false, :event_token=>"51901963"},
  {:id=>135768371, :content=>"Newton's first law does not hold in \"non-inertial\" reference frames, that is, reference frames that are themselves accelerating.", :is_document=>false, :event_token=>"263243521"},
  {:id=>65195952, :content=>"Your reference frame (standing on earth) is actually non-inertial, because the earth is rotating about its axis and is also orbiting the sun, both of which give rise to centripetal accelerations. These centripetal accelerations, however, are very small.", :is_document=>false, :event_token=>"131893420"},
  {:id=>43648019, :content=>"To estimate the size of the centripetal acceleration at the equator, we calculate: \\[ a_c = \\omega^2 R \\] we can find \\( \\omega \\) as \\[ \\omega = \\frac{2 \\pi}{T} = \\frac{2 \\pi}{3600 \\units{s/hr} \\cdot 24\\units{hr}} \\approx 7.3 \\times 10^{-5} \\units{rad/s} \\] and \\( R \\approx 6.4 \\times 10^6 \\units{m} \\) is the radius of the earth. Thus, we find \\[ a_c \\approx 0.034 \\unitsf{m}{s^2} \\] which is extremely small -- compare \\( g \\approx 9.8 \\units{m/s} \\). Thus, reference frames on earth are practically inertial.", :is_document=>false, :event_token=>"6194397"},
  {:id=>197701405, :content=>"Experiment demonstrating Newton's second law.", :is_document=>false, :event_token=>"218757421"},
  {:id=>36648524, :content=>"\\( m_1 a_1 = m_2 a_2 \\) means that the same force on an object with 10 times the mass will produce 1/10th the acceleration.", :is_document=>false, :event_token=>"187335432"},
  {:id=>194938375, :content=>"Newton's second law: \\[ \\mathbf F = m \\mathbf a \\] a net force on an object produces an acceleration in the direction of that force, proportional to the mass of the object.", :is_document=>false, :event_token=>"109806657"},
  {:id=>106955728, :content=>"Force has units \\[ \\units{\\left[ mass \\right] \\cdot \\left[ acceleration \\right]} \\rightarrow \\unitsf{kg\\ m}{s^2} \\] This is called a \"Newton\".", :is_document=>false, :event_token=>"34228257"},
  {:id=>108141682, :content=>"Newton's second law also only holds in inertial reference frames.", :is_document=>false, :event_token=>"273387319"},
  {:id=>49565098, :content=>"Because the acceleration due to earth's gravity (near the surface) is a constant \\( g = 9.8 \\units{m/s^2} \\), we can write a *force* due to gravity as \\[ F_g = m g \\] This force is always directed down towards the earth's center.", :is_document=>false, :event_token=>"132026347"},
  {:id=>167143659, :content=>"A ball of mass \\( m \\) resting on a table will experience a gravitational force \\( F_g = m g \\). Because it is not accelerating, we know there must be no net force on the ball. The table must exert a \"normal force\" \\( F_N = - mg \\)  to balance the gravitational force. Thus, \\( F_g + F_N = 0 \\), and the ball is not accelerating.", :is_document=>false, :event_token=>"272576687"},
  {:id=>36214159, :content=>"The \"normal force\" is generated when two objects are in contact with each other. It is always directed perpendicular to the surface of contact (*normal* is a synonym for *perpendicular*).", :is_document=>false, :event_token=>"176880975"},
  {:id=>126631957, :content=>"Newton's second law implies that if we know the mass of an object and the forces acting on it, the acceleration is uniquely determined. We do *not* need to know anything about its speed! Thus, Newton's 2nd law holds equally well for a stationary object as for one in constant motion. Disclaimer: when velocities near the speed of light, Newtonian mechanics no longer hold and we must use relativity.", :is_document=>false, :event_token=>"50339472"},
  {:id=>270591641, :content=>"End of MIT Lecture on Newton's 1st and 2nd Laws", :is_document=>false, :event_token=>"177472915"},
  {:id=>203642900, :content=>"Newton's Third Law: If one object exerts a force on another, the other exerts the same force, in the opposite direction, on the one.", :is_document=>false, :event_token=>"96460000"},
  {:id=>198410310, :content=>"Students can often repeat Newton's third law, but don't really understand when it comes time to do a problem. *Any* time two bodies exert a force on each other, the forces are always equal and opposite!", :is_document=>false, :event_token=>"201905241"},
  {:id=>6268853, :content=>"\"Action\" = - \"Reaction\"", :is_document=>false, :event_token=>"138262244"},
  {:id=>12946148, :content=>"Newton's Third law *always* holds, whether objects are accelerating or not!", :is_document=>false, :event_token=>"217923676"},
  {:id=>146495621, :content=>"Example of Newton's 2nd law; Force on two blocks, find acceleration of whole system", :is_document=>false, :event_token=>"30787808"},
  {:id=>144675534, :content=>"Example of Newton's 2nd law, to find the force \\( F_{12} \\)", :is_document=>false, :event_token=>"137786739"},
  {:id=>39236739, :content=>"Example of Newton's 2nd law, to find the force \\( F_{21} \\)", :is_document=>false, :event_token=>"99491936"},
  {:id=>1440317, :content=>"These forces are consistent with Newton's 3rd law!", :is_document=>false, :event_token=>"289485300"},
  {:id=>206046706, :content=>"End of MIT Lecture on Newton's 3rd Law.", :is_document=>false, :event_token=>"296964969"},
  {:id=>80955972, :content=>"Beginning of misconceptions video about Newton's 3rd Law.", :is_document=>false, :event_token=>"277167212"},
  {:id=>150009383, :content=>"The force attracting the moon to the earth is exactly the same size as the force attracting the earth to the moon. This is a consequence of Newton's third law!", :is_document=>false, :event_token=>"105367904"},
  {:id=>128841281, :content=>"The earth doesn't move very much because it is much more massive. By Newton's 2nd law, the same force will produce a greater acceleration for the moon (which has a much smaller mass) than for the earth (which has a much larger mass).", :is_document=>false, :event_token=>"228421248"},
  {:id=>271360557, :content=>"You've got to internalize Newton's third law so it comes naturally when solving problems! Whenever two bodies are interacting via some force, that force is *the same size* -- the force exerted on body 1 by body 2 is equal and opposite to the force exerted on body 2 by body 1!", :is_document=>false, :event_token=>"91552836"},
  {:id=>119247796, :content=>"Intuitive explanation of Newton's third law.", :is_document=>false, :event_token=>"136668624"},
  {:id=>106803140, :content=>"End of misconceptions video about Newton's 3rd Law", :is_document=>false, :event_token=>"167138519"},
  {:id=>212124483, :content=>"Involved example with Newton's laws.", :is_document=>false, :event_token=>"262027575"},
  {:id=>161914019, :content=>"A mass \\( m \\) hangs from two strings attached to the ceiling, one at \\( 60^\\circ \\) and one at \\( 45^\\circ \\). Find the tensional force in each string.", :is_document=>false, :event_token=>"310163997"},
  {:id=>283674080, :content=>"We know from Newton's 2nd law that \\[ \\mathbf F = m \\mathbf a = 0 \\] since the mass is not moving.", :is_document=>false, :event_token=>"169060702"},
  {:id=>290458652, :content=>"We can decompose the vector \\( \\mathbf F \\) into \\( \\hat x \\) and \\( \\hat y \\) components.", :is_document=>false, :event_token=>"278752581"},
  {:id=>304459932, :content=>"\\[ \\sum F_x = 0, \\sum F_y = 0 \\]", :is_document=>false, :event_token=>"30319440"},
  {:id=>209190014, :content=>"\\[ \\sum F_x = T_1 \\cos 60^\\circ - T_2 \\cos 45^\\circ = 0 \\] \\[ \\sum F_x = \\frac{1}{2} T_1 - \\frac{\\sqrt{2}}{2} T_2 = 0 \\]", :is_document=>false, :event_token=>"253424449"},
  {:id=>5417749, :content=>"\\[ \\sum F_y = T_1 \\sin 60^\\circ + T_2 \\sin 45^\\circ - mg = 0 \\] \\[ \\sum F_y = \\frac{\\sqrt{3}}{2} T_1 + \\frac{\\sqrt{2}}{2} T_2 - mg= 0 \\]", :is_document=>false, :event_token=>"182346576"},
  {:id=>156455053, :content=>"Solving for \\( T_1 \\) by adding the two equations, we see that \\[ \\frac{1}{2} T_1 + \\frac{\\sqrt{3}}{2} T_1 = mg \\] and so \\[ T_1 = \\frac{2 m g}{1+ \\sqrt{3}} \\]", :is_document=>false, :event_token=>"136607199"},
  {:id=>261955589, :content=>"These types of problems are known as \"static equilibrium\" problems, and can always be solved by \n\\begin{align} &\\text{1). Drawing the free body diagram, } \\\\ \n&\\text{2). Writing down the sum of the forces in the \\( \\uvec x \\) and \\( \\uvec y \\) directions (which are equal to zero, because the mass is not accelerating), and} \\\\ \n&\\text{3). Solving for the desired quantities.} \\end{align}", :is_document=>false, :event_token=>"157174521"},
  {:id=>139367238, :content=>"Plugging back in and solving for \\( T_2 \\), we see \\[ \\frac{1}{2} T_1 = \\frac{\\sqrt{2}}{2} T_2 \\rightarrow \\] \\[ T_2 = \\frac{T_1}{\\sqrt{2}} \\]", :is_document=>false, :event_token=>"285234283"},
  {:id=>25465479, :content=>"Same problem, but using a clever vector addition trick! We know from Newton's 2nd law that \\[ \\mathbf T_1 + \\mathbf T_2 + m \\mathbf g = 0 \\] If we flip the vector \\( m \\mathbf g \\) over, we get a figure which allows us to easily calculate \\( T_1 \\) and \\( T_2 \\) by taking the projection of \\( m \\mathbf g \\) onto each of these rays.", :is_document=>false, :event_token=>"197322274"},
  {:id=>60301128, :content=>"End of example.", :is_document=>false, :event_token=>"12712793"},
  {:id=>9393117, :content=>"MIT: Weight and Weightlessness", :is_document=>false, :event_token=>"174926623"},
  {:id=>309213445, :content=>" If you stand on a bathroom scale, you exert a force \\( \\mathbf F = m \\mathbf g \\) on the scale (measured in Newtons, \\(  \\units{N} \\) ). Weight is defined as the force that the scale exerts on you, \\( \\mathbf F_s \\), in accordance with Newton's 3rd law.", :is_document=>false, :event_token=>"287165724"},
  {:id=>276076668, :content=>"You are in an elevator rising with an acceleration of \\(\\mathbf a\\). Gravity exerts a downward force \\( \\mathbf F_g = mg \\) on you, and the scale exerts an upward force \\( \\mathbf F_s \\) on you.", :is_document=>false, :event_token=>"176898060"},
  {:id=>124981686, :content=>"Acceleration due to gravity: \\[ g = + 9.8 \\unitsf{m}{s^2} \\]\nConventionally, the gravitational acceleration constant \\( g \\) is always positive, but make sure you keep track of direction when you solve problems! The gravitational force always points straight down.", :is_document=>false, :event_token=>"173703560"},
  {:id=>231182618, :content=>"Use Newton's second law: \\[ \\mathbf{F_s} - m\\mathbf{g} = m\\mathbf{a}\\]", :is_document=>false, :event_token=>"124384363"}
)
# BREAK EVAL
Note.seed(:id,
  {:id=>164697017, :content=>"Rising in an elevator (where upwards \\(\\mathbf a\\) is positive): \\[ \\mathbf{F_s} = m(\\mathbf a +\\mathbf g)\\]", :is_document=>false, :event_token=>"285195126"},
  {:id=>73425319, :content=>"Your *apparent weight* is \\( \\mathbf F_s \\). This is the normal force exerted by the scale! Thus, in an accelerating elevator, you gain weight (even though your mass stays the same).", :is_document=>false, :event_token=>"85010025"},
  {:id=>68841658, :content=>"Falling in an elevator (where downwards \\(\\mathbf a\\) is positive): \\begin{align*} m\\mathbf{g} - \\mathbf{F_s}  &= m\\mathbf{a}  \\\\ \\mathbf{F_s} &= m(\\mathbf g - \\mathbf a) \\end{align*}", :is_document=>false, :event_token=>"101505297"},
  {:id=>285906942, :content=>"In free fall, where \\(\\mathbf a = \\mathbf g\\), you will be weightless.", :is_document=>false, :event_token=>"283991346"},
  {:id=>168858734, :content=>"Defintion of free fall: When the forces acting on a body are exclusively gravitational.", :is_document=>false, :event_token=>"104452923"},
  {:id=>137234631, :content=>"We can equivalently measure weight by a tensional force required to support our body -- it makes no difference whether the weight force ( \\( \\mathbf F_w \\) ) is supplied by the normal force from a scale, or by a tensional force in a rope.", :is_document=>false, :event_token=>"221987861"},
  {:id=>158449131, :content=>"Imagine that you are hanging onto a string attached to a tension scale on the ceiling of an elevator. The tension in the string is \\( T \\), and the acceleration upwards is \\( a \\): \\begin{align*} \\mathbf T - m\\mathbf g = m\\mathbf a \\\\ T = m(\\mathbf a + \\mathbf g) \\end{align*}. This is the same equation that we got with the bathroom scale. Tension is an indicator of weight.", :is_document=>false, :event_token=>"40203528"},
  {:id=>256743749, :content=>"End of introduction to weight", :is_document=>false, :event_token=>"281803260"},
  {:id=>84723387, :content=>"Begin example of ice sliding down an incline", :is_document=>false, :event_token=>"81028203"},
  {:id=>187494301, :content=>"Problem setup: A block of ice with mass \\( m = 10 \\units{kg} \\) is sitting on a wedge (also made of ice) with an angle of \\( \\theta = 30^\\circ \\) to the ground. We want to calculate the motion of the block.", :is_document=>false, :event_token=>"22167502"},
  {:id=>15921741, :content=>"Force of gravity \\( F_g = m g \\) points downward, and acts at the center of mass of the block.", :is_document=>false, :event_token=>"59248961"},
  {:id=>22815496, :content=>"Because motion will be along the surface of the block, we decompose the force of gravity into components that are perpendicular and parallel to the surface of the block.", :is_document=>false, :event_token=>"92656229"},
  {:id=>75748925, :content=>"Using some trig, we find that the component of \\( F_g \\) that is perpendicular to the surface is \\[ F_{g,\\perp} = F_g \\cos \\theta = m g \\cos \\theta \\]", :is_document=>false, :event_token=>"46488390"},
  {:id=>203560269, :content=>"Similarly, the parallel component is \\[ F_{g,\\parallel} = F_g \\sin \\theta = m g \\sin \\theta \\]", :is_document=>false, :event_token=>"57176714"},
  {:id=>217888596, :content=>"A good mnemonic for this is \"Sine Slides\" -- you use \"Sine\" to get the component that would cause the block to \"Slide\" along the wedge.", :is_document=>false, :event_token=>"276708212"},
  {:id=>47336095, :content=>"Another good way to figure out which trig function to use is by limiting cases. As \\( \\theta \\rightarrow 0 \\), there should be no component parallel to the surface, because the block would be sitting on flat ground. Since \\( \\sin 0 = 0 \\) while \\( \\cos 0 = 1 \\), we want to use sine for the parallel component.", :is_document=>false, :event_token=>"75044663"},
  {:id=>202157704, :content=>"If the component of the gravitational force \\( F_{g,\\perp} \\) were the only force acting perpendicular to the plane of the wedge, then by Newton's 2nd law the block would accelerate downward into the wedge. Because this does not happen, there must be another force opposing it. This is the *Normal Force*.", :is_document=>false, :event_token=>"208552556"},
  {:id=>224232018, :content=>"The normal force \\( F_N \\) is always normal (perpendicular) to the surface, and here we reasoned it must oppose the perpendicular component of \\( F_g \\). Thus, \n\\[ F_N = - F_{g,\\perp} = m g \\cos \\theta \\text{ outward } \\]", :is_document=>false, :event_token=>"219270959"},
  {:id=>121281437, :content=>"There is no frictional force opposing \\( F_{g,\\parallel} \\), and so the block will experience an acceleration by Newton's 2nd law.", :is_document=>false, :event_token=>"34630194"},
  {:id=>36337823, :content=>"\\[ \\mathbf F = m \\mathbf a \\rightarrow F_{g, \\parallel} = m a \\]\n\\[ m g \\sin \\theta = m a \\rightarrow \\]\n\\[ a = g \\sin \\theta \\]", :is_document=>false, :event_token=>"16604257"},
  {:id=>227420531, :content=>"Notice that the acceleration is independent of the mass of the block! This is because the force due to gravity is proportional to the mass while the acceleration is inversely proportional to the mass, and so the mass of the block drops out of our equation entirely.", :is_document=>false, :event_token=>"155969033"},
  {:id=>41506165, :content=>"End of example", :is_document=>false, :event_token=>"276226874"},
  {:id=>108077592, :content=>"Kinematics motion in 3-D space", :is_document=>false, :event_token=>"169534600"},
  {:id=>291970279, :content=>"In general, the \"position\" of an object is designated by a vector (in three dimensions), and is given the variable \\( \\mathbf r \\).", :is_document=>false, :event_token=>"67694393"},
  {:id=>123067807, :content=>"\\[ mathbf r_t = x_t \\uvec x + y_t \\uvec y + z_t \\uvec z \\]", :is_document=>false, :event_token=>"152962491"},
  {:id=>279392128, :content=>"\\[ \\mathbf v_t = \\frac{dr_t}{dt} = \\dot x_t \\uvec x + \\dot y_t \\uvec y + \\dot z_t \\uvec z \\]", :is_document=>false, :event_token=>"181164216"},
  {:id=>298204964, :content=>"\\[ \\mathbf a_t = \\frac{dv_t}{dt} = \\ddot x_t \\uvec x + \\ddot y_t \\uvec y + ddot z_t \\uvec z \\]", :is_document=>false, :event_token=>"94445901"},
  {:id=>143586464, :content=>"By writing the 3-D motion in terms of vector components, we have broken a complex problem into three simpler 1-D problems!", :is_document=>false, :event_token=>"55709502"},
  {:id=>108034538, :content=>"When solving kinematics problems, you'll almost always want to break things up into components -- separate equations for each direction. First though, it is *very* important to define your coordinate system! This way, both you and your professor/grader know which direction is \\( + \\uvec x \\), say, and which direction is \\( - \\uvec x \\).", :is_document=>false, :event_token=>"191342231"},
  {:id=>211231408, :content=>"Overview of kinematics", :is_document=>false, :event_token=>"60517513"},
  {:id=>238823117, :content=>"For complex 3-D motion, decompose the motion (always described by the position vector, \\( \\mathbf r(t) \\) ) into three independent 1-D problems along the \\( \\uvec x, \\uvec y \\) and \\( \\uvec z \\) axes. We can then use the standard kinematics equations to solve!", :is_document=>false, :event_token=>"40507597"},
  {:id=>110257213, :content=>"End of 3-D kinematics", :is_document=>false, :event_token=>"221320359"},
  {:id=>191164106, :content=>"Example - Projectile motion in a plane", :is_document=>false, :event_token=>"269496267"},
  {:id=>185752220, :content=>"1D motion, constant acceleration equations: \n\\begin{align} x(t) &= x_0 + v_{0,x} t + frac{1}{2}a_{x} t^2 \\\\ \nv_{x}(t) &= v_{0,x} + a_x t \\\\ \na_{x}(t) &= a_x \\end{align}", :is_document=>false, :event_token=>"60704488"},
  {:id=>250986758, :content=>"It can be useful to analyze the motion of objects with regard to only one axis at a time. This is one reason why it is important to choose your coordinate system well at the start of the problem", :is_document=>false, :event_token=>"291607341"},
  {:id=>256351736, :content=>"Acceleration due to gravity only affects velocity in the y direction", :is_document=>false, :event_token=>"12399312"},
  {:id=>136567657, :content=>"Demonstration of independence of movement in several axes", :is_document=>false, :event_token=>"296387404"},
  {:id=>232191070, :content=>"End of example on projectile motion.", :is_document=>false, :event_token=>"103768256"},
  {:id=>225231438, :content=>"A young monkey is in a tree, searching for tasty bananas. On the ground, a monkey hunter aims a golf ball gun straight at the monkey. The golf ball leaves the the gun at a velocity \\( v_0 \\), and lands at point P. When the monkey sees the flash of the gun, it lets go of the branch it is hanging from and begins to fall. Is the monkey safe, or is it the last day for the monkey?", :is_document=>false, :event_token=>"38649640"},
  {:id=>75132936, :content=>"The ball's horizontal position at time \\( t \\) is not affected by the existence of gravity. The position \\( x(t_1) \\) of the ball at time \\( t_1 \\) is the same for the hunter's assumed trajectory, which ignores gravity, and its actual trajectory, which is affected by gravity.", :is_document=>false, :event_token=>"171484825"},
  {:id=>88164470, :content=>"The \\( y \\)-position of the ball can cleverly found by finding the difference in \\( y \\)-value between the assumed trajectory (no gravity) and the actual trajectory (with gravity).", :is_document=>false, :event_token=>"130231397"},
  {:id=>3540003, :content=>"With gravity, the y-position is:\n\\[ y(t) = \\left[ v_0\\sin(\\alpha) \\right] t - \\frac{1}{2}gt^2 \\]", :is_document=>false, :event_token=>"210767595"},
  {:id=>99995036, :content=>"Without gravity, we no longer have a force in the \\( \\uvec y \\)-direction and hence no acceleration in the \\( \\uvec y \\)-direction. Thus, \\( g \\rightarrow 0 \\) and\n\\[ y(t) = \\left[ v_0\\sin(\\alpha) \\right] t \\]", :is_document=>false, :event_token=>"23024864"},
  {:id=>119509056, :content=>"The ball will land \\( \\frac{1}{2}g{t_2}^2\\)  below the monkey's original position. That is exactly the same distance that the monkey will fall if it lets go at exactly \\(t_0\\)! If it lets go, the monkey will be killed :-(", :is_document=>false, :event_token=>"67815091"},
  {:id=>59873847, :content=>"This result is independent of the initial velocity of the gun!", :is_document=>false, :event_token=>"14547174"},
  {:id=>71267343, :content=>"Consider the same situation, except that both the monkey and the hunter are in an elevator undergoing free-fall motion, and so also accelerating at \\( 9.8 \\units{m/s^2} \\). In this case, the bullet will come straight at the monkey since the force of gravity is acting on all of them, not just the bullet, and so they are all accelerating at the same rate.", :is_document=>false, :event_token=>"249611867"},
  {:id=>163394925, :content=>"If the horizontal distance between the hunter and the monkey is \\( D \\) and the height of the tree is \\( h \\), the length of the trajectory in the monkey-hunter frame is \\( \\sqrt{D^2 + h^2} \\).", :is_document=>false, :event_token=>"277591876"},
  {:id=>141968367, :content=>"In the inertial frame of the classroom (outside the elevator), we see a different picture! We see the bullet traveling with a horizontal velocity \\( v_x = v_0 \\cos \\alpha \\), over a distance \\( D \\). Thus, we calculate \\[ t_{\\text{kill}} = \\frac{D}{v_0 \\cos \\alpha} \\]", :is_document=>false, :event_token=>"143222733"},
  {:id=>235934003, :content=>"Using \\( \\cos \\alpha = \\frac{D}{sqrt{D^2 + h^2}} \\) from the geometry of the image, we can see that both values for \\(t_{\\text{kill}}\\) turn out identical!", :is_document=>false, :event_token=>"143006365"},
  {:id=>36156051, :content=>"\\(t_{kill}\\) should be the same regardless of the chosen reference frame.", :is_document=>false, :event_token=>"281752147"},
  {:id=>28013792, :content=>"Uniform circular motion - An object goes around in a circle at some radius \\( r \\) with some angular frequency \\( \\omega \\).", :is_document=>false, :event_token=>"223193833"},
  {:id=>168014715, :content=>"The velocity is always tangential to the circle. As the object moves around in a circle, the velocity is changing (because it is a vector quantity, and its direction is changing) but the speed remains constant for *uniform* circular motion.", :is_document=>false, :event_token=>"292010468"},
  {:id=>105062910, :content=>"Period - The time it takes for one complete revolution. Written \\( T \\), and measured in seconds.", :is_document=>false, :event_token=>"296759584"},
  {:id=>105684397, :content=>"Frequency - The number of rotations per second. Written \\( f \\) or \\( \\nu \\), and measured in \\( \\units{s^{-1}} \\equiv \\units{Hertz} \\). \n\\[ f = \\frac{1}{T} \\]", :is_document=>false, :event_token=>"166917205"},
  {:id=>226213200, :content=>"Angular Velocity - The number of radians per second (analogous to velocity, with \"distance\" being measured in \"radians\"). Written \\( \\omega \\), and measured in \\( \\units{s^{-1}} \\), or Herts. \\[ \\omega = 2 \\pi f  = \\frac{2 \\pi}{T} \\]", :is_document=>false, :event_token=>"195445452"},
  {:id=>96264614, :content=>"\\[ v = \\omega r \\]", :is_document=>false, :event_token=>"288950418"},
  {:id=>60261487, :content=>"The speed of the rotating object is not changing, but the velocity is! Therefore, there *must* be an acceleration, this is \"non-negotiable.\"", :is_document=>false, :event_token=>"19227978"},
  {:id=>251941684, :content=>"The acceleration is always directed to the center.", :is_document=>false, :event_token=>"17170176"},
  {:id=>281382373, :content=>"The acceleration is called \"centripital acceleration\", \\( a_c \\), and one can show that \n\\[ \\mathbf a_c = \\frac{v^2}{r} \\text{ towards the center } \\]", :is_document=>false, :event_token=>"252466525"},
  {:id=>83817977, :content=>"\\[ \\begin{align} a_c &= \\frac{v^2}{r} \\\\\nv &= \\omega r \\rightarrow \\\\\na_c = \\frac{(\\omega r)^2}{r} = \\omega^2 r \n\\end{align} \\]", :is_document=>false, :event_token=>"271271210"},
  {:id=>283049760, :content=>"\"Centripetal acceleration\" is the name of *any* acceleration towards the center of the circle. Later we'll discuss \"centripetal force\", which is just the *name* of *whatever force(s)* point towards the center! Thus, it is best to think of \"centripetal\" as a direction. Just like \"normal\" refers to the perpendicular direction, \"centripetal\" refers to the direction towards the center of the circle.", :is_document=>false, :event_token=>"256238061"},
  {:id=>296624477, :content=>"\\( 600 \\units{rpm} \\) translates into \\[ 600 \\unitsf{rotations}{minute} \\cdot \\unitsf{1 minute}{60 seconds} \\rightarrow 10 \\units{Hz} \\]", :is_document=>false, :event_token=>"153175245"},
  {:id=>8557465, :content=>"The period is \\[ T = \\frac{1}{f} = \\frac{1}{10} \\units{sec} \\]", :is_document=>false, :event_token=>"238415818"},
  {:id=>38228776, :content=>"The angular velocity is \\[ \\omega = \\frac{2\\pi}{T} = 2 \\pi f \\approx 63 \\unitsf{rad}{sec} \\]", :is_document=>false, :event_token=>"200247387"},
  {:id=>182273285, :content=>"The speed, \\( v \\), is just \\[ v = \\omega r \\approx 6.3 \\units{m}{s} \\]", :is_document=>false, :event_token=>"196937274"},
  {:id=>64056278, :content=>"The centripetal acceleration is \\( a_c = \\omega^2 r = \\frac{v^2}{r} \\) and so\n\\[ a_c = \\omega^2 r \\approx 400 \\unitsf{m}{s^2} \\] This is enormous!", :is_document=>false, :event_token=>"241189649"},
  {:id=>240707030, :content=>"Be careful! The centripetal acceleration is *linear* in the radius \\( r \\) -- \\( a_c = \\omega^2 r \\). It is *not* inversely proportional to \\( r \\), as you might guess from the relation \\( a_c = \\frac{v^2}{r} \\). This is because the velocity is proportional to \\( r \\) -- If you are sitting at the center of a rotating disk, you would have zero velocity.", :is_document=>false, :event_token=>"268386969"},
  {:id=>10670306, :content=>"END of introduction to centripetal acceleration", :is_document=>false, :event_token=>"195694347"},
  {:id=>195020315, :content=>"Begin introduction to centripetal force", :is_document=>false, :event_token=>"107402498"},
  {:id=>182040612, :content=>"Imagine you are sitting on a turntable rotating at angular velocity \\( \\omega \\) at a distance \\( r \\) from the center.", :is_document=>false, :event_token=>"174735839"},
  {:id=>69022216, :content=>"You must experience a centripetal acceleration \\( a_c = \\omega^2 r \\), this is non-negotiable because your velocity is changing!", :is_document=>false, :event_token=>"219049811"},
  {:id=>173106327, :content=>"This centripetal acceleration must come from somewhere -- By Newton's 2nd law, accelerations must be caused by a force! Your chair is bolted to the turntable, so that force is supplied by some contact force between you and the chair/turntable.", :is_document=>false, :event_token=>"227151781"},
  {:id=>182233277, :content=>"The force that causes your circular motion is called the \"centripetal force.\" *Centripetal* means \"towards the center,\" that is, it is the force directed towards the center causing your circular acceleration.", :is_document=>false, :event_token=>"123917907"},
  {:id=>76917656, :content=>"If the centripetal force disappears, you will fly off in whatever direction your velocity vector is pointing. That is, you will fly off in a straight line tangent to the circle!", :is_document=>false, :event_token=>"65541609"},
  {:id=>21693782, :content=>"Demonstration of circular motion.", :is_document=>false, :event_token=>"256021041"},
  {:id=>237755702, :content=>"END of introduction to centripetal force", :is_document=>false, :event_token=>"154117809"}
)
# End auto-generated file.
