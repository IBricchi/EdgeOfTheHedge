extends Node2D

var ant : Resource = preload("res://scenes/ant.tscn")
var queen : Resource = preload("res://scenes/queen.tscn")
var lettuce : Resource = preload("res://scenes/lettuce.tscn")


var enemy_ants: Array = []


onready var cam : Camera2D = $Camera2D

export var cam_speed = 300
export var starting_ants = 25

onready var ui = $UI

onready var lett_spawner = $LettuceSpawner

var ant_home : Vector2 = Vector2(70,70)

var player_food : int = 100 setget set_player_food

var friendly_queen_hp  = 75
var enemy_queen_hp = 75

func set_player_food(val):
	player_food = val
	ui.player_food = val

var queen_inst;
var enemyqueen;

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

	ui.connect("birth_ant", self, "birth_ant")
	
	queen_inst = queen.instance()
	add_child(queen_inst)
	queen_inst.translate(ant_home)
	queen_inst.modulate = Color(1,0.1,0.2)

	for i in 10:
		birth_ant(ui.get_context(0), true)
	
	
	enemyqueen = queen.instance()
	add_child(enemyqueen)
	enemyqueen.translate( Vector2(1985, 1090))
	enemyqueen.modulate = Color(0.3,0.05,0.1)
	
	for i in range(starting_ants):
		enemy_ant_spawn()
		
		
	queen_inst.look_at(enemyqueen.position)	
	enemyqueen.look_at(queen_inst.position)

	lett_spawner.setup(0,2048,0,1152,10,50,10)
	for n in 25:
		lett_spawner.spawn_bunch()

var tensec = 10
func _process(delta):
	tensec -= delta
	if tensec < 0:
		var i = 0
		while i < len(enemy_ants):
			if not enemy_ants[i].alive:
				enemy_ants.remove(i)
			else:
				i+= 1
		
		if len(enemy_ants) < 0.8 * starting_ants:
			enemy_ant_spawn()
		var hostcount = 0
		for ant in enemy_ants:
			if ant.ant_priority == 2:
				hostcount += 1
		if hostcount < 0.4*starting_ants:
			for ant in enemy_ants:
				if randf()< 0.4 : 
					ant.ant_priority = 2
				else:
					ant.ant_priority = 3
		tensec = 10

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
		ant_inst.translate(ant_home + Vector2(30,30))
		ant_inst.set_ant_home(queen_inst)
		ant_inst.set_context(context)
		ant_inst.set_collision_layer_bit(3, true)
		ant_inst.set_collision_mask_bit(4 , true)
		ant_inst.set_enemy(enemyqueen)
		ant_inst.desired_direction = Vector2(rand_range(-1,1),rand_range(-1,1))

func on_add_food(count):
	self.player_food += count

func on_ant_death():
	self.ant_count -= 1
	


func queen_attacked(q, v):
	if q == queen_inst:
		friendly_queen_hp -= v
		if friendly_queen_hp < 0 :
			Global.win = false
			Global.time = ui.time
			get_tree().change_scene("res://scenes/death_screen.tscn")
	else:
		enemy_queen_hp -= v
		if enemy_queen_hp < 0:
			Global.win = true
			Global.time = ui.time
			get_tree().change_scene("res://scenes/death_screen.tscn")

func enemy_ant_spawn():
	var ant1 = ant.instance()
	add_child(ant1)
	ant1.modulate = Color(0.25,0.05,0.1)
	ant1.scale /= 2
	ant1.translate( enemyqueen.position - Vector2(30,30))
	ant1.set_ant_home(enemyqueen)
	ant1.set_collision_layer_bit(4, true)
	ant1.set_collision_mask_bit(3 , true)
	enemy_ants.append(ant1)
	ant1.set_enemy(queen_inst)
	

