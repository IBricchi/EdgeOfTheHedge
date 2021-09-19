extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var queen : Resource = preload("res://scenes/queen.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")
onready var cam : Camera2D = $Camera2D

export var cam_speed = 300
export var starting_ants = 50

onready var ui = $UI

onready var lett_spawner = $LettuceSpawner

var ant_home : Vector2 = Vector2(80,80)
var markers : Array = []
var player_food : int = 10

func _ready():
	cam.limit_right = 2048
	cam.limit_bottom = 1152
	cam.limit_top = 0 
	cam.limit_left = 0

	ui.connect("birth_ant", self, "on_birth_ant")
	
	var playerqueen = queen.instance()
	add_child(playerqueen)
	playerqueen.translate(ant_home)
	playerqueen.modulate = Color(1,0.1,0.2)
	
	randomize()
	for i in range(starting_ants):
		var ant1 = ant.instance()
		add_child(ant1)
		ant1.modulate = Color(0.7,0,0.2)
		ant1.scale /= 2
		ant1.translate( ant_home + Vector2(20,20))
		ant1.set_ant_home(playerqueen)
		ant1.set_collision_layer_bit(4, true)
		ant1.set_collision_mask_bit(3 , true)
		
	ant_home = Vector2(1975, 1080)
	
	var enemyqueen = queen.instance()
	add_child(enemyqueen)
	enemyqueen.translate(ant_home)
	enemyqueen.modulate = Color(0.3,0.05,0.1)
	
	for i in range(starting_ants):
		var ant1 = ant.instance()
		add_child(ant1)
		ant1.modulate = Color(0.25,0.05,0.1)
		ant1.scale /= 2
		ant1.translate( ant_home - Vector2(20,20))
		ant1.set_ant_home(enemyqueen)
		ant1.set_collision_layer_bit(3, true)
		ant1.set_collision_mask_bit(4 , true)
		
		
	playerqueen.look_at(enemyqueen.position)	
	enemyqueen.look_at(playerqueen.position)
	
		
	lett_spawner.setup(0,2048,0,1152,10,50,10)
	for n in 25:
		lett_spawner.spawn_bunch()

func _process(delta):
	if Input.is_action_pressed("camera_bottom"):
		cam.position.y += cam_speed*delta
	if Input.is_action_pressed("camera_left"):
		cam.position.x -= cam_speed*delta
	if Input.is_action_pressed("camera_right"):
		cam.position.x += cam_speed*delta
	if Input.is_action_pressed("camera_top"):
		cam.position.y -= cam_speed *delta


func on_birth_ant(context):
	var ant_inst = ant.instance()
	add_child(ant_inst)
	ant_inst.translate(ant_home)
	ant_inst.set_ant_home(ant_home)
	ant_inst.set_context(context)

