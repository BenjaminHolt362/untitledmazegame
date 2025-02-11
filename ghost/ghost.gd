extends CharacterBody2D

@onready var player = get_node("/root/Game/Player")

var _health: int = 3
var _speed: float = 300.0

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _physics_process(delta):
	var _direction = global_position.direction_to(player.global_position)
	velocity = _direction * _speed
	move_and_slide()
	
	var overlapping_areas = %HurtBox.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		_health -= 1
		

func take_damage() -> void:
	_health -= 1
	
	if _health == 0:
		$AnimatedSprite2D.play("die")
		await get_tree().create_timer(2.0).timeout
		queue_free()
	
	$AnimatedSprite2D.play("hurt")
	await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.play("default")
