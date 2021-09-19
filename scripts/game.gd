extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var queen : Resource = preload("res://scenes/queen.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")
onready var cam : Camera2D = $Camera2D

export var cam_speed = 300

onready var ui = $UI

var ant_home : Vector2 = Vector2(200,150)
var markers : Array = []
var player_food : int = 10
var lettuce_spots : Array = [Vector2(200,400), Vector2(150,850), Vector2(250,890), Vector2(270,1000), Vector2(600,600), Vector2(1500,900), Vector2(1700,300)]

func _ready():
	cam.limit_right = 2040
	cam.limit_bottom = 1150
	cam.limit_top = 0 
	cam.limit_left = 0

	ui.connect("birth_ant", self, "on_birth_ant")
	
	var q = queen.instance()
	add_child(q)
	q.translate(ant_home)
	q.modulate = Color(1,0.1,0.2)
	
	randomize()
	for i in range(30):
		var ant1 = ant.instance()
		add_child(ant1)
		ant1.modulate = Color(0.7,0,0.2)
		ant1.scale /= 2
		ant1.translate( ant_home)
		ant1.set_ant_home(q)
	
		
	for spot in lettuce_spots:
		for i in range(randi()%50):
			var lett = lettuce.instance()
			add_child(lett)
			while lett.move_and_collide(Vector2(10,10)) or lett.move_and_collide(-Vector2(10,10)) :
				var rand_angle = rand_range(0, 2*PI)
				var rand_radius = rand_range(0,50)
				var try_position = spot + rand_radius * Vector2(cos(rand_angle), sin(rand_angle))
				lett.translate(try_position)

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

