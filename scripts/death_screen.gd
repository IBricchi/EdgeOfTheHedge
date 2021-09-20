extends Control

onready var prompt: Label = $"cont/title/Label"
onready var mm: Button = $"cont/cont/options/menu/button"
onready var play: Button = $"cont/cont/options/play/button"

func _ready():
	mm.connect("button_down", self, "_on_mm")
	play.connect("button_down", self, "_on_play")
	if(Global.win):
		prompt.text = "You did it boss! And it only took %d seconds.\n Those fat ants stood no change against your tactical prowess." % Global.time
	else:
		prompt.text = "Forgive us boss, we are beaten. \n It took them %d seconds to beat us. I'm sure they were cheating. \n\nThe High Queen won't be pleased..." % Global.time

func _on_mm():
	get_tree().change_scene("res://Scenes/title_screen.tscn")

func _on_play():
	get_tree().change_scene("res://Scenes/game.tscn")
