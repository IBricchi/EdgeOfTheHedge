extends Control

onready var exit = $exit

var ant

# cost
var cost setget set_cost
onready var cost_label = $panel/cont/cont/info/data_cont/data/cost
func set_cost(val):
	cost = val
	ant.cost = val
	cost_label.text = "Cost: £{0}".format([val])

# color
var color setget set_color
onready var icon = $panel/cont/cont/info/icon_cont/viewport/Viewport/icon
onready var color_slider = $panel/cont/cont/controls/vals/color
func set_color(val):
	color = val
	ant.color = val
	icon.modulate = val;

# hunger
var hunger setget set_hunger
onready var hunger_label = $panel/cont/cont/info/data_cont/data/hunger
func set_hunger(val):
	hunger = val
	ant.hunger = val;
	hunger_label.text = "Hunger: £{0}".format([val])

# speed
var speed setget set_speed
onready var speed_slider = $panel/cont/cont/controls/vals/speed
func set_speed(val):
	speed = val
	ant.speed = val
	compute_data()

# strength
var strength setget set_strength
onready var strength_slider = $panel/cont/cont/controls/vals/strength
func set_strength(val):
	strength = val
	ant.strength = val
	compute_data()

func _ready():
	exit.connect("button_up", self, "on_close")
	color_slider.connect("value_changed", self, "on_update_color")
	speed_slider.connect("value_changed", self, "on_update_speed")
	strength_slider.connect("value_changed", self, "on_update_strength")

func on_close():
	visible = false

onready var title = $panel/cont/cont/title/Label
func open_for(ant):
	visible = true
	self.ant = ant;
	color = ant.color
	speed = ant.speed
	strength = ant.strength
	title.text = ant.name
	speed_slider.value = ant.speed
	strength_slider.value = ant.strength
	compute_data()

func on_update_color(val):
	self.color = Color.from_hsv(val/255.0, 1, 1)

func on_update_speed(val):
	self.speed = val

func on_update_strength(val):
	self.strength = val

const speed_cost = 0.5
const strength_cost = 0.4
func compute_data():
	self.cost = speed_cost * self.speed + strength_cost * self.strength
	
