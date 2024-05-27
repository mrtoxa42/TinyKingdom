extends ColorRect

var mouse_down
var mouse_start_pos: Vector2
var mouse_end_pos: Vector2

func _process(delta):
	pass


func _input(event):
	if event is InputEventMouseButton:
		if event.double_click and event.is_pressed():
			GameManager.selectedbox = true
			if !mouse_down:
				mouse_down = true
				mouse_start_pos = event.global_position
				global_position = mouse_start_pos
		elif !event.is_pressed():
			if mouse_down:
				mouse_down = false
				mouse_end_pos = event.global_position
				size = Vector2.ZERO
				GameManager.selectedbox = false
				

			
			
	if event is InputEventMouseMotion:
		if mouse_down:
			_update()

	
func _update():
	GameManager.selectedbox = true
	
	if get_global_mouse_position().x < mouse_start_pos.x:
		scale.x = -1

		

	elif get_global_mouse_position().x > mouse_start_pos.x:
		scale.x = 1


	if get_global_mouse_position().y < mouse_start_pos.y:
		scale.y = -1

	elif get_global_mouse_position().y > mouse_start_pos.y:
		scale.y = 1


		
	# 32 ye 32 snapli bu
	#size = Vector2(snappedi(get_global_mouse_position().x-mouse_start_pos.x,32)*scale.x,snappedi(get_global_mouse_position().y-mouse_start_pos.y,32)*scale.y)
	# bu da snapsiz
	size = (get_global_mouse_position() - mouse_start_pos)*scale


func pressed_ended():
	var nodes_to_get = get_tree().get_nodes_in_group("Soldier")
	var nodes_in_rect = []
	if nodes_to_get != null:
		for node in nodes_to_get:
			if get_global_rect().has_point(node.global_position):
				print("anğn")
	
