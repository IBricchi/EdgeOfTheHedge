extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var queen : Resource = preload("res://scenes/queen.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")

onready var ui = $UI

onready var lett_spawner = $LettuceSpawner

var ant_home : Vector2 = Vector2(600,500)
var markers : Array = []
var player_food : int = 10

var queen_inst;

func _ready():
	ui.connect("birth_ant", self, "birth_ant")
	
	queen_inst = queen.instance()
	add_child(queen_inst)
	queen_inst.translate(ant_home)
	queen_inst.modulate = Color(1,0.1,0.2)

	for i in 10:
		birth_ant(ui.get_context(0), true)

	lett_spawner.setup(0,2048,0,1152,10,50,10)
	for n in 5:
		lett_spawner.spawn_bunch()

func birth_ant(context, free = false):
	if free or player_food >= context.cost:
		if not free:
			player_food -= context.cost
		var ant_inst = ant.instance()
		add_child(ant_inst)
		ant_inst.scale /= 2
		ant_inst.translate(ant_home)
		ant_inst.set_ant_home(queen_inst)
		ant_inst.set_context(context)
