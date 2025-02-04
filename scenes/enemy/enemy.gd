class_name Enemy
extends CharacterBody2D

@export var speed: float = 100.0
@export var health: int = 1
@export var damage: int = 1

var target_position: Vector2

func _ready():
	# Set initial target position (center of screen by default)
	target_position = get_viewport_rect().size / 2

func _physics_process(delta):
	move_toward_target(delta)

func move_toward_target(delta):
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()

func set_target_position(new_target: Vector2):
	target_position = new_target
