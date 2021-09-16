extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")



var ant_home : Vector2 = Vector2(300,300)

func _ready():
	randomize()
	var ant1 = ant.instance()
	add_child(ant1)
	for i in range(15):
		var lett = lettuce.instance()
		add_child(lett)
		var random_angle : float = rand_range(0, 2*PI)
		lett.translate(ant_home + 250 * Vector2(cos(random_angle) , sin(random_angle)))
	ant1.translate( ant_home)
	ant1.set_ant_home(ant_home)
	
