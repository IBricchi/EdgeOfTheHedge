extends Area2D


var direction : Vector2 setget set_direction
var parent : Node 

enum type {
	home = 0,
	food = 1,
	enemy = 2,
}


func _ready():
	var t = $Timer
	t.start(30)

func set_direction(dir):
	direction = dir

func _on_marker_body_entered(body):
	if body.is_in_group("ant") :
		if body.ant_priority == body.priority.go_home:
			if body.marker_follow_timer < 0 :
				body.marker_follow_timer = 0
				body.desired_direction = - direction


func _on_Timer_timeout():
	parent.markers_set.erase(self) # remove from ant that set it 
	get_parent().markers.erase(self)# remove from game
	get_parent().remove_child(self)
	queue_free()
