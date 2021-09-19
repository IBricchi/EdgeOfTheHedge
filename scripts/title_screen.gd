extends Control

onready var play: Button = $"cont/cont/options/play/button"
onready var settings: Button = $"cont/cont/options/settings/button"

func _ready():
	play.connect("button_down", self, "_on_play")

func _on_play():
	get_tree().change_scene("res://Scenes/game.tscn")
