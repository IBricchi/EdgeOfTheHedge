extends Control
class_name AntSelector

signal open_ant_editor(ant)

enum Mode{
	gather,
	patrol,
	attack
}

onready var speed = 10
onready var strength = 10
onready var mode = Mode.gather

onready var viewport = $cont/cont/viewport

onready var edit = $cont/edit
onready var edit_button = $cont/edit/cont/Button

onready var mode_label = $cont/cont/controls/mode/Label
onready var mode_button = $cont/cont/controls/mode/cont/Button

func _ready():
	edit_button.connect("button_up", self, "on_edit_pressed")
	mode_button.connect("button_up", self, "on_switch_mode")

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
		Mode.gather:
			mode = Mode.patrol
			mode_label.text = "Patrol"
		Mode.patrol:
			mode = Mode.attack
			mode_label.text = "Attack"
		Mode.attack:
			mode = Mode.gather
			mode_label.text = "Gather"
