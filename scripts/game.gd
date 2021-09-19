extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var queen : Resource = preload("res://scenes/queen.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")

onready var cam : Camera2D = $Camera2D

export var cam_speed = 300
export var starting_ants = 50

onready var ui = $UI

onready var lett_spawner = $LettuceSpawner

var ant_home : Vector2 = Vector2(80,80)
var markers : Array = []
var player_food : int = 10 setget set_player_food
func set_player_food(val):
	player_food = val
	ui.player_food = val

var queen_inst;

var ant_count = 0 setget set_ant_count;
func set_ant_count(val):
	ant_count = val
	ui.population = val
	if val <= 0:
		Global.win = false
		Global.time = ui.time
		get_tree().change_scene("res://scenes/death_screen.tscn")

func _ready():
	cam.limit_right = 2048
	cam.limit_bottom = 1152
	cam.limit_top = 0 
	cam.limit_left = 0

	ui.connect("birth_ant", self, "on_birth_ant")
	


	ui.connect("birth_ant", self, "birth_ant")
	
	queen_inst = queen.instance()
	add_child(queen_inst)
	queen_inst.translate(ant_home)
	queen_inst.modulate = Color(1,0.1,0.2)

	for i in 1:
		birth_ant(ui.get_context(0), true)

	var enemyqueen = queen.instance()
	add_child(enemyqueen)
	enemyqueen.translate(ant_home)
	enemyqueen.modulate = Color(0.3,0.05,0.1)
	
	for i in range(starting_ants):
		var ant1 = ant.instance()
		add_child(ant1)
		ant1.modulate = Color(0.25,0.05,0.1)
		ant1.scale /= 2
		ant1.translate( ant_home - Vector2(20,20))
		ant1.set_ant_home(enemyqueen)
		ant1.set_collision_layer_bit(3, true)
		ant1.set_collision_mask_bit(4 , true)
		
		
	queen_inst.look_at(enemyqueen.position)	
	enemyqueen.look_at(queen_inst.position)

	lett_spawner.setup(0,2048,0,1152,10,50,10)
	for n in 25:
		lett_spawner.spawn_bunch()

func birth_ant(context, free = false):
	if free or player_food >= context.cost:
		if not free:
			player_food -= context.cost
		var ant_inst = ant.instance()
		ant_inst.connect("add_food", self, "on_add_food")
		ant_inst.connect("die", self, "on_ant_death")
		self.ant_count += 1
		add_child(ant_inst)
		ant_inst.scale /= 2
		ant_inst.translate(ant_home)
		ant_inst.set_ant_home(queen_inst)
		ant_inst.set_context(context)

func on_add_food(count):
	self.player_food += count

func on_ant_death():
	self.ant_count -= 1
