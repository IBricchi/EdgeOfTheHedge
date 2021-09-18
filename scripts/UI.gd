extends CanvasLayer
class_name UI

onready var ant_list = $AntDetails/list
onready var ants = ant_list.get_children();

onready var ant_editor = $AntEditor

func _ready():
	for ant in ants:
		ant.connect("open_ant_editor", self, "open_ant_editor")

func open_ant_editor(ant: AntSelector):
	ant_editor.open_for(ant)
