extends Camera2D

@export var zoom_speed: float = 0.1
@export var pan_speed: float = 1.0
@export var rotation_speed: float = 1.0

@export var can_pan: bool
@export var can_zoom: bool
@export var can_rotate: bool

var touch_points: Dictionary = {}
var start_distance = 0
var start_zoom
var start_angle
var current_angle
var moved = false
var distancespeed = 200
var mousepos

func _ready(): 
	GameManager.camera2d = self

func _process(delta):
	if GameManager.selectedbox == true:
		if GameManager.mouseboundary == "Right":
			position.x += distancespeed * delta
		if GameManager.mouseboundary == "Left":
			position.x -= distancespeed * delta
		if GameManager.mouseboundary == "Up":
			position.y -= distancespeed * delta
		if GameManager.mouseboundary == "Down":
			position.y += distancespeed * delta

func _input(event):
	if GameManager.selectedbox == false:
		if event is InputEventScreenTouch:
			GameManager.global_mouse_position = event.position
			handle_touch(event)
		elif event is InputEventScreenDrag:
			handle_drag(event)
		elif event is InputEventMouseButton:
			if zoom >= Vector2(0.5,0.5) and zoom <= Vector2(1.5,1.5):
				handle_mouse_button(event)
			else:
				if zoom > Vector2(1.5,1.5):
					zoom = Vector2(1.5,1.5)
				elif zoom < Vector2(0.5,0.5):
					zoom = Vector2(0.5,0.5)
		if event.is_released() and event is InputEventScreenTouch:
			var timer = get_tree().create_timer(0.1)
			await timer.timeout
			GameManager.dragged = false

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_angle = get_angle(touch_point_positions[0], touch_point_positions[1])
		start_zoom = zoom
	elif touch_points.size() < 2:
		start_distance = 0

func handle_drag(event: InputEventScreenDrag):
	if GameManager.global_mouse_entered == false:
		touch_points[event.index] = event.position
		
		if touch_points.size() == 1:
			if can_pan:
				offset -= event.relative.rotated(rotation) * pan_speed
				GameManager.dragged = true

		elif touch_points.size() == 2:
			var touch_point_positions = touch_points.values()
			var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
			var current_angle = get_angle(touch_point_positions[0], touch_point_positions[1])
			var zoom_factor = start_distance / current_dist
			
			if can_zoom:
				zoom = start_zoom / zoom_factor
			if can_rotate:
				rotation -= (current_angle - start_angle) * rotation_speed
				start_angle = current_angle
			limit_zoom(zoom)

func handle_mouse_button(event: InputEventMouseButton):
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if can_zoom:
				zoom += Vector2(zoom_speed, zoom_speed)
				limit_zoom(zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if can_zoom:
				zoom -= Vector2(zoom_speed, zoom_speed)
				limit_zoom(zoom)

func limit_zoom(new_zoom):
		if new_zoom.x < 0.1:
			zoom.x = 0.1
		if new_zoom.y < 0.1:
			zoom.y = 0.1
		if new_zoom.x > 10:
			zoom.x = 10
		if new_zoom.y > 10:
			zoom.y = 10

func get_angle(p1, p2):
	var delta = p2 - p1
	return fmod((atan2(delta.y, delta.x) + PI), (2 * PI))
