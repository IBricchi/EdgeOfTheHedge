extends KinematicBody2D

onready var idle_sprite : AnimatedSprite = $"Basic Ant Idle"
onready var walk_sprite : AnimatedSprite = $"Basic Ant Walk"
onready var sensor_area : Area2D = $Area2D
onready var sensor : CollisionPolygon2D = $"Area2D/AntSensor"
onready var ant_collider : CollisionPolygon2D = $"AntCollision"

var marker : Resource = preload("res://scenes/marker.tscn")

var context;

var marker_max_time : float = 2
var markers_set : Array = []
var marker_follow_timer : float  = 0
var marker_set_timer : float = 0.4
var idle_timer :float = 1
var desired_direction : Vector2 = Vector2(rand_range(-1,-1),rand_range(-1,1)).normalized()
var home : Node setget set_ant_home 
var speed : float = rand_range(50,70)
var alive : bool = true

var health_max : float = 20
var health : float = health_max
var food_carried :int = 0
var hunger_max : float = rand_range(40.0,50.0)
var hunger : float = hunger_max

enum priority {
	find_food = 0, 
	idle = 1,
	fight = 2,
	go_home = 3
}

var ant_priority : int = priority.find_food


func _ready():
	idle_sprite.visible = true
	walk_sprite.visible = false
	

func _physics_process(delta):
	hunger -= delta

	# if the ant is moving
	if ant_priority != priority.idle :
		if ant_priority != priority.go_home :
			#print(marker_set_timer)
			marker_set_timer -= delta
			if marker_set_timer < 0:
				put_down_marker()
		else:
			marker_follow_timer -= delta
		
		check_sensors()
			
		manage_movement_and_collision( move_and_collide(delta* desired_direction * speed))
		
		# make sure the walk animation is playing and make sure the animation is playing at the correct speed
		if not walk_sprite.visible:
			print("walk sprite not visible")
			walk_sprite.visible = true
			idle_sprite.visible = false
		walk_sprite.frames.set_animation_speed("Walk", 24* delta*speed)
		# rotate the ant
		look_at(position + desired_direction)

	# if the ant isnt moving play the idle animation		
	else:
		idle_timer -= delta
		if idle_timer < 0:
			ant_priority = priority.go_home
			idle_timer = 1
			desired_direction = - desired_direction
		if not idle_sprite.visible:
			walk_sprite.visible = false
			idle_sprite.visible = true
			
	if hunger < 0 or health < 0: 
		if food_carried == 0 :
			ant_death()
		else:
			food_carried -= 1
			hunger = hunger_max
			health = max(health_max, health/2)
	
	
	if hunger < hunger_max / 2 or health < health_max/10:
		priority.go_home
		

func set_ant_home(v):
	home = v

func set_context(context):
	context.connect("context_update", self, "update_context")
	update_context(context)

func update_context(context):
	modulate = context.color

func check_sensors():
	if ant_priority == priority.find_food:
		var min_dist : Vector2 = Vector2(1000,1000)
		for body in sensor_area.get_overlapping_bodies():
			if body.is_in_group("Food"):
				if body.nom_nom_value > 0:
					var dist : Vector2 = body.position - self.position
					if dist.length() < min_dist.length() : 
						min_dist = dist
		if min_dist.length()< 1000:
			desired_direction = min_dist.normalized()
		
	elif ant_priority == priority.go_home:
		for body in sensor_area.get_overlapping_bodies():
			if body.is_in_group("queen"):
				desired_direction = (body.position - position).normalized()
	
	
	
func ant_death():
	self.modulate = Color(0.1,0.1,0.1)
	desired_direction = Vector2.ZERO
	speed = 0
	walk_sprite.stop()
	idle_sprite.stop()
	alive = false
	
	
func put_down_marker():
	if not alive:
		return
	marker_set_timer = marker_max_time
	var m : Node = marker.instance()
	get_parent().add_child(m)
	m.translate(position)
	m.parent = self
	m.set_direction(desired_direction)
	get_parent().markers.append(m)
	markers_set.append(m)	

func eat(food):
	food.gets_eaten()
	if hunger < hunger_max/4 :
		hunger = hunger_max
	elif health < health/3:
		health += 5
	else: 
		food_carried += 1
	ant_priority = priority.idle
	var marknum : int = len(markers_set)
	for i in range(marknum/2, marknum):
		markers_set[i].marktype = 1

func manage_movement_and_collision(res):
	# if the ant collides stop moving
		if res:
			if res.collider.is_in_group("Food"):
				eat(res.collider)
				
			# collide off the wall
			if res.collider.is_in_group("hedge"):
				desired_direction = pow(-1, randi()%2)*Vector2(desired_direction.y, -desired_direction.x)
				if markers_set:
					markers_set[-1].destroy_marker()
				
			if res.collider.is_in_group("queen"):
				reached_home()


func reached_home():
	get_parent().player_food += food_carried
	get_parent().get_node("UI").display_food(get_parent().player_food)
	hunger = hunger_max
	ant_priority = priority.find_food
	# bounce back in the same desired_direction that the ant came from plusminus pi/2
	var rand_angle = atan(desired_direction.y / desired_direction.x) +  rand_range(PI/2, 3/2*PI)
	desired_direction = Vector2(cos(rand_angle), sin(rand_angle))
