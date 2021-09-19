extends Control

onready var prompt: Label = $"cont/title/Label"
onready var mm: Button = $"cont/cont/options/menu/button"
onready var play: Button = $"cont/cont/options/play/button"

func _ready():
	mm.connect("button_down", self, "_on_mm")
	play.connect("button_down", self, "_on_play")
	if(Global.win):
		prompt.text = "You did it boss, and it only took %d seconds. Those fat ants stood no change angainst your tactical prowess." % Global.time
	else:
		prompt.text = "I'm sorry boss it took them %d seconds to beat us. I'm sure they were cheating." % Global.time

func _on_mm():
	get_tree().change_scene("res://Scenes/title_screen.tscn")

func _on_play():
	get_tree().change_scene("res://Scenes/game.tscn")
