extends ColorRect

var mouse_down
var mouse_start_pos: Vector2
var mouse_end_pos: Vector2
var nodes_in_rect = []
@onready var multiple_collision = $"../MultipleArea/CollisionShape2D"
var soldiers: Array = []

func _ready():
	soldiers = get_tree().get_nodes_in_group("Soldier")

func _process(delta):
	if GameManager.mouseboundary == "Right":
		pass


func _input(event):
	soldiers = get_tree().get_nodes_in_group("Soldier")
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
				#pressed_ended()
				mouse_end_pos = event.global_position
				scale = Vector2.ZERO
				GameManager.selectedbox = false
				select_units_in_rectangle()
				#pressed_ended()
				
				
	if event is InputEventMouseMotion:
		select_units_in_rectangle()
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
	scale = (get_global_mouse_position() - mouse_start_pos)
 	
func select_units_in_rectangle():
	var rect_global_position = get_global_transform().origin
	var rect_size = size
	var selection_rect = Rect2(rect_global_position,rect_size)
	$Area2D.global_position = get_global_mouse_position()
	$Area2D/CollisionShape2D.global_position = get_global_mouse_position()
	print($Area2D/CollisionShape2D.shape)
	
	for soldier in soldiers:
			var soldier_pos = soldier.global_position
			#if selection_rect.has_point(soldier_pos):
			if get_global_rect().has_point(soldier_pos):
				print("Asker seçildi")
				pass
			else:
				print("Asker seçili değil")
				pass
	

	
