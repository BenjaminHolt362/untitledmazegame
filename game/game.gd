extends Node2D


func spawn_mob() -> void:
	var _new_mob = preload("res://ghost/ghost.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	_new_mob.global_position = %PathFollow2D.global_position
	add_child(_new_mob)

func _on_timer_timeout():
	spawn_mob()

func _on_player_health_depleted():
	%GameOver.visible = true

func _on_button_pressed():
	get_tree().paused = false
	%GameOver.visible = false
	get_tree().reload_current_scene()
