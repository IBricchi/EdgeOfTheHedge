extends Camera2D

export var cam_speed = 300

func _ready():
	limit_right = 2040
	limit_bottom = 1150
	limit_top = 0 
	limit_left = 0

func _process(delta):
	if Input.is_action_pressed("camera_bottom"):
		position.y += cam_speed*delta
	if Input.is_action_pressed("camera_left"):
		position.x -= cam_speed*delta
	if Input.is_action_pressed("camera_right"):
		position.x += cam_speed*delta
	if Input.is_action_pressed("camera_top"):
		position.y -= cam_speed *delta
