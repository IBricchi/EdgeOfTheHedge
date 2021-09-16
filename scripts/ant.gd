extends KinematicBody2D


onready var idle_sprite : AnimatedSprite = $"Basic Ant Idle"
onready var walk_sprite : AnimatedSprite = $"Basic Ant Walk"
onready var sensor_area : Area2D = $Area2D
onready var sensor : CollisionPolygon2D = $"Area2D/AntSensor"

var direction : Vector2
var home : Node setget set_ant_home 
var speed : float = 1


enum priority {
	find_food = 0, 
	wander = 1,
	fight = 2,
	run_away = 3
}

enum activity {
	walking,
	idle
}

var ant_priority : int = priority.find_food
var focus : Node = null # focus is the node the ant wants to get to, food, enemy, home, etc

func _ready():
	randomize()
	direction = Vector2(rand_range(-1,-1),rand_range(-1,1)).normalized()
	idle_sprite.visible = true
	walk_sprite.visible = false
	

func _physics_process(delta):
	# if the ant is moving
	if direction.length() != 0 :
		if focus :
			var to_focus : Vector2 = focus.position - self.position
			direction = (direction + 0.1 * speed* delta*to_focus).normalized()
			
		var move_collision_result = move_and_collide( direction * speed)
		# if the ant collides stop moving
		if move_collision_result:
			direction = Vector2(0,0)
			if move_collision_result.collider == focus:
				focus_reached()
			return
		# make sure the walk animation is playing and make sure the animation is playing at the correct speed
		if not walk_sprite.visible:
			walk_sprite.visible = true
			idle_sprite.visible = false
		walk_sprite.frames.set_animation_speed("Walk", 24* direction.length())
		# rotate the ant
		look_at(position + direction)
		
		if focus == home:
			if (home.position - position).length() < 5:
				reached_home()
		
		if not focus and ant_priority == priority.find_food : 
			# set closest lettuce as focus
			var min_dist : float = 3.402823e+38 # positive infinity (actually using INF doesn't work and I have no idea why)
			for body in sensor_area.get_overlapping_bodies():
				if body.is_in_group("Food"):
					var dist : Vector2 = body.position - self.position
					if dist.length() < min_dist : 
						focus = body
						min_dist = dist.length()
						
	# if the ant isnt moving play the idle animation		
	else:
		if not idle_sprite.visible:
			walk_sprite.visible = false
			idle_sprite.visible = true
			
		
		
		
func focus_reached():
	if focus.is_in_group("Food"):
		focus.gets_eaten()
	focus = home
	
	#rotation -= PI
	var to_focus : Vector2 = focus.position - self.position
	direction = to_focus.normalized()

func set_ant_home(vect):
	home = Node2D.new()
	home.position = vect
	
	
func reached_home():
	focus = null
	# bounce back in the same direction that the ant came from plusminus pi/2
	var rand_angle = atan(direction.y / direction.x) +  rand_range(PI/2, 3/2*PI)
	direction = Vector2(cos(rand_angle), sin(rand_angle))
