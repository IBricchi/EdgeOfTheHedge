extends Control

onready var exit = $exit

var ant setget set_ant
func set_ant(val):
	ant = val
	#	IMPORTANT DO NOT DO SELF.VARIABLE so not to actiavte setter function
	color = ant.color
	speed = ant.speed
	strength = ant.strength
	health = ant.health
	hunger = ant.hunger
	
	title.text = ant.name
	color_slider.value = color.h * 255
	speed_slider.value = speed
	strength_slider.value = strength
	health_slider.value = health
	hunger_slider.value = hunger
	compute_data()

# cost
var cost setget set_cost
onready var cost_label = $panel/cont/cont/info/data_cont/data/cost
func set_cost(val):
	cost = int(val)
	ant.cost = int(val)
	cost_label.text = "Cost: %d u" % val

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
onready var hunger_slider = $panel/cont/cont/controls/vals/hunger
func set_hunger(val):
	hunger = val
	ant.hunger = val
	compute_data()
var hunger_rate setget set_hunger_rate
onready var hunger_rate_label = $panel/cont/cont/info/data_cont/data/hunger_rate
func set_hunger_rate(val):
	hunger_rate = val
	ant.hunger_rate = val;
	hunger_rate_label.text = "Hunger: %.2fu/s" % val

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

# health
var health setget set_health
onready var health_slider = $panel/cont/cont/controls/vals/health
func set_health(val):
	health = val
	ant.health = val
	compute_data()

func _ready():
	exit.connect("button_up", self, "on_close")
	color_slider.connect("value_changed", self, "on_update_color")
	speed_slider.connect("value_changed", self, "on_update_speed")
	strength_slider.connect("value_changed", self, "on_update_strength")
	hunger_slider.connect("value_changed", self, "on_update_hunger")
	health_slider.connect("value_changed", self, "on_update_health")

func on_close():
	visible = false

onready var title = $panel/cont/cont/title/Label
func open_for(ant):
	visible = true
	self.ant = ant;

func on_update_color(val):
	self.color = Color.from_hsv(val/255.0, 1, 1)

func on_update_speed(val):
	self.speed = val

func on_update_strength(val):
	self.strength = val

func on_update_hunger(val):
	self.hunger = val

func on_update_health(val):
	self.health = val
	

func compute_data():
	self.cost = (
		self.speed / speed_slider.max_value +
		self.strength / strength_slider.max_value +
		self.hunger / hunger_slider.max_value +
		self.health / health_slider.max_value
	) * 25
	self.hunger_rate = (
		self.speed / speed_slider.max_value +
		self.strength / strength_slider.max_value +
		self.health / health_slider.max_value
	) / 3 * 2
