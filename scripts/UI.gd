extends CanvasLayer
class_name UI

signal birth_ant(ant)

onready var ant_list = $AntDetails/list
onready var ants = ant_list.get_children();

onready var time_label = $ColonyStats/cont/cont/list/Time/Label
onready var population_label = $ColonyStats/cont/cont/list/Population/Label
onready var player_food_label = $ColonyStats/cont/cont/list/PlayerFood/Label

onready var ant_editor = $AntEditor

var time: float = 0 setget set_time
func set_time(val):
	time = val
	time_label.text = "Time: %.0fs" % val

var population: int = 0 setget set_population
func set_population(val):
	population = val
	population_label.text = "Population: %d" % val

var player_food: int = 0 setget set_food
func set_food(val):
	player_food = val
	player_food_label.text = "Food: %du" % val

func _ready():
	for ant in ants:
		ant.connect("open_ant_editor", self, "open_ant_editor")
		ant.connect("birth_ant", self, "on_birth_ant")

func _process(delta):
	self.time += delta

func open_ant_editor(ant: AntSelector):
	ant_editor.open_for(ant)

func on_birth_ant(ant):
	emit_signal("birth_ant", ant)

func get_context(idx):
	return ants[idx]
