extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")
onready var cam : Camera2D = $Camera2D


var ant_home : Vector2 = Vector2(300,300)

func _ready():
	randomize()
	for i in range(4):
		var ant1 = ant.instance()
		add_child(ant1)
		ant1.translate( ant_home)
		ant1.set_ant_home(ant_home)
	for i in range(15):
		var lett = lettuce.instance()
		add_child(lett)
		var random_angle : float = rand_range(0, 2*PI)
		var try_position = ant_home + 250 * Vector2(cos(random_angle) , sin(random_angle))
		lett.translate(try_position)
		var iter = 0
		while lett.test_move(lett.transform,Vector2.UP):
			try_position.x += randi() % 51 - 25
			try_position.y += randi() % 51 - 25
			lett.translate(try_position)
			
				
		
	
	
