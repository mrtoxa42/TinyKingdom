extends Area2D

var mouse_down = false
var mouse_start_pos: Vector2
var mouse_end_pos: Vector2
@onready var multiple_collision = $CollisionShape2D
@onready var selection_rect = $ColorRect
var soldiers: Array = []

func _process(delta):
	pass

func _input(event):
	soldiers = get_tree().get_nodes_in_group("Soldier")
	
	if event is InputEventMouseButton:
		if event.double_click:
			if not mouse_down:
				mouse_down = true
				mouse_start_pos = get_global_mouse_position()
				global_position = mouse_start_pos
				GameManager.selectedbox = true
				selection_rect.show()
				multiple_collision.disabled = false
				show()
		else:
			if mouse_down:
				mouse_down = false
				multiple_collision.disabled = true
				mouse_end_pos = get_global_mouse_position()
				scale = Vector2(1, 1)
				selection_rect.size = Vector2.ZERO
				GameManager.selectedbox = false
				selection_rect.hide()
				hide()
	
	elif event is InputEventScreenDrag or event is InputEventMouseMotion:
		if mouse_down:
			_update()

func _update():
	var current_mouse_pos = get_global_mouse_position()
	var width = abs(current_mouse_pos.x - mouse_start_pos.x)
	var height = abs(current_mouse_pos.y - mouse_start_pos.y)
	
	global_position = (mouse_start_pos + current_mouse_pos) / 2.0
	
	var collision_shape = multiple_collision.shape as RectangleShape2D
	collision_shape.extents = Vector2(width / 2, height / 2)
	if get_global_mouse_position().x < mouse_start_pos.x:
		selection_rect.scale.x = -1
	elif get_global_mouse_position().x > mouse_start_pos.x:
		selection_rect.scale.x = 1
	if get_global_mouse_position().y < mouse_start_pos.y:
		selection_rect.scale.y = -1
	elif get_global_mouse_position().y > mouse_start_pos.y:
		selection_rect.scale.y = 1
	# Selection rectangle size and position update
	#selection_rect.size = Vector2(width, height) / 2
	selection_rect.size = (get_global_mouse_position() - mouse_start_pos) * selection_rect.scale
	selection_rect.position = mouse_start_pos - global_position
	
	# Yönü ayarlamak için scale ayarlama
	scale.x = 1 if current_mouse_pos.x >= mouse_start_pos.x else -1
	scale.y = 1 if current_mouse_pos.y >= mouse_start_pos.y else -1

func _on_area_entered(area):
	if area.is_in_group("Soldier"):
		area.get_owner().army_selected()


func _on_area_exited(area):
	if area.is_in_group("Soldier"):
		if GameManager.selectedbox == true:
			area.get_owner().army_removed()
