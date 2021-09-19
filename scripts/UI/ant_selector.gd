extends Control
class_name AntSelector

signal open_ant_editor(ant)
signal birth_ant(ant)
signal context_update(ant)

enum Mode{
	gather,
	patrol,
	attack
}

# cost
var cost setget set_cost
onready var cost_label = $cont/cont/controls/birth/Label
func set_cost(val):
	cost = val
	cost_label.text = "£{0}".format([val])
	emit_signal("context_update", self)

# hunger
var hunger setget set_hunger
func set_hunger(val):
	hunger = val
	emit_signal("context_update", self)

var hunger_rate setget set_hunger_rate
func set_hunger_rate(val):
	hunger_rate = val
	emit_signal("context_update", self)

# color
var color setget set_color
onready var icon = $cont/cont/viewport/Viewport/icon
func set_color(val):
	color = val
	icon.modulate = val
	emit_signal("context_update", self)

# speed
var speed setget set_speed
func set_speed(val):
	speed = val
	emit_signal("context_update", self)

# strength
var strength setget set_strength
func set_strength(val):
	strength = val
	emit_signal("context_update", self)

# health
var health setget set_health
func set_health(val):
	health = val
	emit_signal("context_update", self)

# mode
var mode = Mode.gather setget set_mode
onready var mode_label = $cont/cont/controls/mode/Label
onready var mode_button = $cont/cont/controls/mode/cont/Button
func set_mode(val):
	mode = val
	match val:
		Mode.gather: mode_label.text = "Gather"
		Mode.patrol: mode_label.text = "Patrol"
		Mode.attack: mode_label.text = "Attack"
	emit_signal("context_update", self)

onready var viewport = $cont/cont/viewport

onready var edit = $cont/edit
onready var edit_button = $cont/edit/cont/Button


onready var birth_button = $cont/cont/controls/birth/cont/Button

func _ready():
	self.cost = 10
	self.hunger = 10
	self.hunger_rate = 1
	self.color = Color.from_hsv(0.01,1,1)
	self.speed = 30
	self.strength = 10
	self.health = 10
	self.mode = Mode.gather
	
	edit_button.connect("button_up", self, "on_edit_pressed")
	mode_button.connect("button_up", self, "on_switch_mode")
	birth_button.connect("button_up", self, "on_birth_ant")

func _process(delta):
	var hovereing = viewport.get_global_rect().has_point(.get_global_mouse_position());
	if hovereing:
		edit.visible = true;
	else:
		edit.visible = false;

func on_edit_pressed():
	emit_signal("open_ant_editor", self)

func on_switch_mode():
	match mode:
		Mode.gather: self.mode = Mode.patrol
		Mode.patrol: self.mode = Mode.attack
		Mode.attack: self.mode = Mode.gather

func on_birth_ant():
	emit_signal("birth_ant", self)
