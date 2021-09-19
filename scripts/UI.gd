extends CanvasLayer
class_name UI

signal birth_ant(ant)

onready var ant_list = $AntDetails/list
onready var ants = ant_list.get_children();

onready var ant_editor = $AntEditor

func _ready():
	for ant in ants:
		ant.connect("open_ant_editor", self, "open_ant_editor")
		ant.connect("birth_ant", self, "on_birth_ant")

func open_ant_editor(ant: AntSelector):
	ant_editor.open_for(ant)

func on_birth_ant(ant):
	emit_signal("birth_ant", ant)

func get_context(idx):
	return ants[idx]

func display_food(value):
	$ColonyStats/VBoxContainer/Food/Label.text = "Food: %d Units" % value
