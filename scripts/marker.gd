extends Area2D


var direction : Vector2 setget set_direction
var parent : Node 

enum type {
	home = 0,
	food = 1,
	enemy = 2,
}
var queen setget set_queen
func set_queen(q):
	queen = q

var marktype = type.home
var checked = false
var lastcheck  = 3

func _process(delta):
	for area in get_overlapping_areas():
		if area.is_in_group("marker") and queen == area.queen and marktype == area.marktype and not checked:
			destroy_marker()
			area.checked = true
	lastcheck -= delta
	if lastcheck < 0 : 
		lastcheck = 4
		checked = false


func _ready():
	$Timer.start(20)
	

func set_direction(dir):
	direction = dir

func _on_marker_body_entered(body):
	if body.is_in_group("ant") :
		if body.marker_follow_timer < 0 and body.home == queen:
			if body.ant_priority == 3:
				body.desired_direction = - direction
				body.marker_follow_timer = 0.5
			if  body.ant_priority == 1 and marktype == type.food:
				body.desired_direction = direction
				body.marker_follow_timer = 0.5
			if body.ant_priority == 2 and marktype == type.enemy:
				body.desired_direction = direction
				body.marker_follow_timer = 0.5


func set_marker_type(type):
	marktype = type
	$Timer.start(30)

func _on_Timer_timeout():
	destroy_marker()
	
	
func destroy_marker():
	if parent != null:
		parent.markers_set.erase(self) # remove from ant that set it 
	queue_free()
