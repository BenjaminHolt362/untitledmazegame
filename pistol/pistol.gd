extends Node2D


func _physics_process(delta):
	look_at(get_global_mouse_position())
	
func _ready():
	change_gun(GUNS.shotgun)

func shoot() -> void:
	const BULLET = preload("res://bullet/bullet.tscn")
	var _new_bullet = BULLET.instantiate()
	_new_bullet.global_position = %ShootingPoint.global_position
	_new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(_new_bullet)

enum GUNS { shotgun, ak47 }
func change_gun(gun: GUNS) -> void:
	if gun == GUNS.shotgun:
		var s = load("res://pistol/shotgun.png")
		%Gun.texture = s
		
	elif gun == GUNS.ak47:
		var s = load("res://pistol/ak47.png")
		%Gun.texture = s
		
		$Timer.wait_time = 0.1
	else:
		var s = load("res://pistol/pistol.png")
		%Gun.texture = s

func _on_timer_timeout():
	shoot()

func _on_player_health_depleted() -> void:
	queue_free()
