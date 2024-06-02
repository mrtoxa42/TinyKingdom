extends Area2D

var mouse_down
var mouse_start_pos: Vector2
var mouse_end_pos: Vector2
var nodes_in_rect = []
@onready var multiple_collision = $CollisionShape2D
var soldiers: Array = []


func _process(delta):
	pass


func _input(event):
	soldiers = get_tree().get_nodes_in_group("Soldier")
	if event is InputEventMouseButton:
		if event.double_click and event.is_pressed():
			GameManager.selectedbox = true
			show()
				
			if !mouse_down: 
				mouse_down = true
				mouse_start_pos = get_global_mouse_position()
				global_position = mouse_start_pos
		elif !event.is_pressed():
			if mouse_down:
				mouse_down = false
				#pressed_ended()
				mouse_end_pos = event.global_position
				scale = Vector2.ZERO
				GameManager.selectedbox = false
				hide()
				#pressed_ended()
				
			
			
			
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
	#scale = Vector2(snappedi(get_global_mouse_position().x-mouse_start_pos.x,32)*scale.x,snappedi(get_global_mouse_position().y-mouse_start_pos.y,32)*scale.y)
	# bu da snapsiz
	scale = (get_global_mouse_position() - mouse_start_pos) / 42




func _on_area_entered(area):
	if area.is_in_group("Soldier"):
		area.get_owner().army_selected()
	print(area)
