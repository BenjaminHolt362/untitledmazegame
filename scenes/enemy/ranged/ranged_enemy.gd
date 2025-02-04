extends Enemy

@export var shoot_interval: float = 1.0

func _ready():
	super._ready()
	speed = 200.0
	health = 2
	damage = 1
	$ShootTimer.start(shoot_interval)

func _on_shoot_timer_timeout():
	shoot()

func shoot():
	var bullet = preload("res://scenes/bullet/bullet.tscn").instantiate()
	bullet.initialize(global_position, (target_position - global_position).normalized())
	get_parent().add_child(bullet)
