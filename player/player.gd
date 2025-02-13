extends CharacterBody2D

signal health_depleted

const DAMAGE_RATE: = 5.0

var _health: float = 100.0
var _speed: float = 600.0

func _ready() -> void:
	%GunTimer.start()

func _physics_process(delta):
	var _direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = _direction * _speed
	if _health > 0.0:
		move_and_slide()
	play_animation()
	
	$Gun.look_at(get_global_mouse_position())
	
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

enum GUNS { PISTOL, SHOTGUN, AK47 }
var current_gun = GUNS.AK47

func change_gun(gun: GUNS) -> void:
	if gun == GUNS.SHOTGUN:
		current_gun = gun
		var s = load("res://guns/shotgun.png")
		
		%GunSprite.texture = s
		%GunTimer.wait_time = 0.5
		
	elif gun == GUNS.AK47:
		current_gun = gun
		var s = load("res://guns/ak47.png")
		
		%GunSprite.texture = s
		%GunTimer.wait_time = 0.1
	else:
		current_gun = GUNS.PISTOL
		var s = load("res://guns/pistol.png")
		
		%GunSprite.texture = s
		%GunTimer.wait_time = 0.5

func shoot() -> void:
	const BULLET = preload("res://bullet/bullet.tscn")
	
	if current_gun == GUNS.SHOTGUN:
		for rotation in range(-3, 3):
			var _new_bullet = BULLET.instantiate()
			_new_bullet.global_position = %ShootingPoint.global_position
			_new_bullet.global_rotation = %ShootingPoint.global_rotation + (rotation * 0.2)
			%ShootingPoint.add_child(_new_bullet)
		
		return
	
	var _new_bullet = BULLET.instantiate()
	_new_bullet.global_position = %ShootingPoint.global_position
	
	if current_gun == GUNS.AK47:
		_new_bullet.global_rotation = %ShootingPoint.global_rotation + (randf()) * 0.1
	else:
		_new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(_new_bullet)


func _on_gun_timer_timeout() -> void:
	shoot()


func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("ak47pickup"):
		change_gun(GUNS.AK47)
		area.queue_free()
		
	elif area.is_in_group("shotgunpickup"):
		print("ATTEMPING TO CHANGE TO SHOTGUN")
		change_gun(GUNS.SHOTGUN)
		area.queue_free()
		
		
