extends Node2D


var twice_click = false
var zoom_touch = false
func _process(delta):
	$CanvasLayer/ArmyFormationKnight.global_position = get_global_mouse_position()
	$CanvasLayer/ArmyFormationPawner.global_position = get_global_mouse_position() - Vector2(0,-75)
	if GameManager.currentwarriors !=0:
		$CanvasLayer/ArmyFormationArcher.global_position = get_global_mouse_position()
	else:
		$CanvasLayer/ArmyFormationArcher.global_position = get_global_mouse_position() - Vector2(-8,-68)


func _input(event):
	if event.is_pressed() and event is InputEventScreenTouch:
		print("bi")
		if GameManager.current_mouse_area == "Knight" or "Archer" or "Pawn":
			if twice_click == false:
				twice_click = true
				var timer = get_tree().create_timer(1)
				timer.connect("timeout",time_out)
			elif twice_click == true:
				if GameManager.current_mouse_area == "Knight":
					all_knight_selected()
				elif GameManager.current_mouse_area == "Archer":
					all_archer_selected()
				elif GameManager.current_mouse_area == "Pawn":
					all_pawn_selected()
					
func time_out():
	twice_click = false
func all_knight_selected():
	get_tree().call_group("Knight","army_selected")
func all_archer_selected():
	get_tree().call_group("Archer","army_selected")
func all_pawn_selected():
	get_tree().call_group("Pawn", "worker_selected")

