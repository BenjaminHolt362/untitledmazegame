extends CharacterBody2D

signal health_depleted

const DAMAGE_RATE: = 5.0

var _health: float = 100.0
var _speed: float = 600.0

func _physics_process(delta):
	var _direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = _direction * _speed
	if _health > 0.0:
		move_and_slide()
	play_animation()
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		_health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = _health
		
		if _health <= 0.0:
			health_depleted.emit()


func play_animation() -> void:
	if _health <= 0.0:
		$AnimatedSprite2D.animation = "die"
		return
	
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		$AnimatedSprite2D.animation = "hurt"
		$AnimatedSprite2D.play()
		return
	
	if velocity.length() > 0.0:
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.play()
		return
	
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
