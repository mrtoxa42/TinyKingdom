extends Node2D






func _on_level_1_button_pressed():
	$AnimationPlayer.play("LevelPressed")
	await  $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Game/main_game.tscn")
