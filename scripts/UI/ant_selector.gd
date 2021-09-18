extends Control
class_name AntSelector

signal open_ant_editor(ant)
signal birth_ant(ant)

enum Mode{
	gather,
	patrol,
	attack
}

# color

# cost
var cost setget set_cost
onready var cost_label = $cont/cont/controls/birth/Label
func set_cost(val):
	cost = val
	cost_label.text = "£{0}".format([val])	

# speed
var speed

# strength
var strength

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

onready var viewport = $cont/cont/viewport

onready var edit = $cont/edit
onready var edit_button = $cont/edit/cont/Button


onready var birth_button = $cont/cont/controls/birth/cont/Button

func _ready():
	self.cost = 10
	self.speed = 10
	self.strength = 10
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
