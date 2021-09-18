extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var queen : Resource = preload("res://scenes/queen.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")
onready var cam : Camera2D = $Camera2D

export var cam_speed = 300

onready var ui = $UI

var ant_home : Vector2 = Vector2(600,500)

func _ready():
	cam.limit_right = 2040
	cam.limit_bottom = 1150
	cam.limit_top = 0 
	cam.limit_left = 0

	ui.connect("birth_ant", self, "on_birth_ant")
	
	randomize()
	for i in range(4):
		var ant1 = ant.instance()
		add_child(ant1)
		ant1.translate( ant_home)
		ant1.set_ant_home(ant_home)
	
	var q = queen.instance()
	add_child(q)
	q.translate(ant_home)
		
	for i in range(200):
		var lett = lettuce.instance()
		add_child(lett)
		while lett.move_and_collide(Vector2(1,1)) :
			var try_position = Vector2(randi()%2000 , randi() %1100)
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

