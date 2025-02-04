extends Path2D

@export var spawn_interval: float = 2.0
@export var enemy_scenes: Array[PackedScene]
@export var spawn_offset: float = 50.0

@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var spawn_timer: Timer = $SpawnTimer

var enabled: bool = true

func _ready():
	print("Spawner initialized - Parent: ", get_parent().name if get_parent() else "None")
	start_spawning()

func start_spawning():
	if not enabled:
		return
	
	print("Starting spawn timer")
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

func _on_spawn_timer_timeout():
	if not enabled:
		return
	
	print("Attempting to spawn enemy...")
	spawn_enemy()

func spawn_enemy():
	if enemy_scenes.is_empty():
		push_warning("No enemy scenes assigned!")
		return
	
	# Random enemy selection
	var selected_enemy = enemy_scenes.pick_random()
	var enemy = selected_enemy.instantiate()
	
	# Set spawn position
	path_follow.progress_ratio = randf()
	var spawn_pos = path_follow.global_position
	
	# Add to proper parent
	var game_root = get_tree().get_root()
	game_root.add_child(enemy)
	enemy.global_position = spawn_pos
	
	print("Spawned ", enemy.name, " at ", spawn_pos)

# Call this to temporarily stop spawning
func set_spawning(active: bool):
	enabled = active
	if active and not spawn_timer.is_stopped():
		spawn_timer.start()
	else:
		spawn_timer.stop()
