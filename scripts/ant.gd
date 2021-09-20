extends KinematicBody2D
class_name Ant

onready var idle_sprite : AnimatedSprite = $"Basic Ant Idle"
onready var walk_sprite : AnimatedSprite = $"Basic Ant Walk"
onready var sensor_area : Area2D = $Area2D
onready var sensor : CollisionPolygon2D = $"Area2D/AntSensor"
onready var ant_collider : CollisionPolygon2D = $"AntCollision"

var marker : Resource = preload("res://scenes/marker.tscn")

signal die
signal add_food(count)

var context;

var marker_max_time : float = 2.5
var markers_set : Array = []
var marker_follow_timer : float  = 0
var marker_set_timer : float = 0.4
var idle_timer : float = 1
var desired_direction : Vector2 = Vector2(rand_range(-1,-1),rand_range(-1,1)).normalized()
var home : Node setget set_ant_home 
var enemy_queen : Node setget set_enemy
var speed : float = rand_range(40,50)

var alive : bool = true
var strength : float = 2

var mode

var health_max : float = 20 setget set_health_max
var health : float = health_max

func set_health_max(val):
	health = health / health_max * val
	health_max = val

var hunger_max : float = 40 setget set_hunger_max

var hunger : float = hunger_max
var hunger_rate : float = 1
func set_hunger_max(val):
	hunger = hunger / hunger_max * val
	hunger_max = val

var food_carried :int = 0

enum priority {
	find_food = 0, 
	idle = 1,
	fight = 2,
	go_home = 3, 
	patrol = 4
}

var ant_priority : int = priority.find_food


func _ready():
	idle_sprite.visible = true
	walk_sprite.visible = false
	

func _physics_process(delta):
	if alive:
		hunger -= delta * hunger_rate;
		
		if hunger < 0: 
				if food_carried == 0 :
					ant_death()
				else:
					food_carried -= 1
					hunger = hunger_max
					ant_priority = priority.idle
					
		if health < 0 :
			ant_death()

		if hunger < hunger_max / 2 or health < health_max/5:
			priority.go_home

		# if the ant is moving
		if ant_priority != priority.idle :
			if ant_priority != priority.go_home :
				#print(marker_set_timer)
				marker_set_timer -= delta
				if marker_set_timer < 0:
					put_down_marker()
			else:
				marker_follow_timer -= delta
			
			check_sensor()
		
			look_at(position + desired_direction)
			manage_movement_and_collision( move_and_collide(delta* desired_direction * 2*speed), delta)
		
			# make sure the walk animation is playing and make sure the animation is playing at the correct speed
			if not walk_sprite.visible:
				walk_sprite.visible = true
				idle_sprite.visible = false
			walk_sprite.frames.set_animation_speed("Walk", speed)
			# rotate the ant
			look_at(position + desired_direction)

		# if the ant isnt moving play the idle animation		
		else:
			idle_timer -= delta
			if idle_timer < 0:
				if food_carried:
					ant_priority = priority.go_home
				else:
					ant_priority = priority.find_food
				idle_timer = 1
				desired_direction = - desired_direction
			if not idle_sprite.visible:
				walk_sprite.visible = false
				idle_sprite.visible = true
			

func set_ant_home(v):
	home = v
	
func set_enemy(e):
	enemy_queen = e

func set_context(context):
	context.connect("context_update", self, "update_context")
	update_context(context)

func update_context(context):
	if alive:
		modulate = context.color

		self.mode = context.mode

		self.speed = context.speed
		self.hunger_max = context.hunger
		self.hunger_rate = context.hunger_rate
		self.strength = context.strength
		self.health_max = context.health

func check_sensor():
	var space_state = get_world_2d().direct_space_state
	
	
	if ant_priority == priority.find_food or ant_priority == priority.patrol:
		var min_dist : Vector2 = Vector2(1000,1000)
		for body in sensor_area.get_overlapping_bodies():
			if body.is_in_group("Food"):
				var result  =space_state.intersect_ray(position, body.position,[self], collision_mask)
				if result and result.collider == body:
					if body.nom_nom_value > 0:
						var dist : Vector2 = body.position - self.position
						if dist.length() < min_dist.length() : 
							min_dist = dist
						
		if min_dist.length()< 1000:
			desired_direction = min_dist.normalized()
			
		else:
			for body in sensor_area.get_overlapping_areas():
				if body.is_in_group("marker"):
					if body.marktype == 1:
						desired_direction = (body.position-position).normalized()
						
	elif ant_priority == priority.go_home :
		for body in sensor_area.get_overlapping_areas():
				if body.is_in_group("marker"):
					if body.marktype == 0:
						desired_direction = (body.position-position).normalized()
						
						
						
		for body in sensor_area.get_overlapping_bodies():
			if body.is_in_group("queen"):
				desired_direction = (body.position - position).normalized()
				
	if ant_priority == priority.fight or ant_priority == priority.patrol:
		for body in sensor_area.get_overlapping_bodies():
			if body == enemy_queen:
				desired_direction = (body.position - position).normalized()
				return
			if body.is_in_group("ant"):
				if body.home != home : 
					var result  =space_state.intersect_ray(position, body.position,[self], collision_mask)
					if result and  result.collider == body:
							desired_direction = (body.position - position).normalized()
					return
		for area in sensor_area.get_overlapping_areas():
			if area.is_in_group("marker"):
				if area.marktype == 2:
					desired_direction = (area.position-position).normalized()
	
	
func fight(enemyant : Node, delta):
	var marknum = len(markers_set)
	for i in range(marknum/2, marknum):
		markers_set[i].set_marker_type(2)
	if enemyant.alive:
		look_at(enemyant.position)
		enemyant.health -=  strength * delta
		if walk_sprite.visible:
			walk_sprite.visible = false
			idle_sprite.visible = true
		# desired_direction = Vector2.ZERO
		# enemyant.desired_direction = Vector2.ZERO
		enemyant.look_at(position)
	else:
		desired_direction = (position - enemyant.position).normalized()
	
func ant_death():
	emit_signal("die")
	self.modulate = Color(0.1,0.1,0.1)
	desired_direction = Vector2.ZERO
	speed = 0
	walk_sprite.stop()
	idle_sprite.stop()
	alive = false
	$AntCollision.disabled = true
	$Timer.start(30)
	
	
func put_down_marker():
	if not alive:
		return
	marker_set_timer = marker_max_time
	var m : Node = marker.instance()
	get_parent().add_child(m)
	m.translate(position)
	m.parent = self
	if markers_set :
		m.set_direction(markers_set[-1].position)
	else: 
		m.set_direction(desired_direction)
	m.set_queen(home)
	markers_set.append(m)	

func eat(food):
	food.gets_eaten()
	if not ant_priority == priority.fight:
		ant_priority = priority.idle
	else: 
		desired_direction *= -1
	if hunger < hunger_max/4 :
		hunger = hunger_max
	elif health < health/3:
		health += 5
	else: 
		food_carried += 4
	var marknum : int = len(markers_set)
	for i in range(marknum/2, marknum):
		markers_set[i].set_marker_type(1)

func manage_movement_and_collision(res, delta):
	# if the ant collides stop moving
		if res:
			if res.collider.is_in_group("Food"):
				eat(res.collider)
				
			# collide off the wall
			if res.collider.is_in_group("hedge"):
				
				desired_direction = (desired_direction.bounce(res.normal)).normalized()
				if markers_set:
					markers_set[-1].destroy_marker()
				
			if res.collider == home:
				reached_home()
			if res.collider == enemy_queen:
				get_parent().queen_attacked(enemy_queen, strength*delta)
				look_at(enemy_queen.position)
				
				
			if res.collider.is_in_group("ant"):
				if res.collider.alive:
					fight(res.collider, delta)
				else:
					desired_direction *= -1 


func reached_home():
	emit_signal("add_food", food_carried)

	hunger = hunger_max
	ant_priority = priority.find_food
	# bounce back in the same desired_direction that the ant came from plusminus pi/2
	food_carried = 0
	var rand_angle = atan(desired_direction.y / desired_direction.x) +  rand_range(PI/2, 3/2*PI)
	desired_direction = Vector2(cos(rand_angle), sin(rand_angle))


func _on_Timer_timeout():
	get_parent().remove_child(self)
	queue_free()
