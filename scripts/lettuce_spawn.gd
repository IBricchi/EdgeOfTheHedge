extends Node2D

var lettuce : Resource = preload("res://scenes/lettuce.tscn")

var xmin
var xmax
var ymin
var ymax

var rmin
var rmax

var rate setget set_rate
onready var timer = $Timer
func set_rate(val):
	rate = val
	timer.wait_time = val

onready var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	timer.connect("timeout", self, "spawn_bunch")

func spawn_bunch():
	var x = rng.randf_range(self.xmin, self.xmax)
	var y = rng.randf_range(self.ymin, self.ymax)
	var r = rng.randi_range(self.rmin, self.rmax)
	var c = r * r / 200
	
	for n in range(c):		
		var lett = lettuce.instance()
		lett.setup(x, y, r, xmin, xmax, ymin, ymax, rng)
		add_child(lett)

func setup(xmin, xmax, ymin, ymax, rmin, rmax, rate):
	self.xmin = xmin
	self.xmax = xmax
	self.ymin = ymin
	self.ymax = ymax
	
	self.rmin = rmin
	self.rmax = rmax
	
	self.rate = rate
	timer.start()

