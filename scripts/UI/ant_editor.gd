extends Control

onready var exit = $exit
onready var title = $panel/cont/cont/title/Label
onready var speed = $panel/cont/cont/controls/vals/speed
onready var strength = $panel/cont/cont/controls/vals/strength

var ant

func _ready():
	exit.connect("button_up", self, "on_close")
	speed.connect("value_changed", self, "on_update_speed")
	strength.connect("value_changed", self, "on_update_strength")

func on_close():
	visible = false

func open_for(ant):
	visible = true
	self.ant = ant;
	title.text = ant.name
	speed.value = ant.speed
	strength.value = ant.strength

func on_update_speed(val):
	self.ant.speed = speed.value	

func on_update_strength(val):
	self.ant.strength = strength.value
