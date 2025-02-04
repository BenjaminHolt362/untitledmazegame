extends Area2D

@export var speed: int = 600
@export var max_distance: float = 500.0

var direction: Vector2
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = global_position

func _physics_process(delta):
	position += direction * speed * delta
	
	# Simple distance check (could also use Timer)
	if global_position.distance_to(spawn_position) >= max_distance:
		queue_free()

func initialize(spawn_pos: Vector2, bullet_direction: Vector2):
	global_position = spawn_pos
	direction = bullet_direction
	rotation = direction.angle()
