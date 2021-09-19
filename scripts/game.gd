extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
onready var cam : Camera2D = $Camera2D

export var cam_speed = 300

onready var ui = $UI

onready var lett_spawner = $LettuceSpawner

var ant_home : Vector2 = Vector2(600,500)

func _ready():
	cam.limit_right = 2040
	cam.limit_bottom = 1150
	cam.limit_top = 0 
	cam.limit_left = 0

	ui.connect("birth_ant", self, "on_birth_ant")
	
	for i in range(4):
		var ant1 = ant.instance()
		add_child(ant1)
		ant1.translate( ant_home)
		ant1.set_ant_home(ant_home)
	
	lett_spawner.setup(0,2048,0,1152,10,50,10)
	for n in 5:
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

