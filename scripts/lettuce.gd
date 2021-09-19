extends StaticBody2D

var nom_nom_value : int = floor(rand_range(2,6)) # how many times this lettuce can be eaten between 2 and 5

onready var area = $area

func _ready():
	resize_according_to_value()

var x
var y
var r
var xmin
var xmax
var ymin
var ymax
var rng
var settled
var last_move

func setup(x, y, r, xmin, xmax, ymin, ymax, rng):
	self.visible = false
	self.x = x
	self.y = y
	self.r = r
	self.xmin = xmin
	self.xmax = xmax
	self.ymin = ymin
	self.ymax = ymax
	self.rng = rng
	self.settled = false
	self.last_move = 0.5
	move()

func move():
	var lx = clamp(self.x + rng.randfn() * self.r, self.xmin, self.xmax)
	var ly = clamp(self.y + rng.randfn() * self.r, self.ymin, self.ymax)
	self.position = Vector2(lx, ly)
	last_move = 0.5

func _physics_process(delta):
	if not self.settled:
		var objs = area.get_overlapping_bodies()
		if objs:
			for obj in objs:
				if obj.is_in_group("hedge"):
					move()
					break
		last_move -= delta
		if last_move < 0:
			self.settled = true
			self.visible = true

func gets_eaten():
	nom_nom_value -= 1
	resize_according_to_value()
	if not nom_nom_value:
		get_parent().remove_child(self)
		
		queue_free()


func resize_according_to_value():
	self.scale = Vector2(1,1)* 0.2* (nom_nom_value+1)
