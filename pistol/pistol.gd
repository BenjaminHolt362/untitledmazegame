extends Node2D


func _physics_process(delta):
	look_at(get_global_mouse_position())
	
func _ready():
	change_gun(GUNS.shotgun)

func shoot() -> void:
	const BULLET = preload("res://bullet/bullet.tscn")
	
	if _gun == GUNS.shotgun:
		for rotation in range(-3, 3):
			var _new_bullet = BULLET.instantiate()
			_new_bullet.global_position = %ShootingPoint.global_position
			_new_bullet.global_rotation = %ShootingPoint.global_rotation + (rotation * 0.2)
			%ShootingPoint.add_child(_new_bullet)
		
		return
	
	var _new_bullet = BULLET.instantiate()
	_new_bullet.global_position = %ShootingPoint.global_position
	
	if _gun == GUNS.ak47:
		_new_bullet.global_rotation = %ShootingPoint.global_rotation + (randf())
	else:
		_new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(_new_bullet)

enum GUNS { shotgun, ak47, pistol }
var _gun = GUNS.pistol

func change_gun(gun: GUNS) -> void:
	if gun == GUNS.shotgun:
		_gun = gun
		var s = load("res://pistol/shotgun.png")
		%Gun.texture = s
		
	elif gun == GUNS.ak47:
		_gun = gun
		var s = load("res://pistol/ak47.png")
		%Gun.texture = s
		
		$Timer.wait_time = 0.1
	else:
		_gun = GUNS.pistol
		var s = load("res://pistol/pistol.png")
		%Gun.texture = s

func _on_timer_timeout():
	shoot()

func _on_player_health_depleted() -> void:
	queue_free()
