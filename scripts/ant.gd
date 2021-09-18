extends KinematicBody2D

onready var idle_sprite : AnimatedSprite = $"Basic Ant Idle"
onready var walk_sprite : AnimatedSprite = $"Basic Ant Walk"
onready var sensor_area : Area2D = $Area2D
onready var sensor : CollisionPolygon2D = $"Area2D/AntSensor"
onready var ray : RayCast2D = $Collisionray

var context;

var desired_direction : Vector2 = Vector2.ZERO
var home : Node setget set_ant_home 
var speed : float = rand_range(2,4)


var hunger_max : float = rand_range(15.0,20.0)
var hunger : float = hunger_max

enum priority {
	find_food = 0, 
	idle = 1,
	fight = 2,
	run_away = 3
}


var ant_priority : int = priority.find_food
var focus : Node = null # focus is the node the ant wants to get to, food, enemy, home, etc
var focus_position : Vector2 


func _ready():
	randomize()
	desired_direction = Vector2(rand_range(-1,-1),rand_range(-1,1)).normalized()
	idle_sprite.visible = true
	walk_sprite.visible = false
	

func _physics_process(delta):
	hunger -= delta
	# if the ant is moving
	if ant_priority != priority.idle :
		
		if focus != null:
			var to_focus : Vector2 = (focus_position - position).normalized()
			desired_direction = (desired_direction +  delta*speed*to_focus).normalized()

		
		var move_collision_result = move_and_collide( desired_direction * speed)
		# if the ant collides stop moving
		if move_collision_result:
			if move_collision_result.collider.is_in_group("Food"):
				focus = move_collision_result.collider
			if move_collision_result.collider == focus:
				focus_reached()
				return
			# collide off the wall
			if move_collision_result.collider.is_in_group("hedge"):
				desired_direction = pow(-1, randi()%2)*Vector2(desired_direction.y, -desired_direction.x)
				focus = null 
		# make sure the walk animation is playing and make sure the animation is playing at the correct speed
		if not walk_sprite.visible:
			walk_sprite.visible = true
			idle_sprite.visible = false
			
			
		walk_sprite.frames.set_animation_speed("Walk", 24* speed)
		# rotate the ant
		look_at(position + desired_direction)
		
		if focus == home:
			if (home.position - position).length() < 1000:
				reached_home()
		
		if not focus and ant_priority == priority.find_food : 
			check_sensors()
	# if the ant isnt moving play the idle animation		
	else:
		if not idle_sprite.visible:
			walk_sprite.visible = false
			idle_sprite.visible = true
			
	if hunger < 0 : 
		ant_death()
	if hunger < hunger_max / 2 :
		focus = home
		
		
		
func check_collision_ray(delta : float):
	# rotate the collision ray and check if it hits something, if it does return vector to it 
	# gonna use this to detect enemies
	ray.rotation += PI * delta * 2 # rotate once a second	
	if ray.is_colliding():
		if focus and  (ray.get_collision_point() - focus_position).length() > 25:
			return ray.get_collision_point() - self.position 
		
func focus_reached():
	if focus.is_in_group("Food"):
		focus.gets_eaten()
		focus = home
		print("going home")
	else: 
		focus = null
	#rotation -= PI
	var to_focus : Vector2 = focus_position - self.position
	desired_direction = to_focus.normalized()



func set_ant_home(vect):
	home = Node2D.new()
	home.position = vect
	
func set_context(context):
	self.context = context
	
func check_sensors():
	# set closest lettuce as focus
	var min_dist : float = 3.402823e+38 # positive infinity (actually using INF doesn't work and I have no idea why)
	for body in sensor_area.get_overlapping_bodies():
		if body.is_in_group("Food"):
			if body.nom_nom_value > 0:
				var dist : Vector2 = body.position - self.position
				if dist.length() < min_dist : 
					focus = body
					focus_position = body.position
					min_dist = dist.length()
					
	
	
func ant_death():
	self.modulate = Color(0.2,0.2,0.2)
	desired_direction = Vector2.ZERO
	speed = 0
	walk_sprite.frames.set_animation_speed("Walk", 0)
	idle_sprite.frames.set_animation_speed("Idle", 0)
	# queue_free
	
func reached_home():
	hunger = hunger_max
	focus = null
	# bounce back in the same desired_direction that the ant came from plusminus pi/2
	var rand_angle = atan(desired_direction.y / desired_direction.x) +  rand_range(PI/2, 3/2*PI)
	desired_direction = Vector2(cos(rand_angle), sin(rand_angle))
