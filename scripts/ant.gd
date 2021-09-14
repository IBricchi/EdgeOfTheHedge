extends KinematicBody2D


onready var idle_sprite : AnimatedSprite = $"Basic Ant Idle"
onready var walk_sprite : AnimatedSprite = $"Basic Ant Walk"
onready var sensor : CollisionShape2D = $"Area2D/AntSensor"



var sensor_scale : float = 2.5


func _ready():
	idle_sprite.visible = true
	walk_sprite.visible = false
	sensor.scale *= sensor_scale


func _physics_process(delta):
	self.velocity += Vector2(2,2)
