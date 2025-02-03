extends Node2D

@export var gun_length: float = 20.0
@export var bullet_scene: PackedScene  # MUST be assigned in inspector
@export var fire_rate: float = 0.2

var can_fire: bool = true

func _process(delta):
	look_at(get_global_mouse_position())
	$ColorRect.position = Vector2(gun_length, 0)
	
	if Input.is_action_pressed("fire") and can_fire:
		fire_bullet()
		can_fire = false
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true

func fire_bullet():
	if bullet_scene == null:
		push_error("Bullet scene not assigned!")
		return
		
	var bullet = bullet_scene.instantiate()
	
	# Get spawn position at gun tip
	var spawn_pos = $ColorRect.global_position
	# Get bullet direction from gun rotation
	var direction = Vector2.RIGHT.rotated(global_rotation)
	
	bullet.initialize(spawn_pos, direction)
	
	# Add to scene tree - SAFER method
	get_tree().current_scene.add_child(bullet)
