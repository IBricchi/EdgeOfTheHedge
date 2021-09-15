extends KinematicBody2D


onready var idle_sprite : AnimatedSprite = $"Basic Ant Idle"
onready var walk_sprite : AnimatedSprite = $"Basic Ant Walk"
onready var sensor_area : Area2D = $Area2D
onready var sensor : CollisionPolygon2D = $"Area2D/AntSensor"

var direction : Vector2
var speed : float = 0.4



func _ready():
	randomize()
	direction = Vector2(rand_range(-1,-1),rand_range(-1,1)).normalized()
	idle_sprite.visible = true
	walk_sprite.visible = false


func _physics_process(delta):
	# if the ant is moving
	if direction.length() != 0 :
		var move_collision_result = move_and_collide( direction * speed)
		# if the ant collides stop moving
		if move_collision_result:
			direction = Vector2(0,0)
			return
		# make sure the walk animation is playing and make sure the animation is playing at the correct speed
		if not walk_sprite.visible:
			walk_sprite.visible = true
			idle_sprite.visible = false
		walk_sprite.frames.set_animation_speed("Walk", 24* direction.length())
		# rotate the ant
		rotation = PI + acos(direction.y /direction.length())
		# move towards the closest lettuce that is in range
		for body in sensor_area.get_overlapping_bodies():
			var min_dist : float = INF
			if body.is_in_group("Food"):
				var dist : Vector2 = body.position - position
				if dist.length() < min_dist : 
					direction = (direction + 0.2 * speed* delta*dist).normalized()
					min_dist = dist.length()
	# if the ant isnt moving play the idle animation		
	else:
		if not idle_sprite.visible:
			walk_sprite.visible = false
			idle_sprite.visible = true
		
			


