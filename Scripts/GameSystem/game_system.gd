extends Node2D




func _process(delta):
	$CanvasLayer/ArmyFormationKnight.global_position = get_global_mouse_position()
	$CanvasLayer/ArmyFormationArcher.global_position = get_global_mouse_position() - Vector2(25,25)

	


func all_knight_selected():
	pass
	
func all_archer_selected():
	pass
