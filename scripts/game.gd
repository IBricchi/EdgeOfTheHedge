extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")

func _ready():
	randomize()
	var ant1 = ant.instance()
	add_child(ant1)
	for i in range(20):
		var lett = lettuce.instance()
		add_child(lett)
		lett.translate(Vector2(rand_range(0,800),rand_range(0,800)))
	ant1.translate( Vector2(500,200))
	
