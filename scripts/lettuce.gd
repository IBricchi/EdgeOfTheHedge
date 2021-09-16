extends KinematicBody2D

var nom_nom_value : int = floor(rand_range(2,6)) # how many times this lettuce can be eatenm between 2 and 5


func _ready():
	resize_according_to_value()



func _process(delta):
	pass
	
	
func gets_eaten():
	nom_nom_value -= 1
	resize_according_to_value()
	if not nom_nom_value:
		get_parent().remove_child(self)
		queue_free()


func resize_according_to_value():
	self.scale = Vector2(1,1)* 0.2* (nom_nom_value+1)
