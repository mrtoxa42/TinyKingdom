extends CharacterBody2D


var current_resources = null
var resources_type = ""
var resources_area = false
var speed = 200
var accel = 7
var onnav = false
var work_metter = 0
var resources_distance
var direction 
var mousepos = Vector2.ZERO
var army_line
@onready var nav = $NavigationAgent2D




func _process(delta):
	pass

func _physics_process(delta):
	if current_resources == null:
		if GameManager.currentpawn.has(self) or onnav == true:
			direction = Vector3()
			nav.target_position = mousepos
			direction = nav.get_next_path_position() - global_position
			if nav.distance_to_target() > 25:
				direction = direction.normalized()
				velocity = velocity.lerp(direction * speed, accel * delta)
				move_and_slide()
				if mousepos.x > global_position.x:
					$VisualAnimation.play("RunRight")
				else:
					$VisualAnimation.play("RunLeft")
			else:
				$VisualAnimation.play("Idle")
				
	else:
		if current_resources != null:
			direction = Vector3()
			nav.target_position = current_resources.global_position
			direction = nav.get_next_path_position() - global_position
			if nav.distance_to_target() > 75:
				direction = direction.normalized()
				velocity = velocity.lerp(direction * speed, accel * delta)
				move_and_slide()
				if mousepos.x > global_position.x:
					$VisualAnimation.play("RunRight")
				else:
					$VisualAnimation.play("RunLeft")
			else:
				if resources_area == false:
					resources_area = true
					start_working()
				


func _input(event):
	
	if event.is_released():
		if GameManager.global_mouse_entered == false and GameManager.currentpawn.has(self) and event is InputEventScreenTouch:      
			army_line = GameManager.currentpawn.find(self)
			var army_pos = GameSystem.get_node("CanvasLayer/ArmyFormationPawner/Formation" + str(army_line)).global_position
			mousepos = army_pos
			onnav = true
			if GameManager.current_mouse_area == "Resources":
				pass
			else:
				current_resources = null


func _on_selected_touched_pressed():
	GameManager.global_mouse_entered = true
	GameManager.current_mouse_area = "Pawn"
	if !GameManager.currentpawn.has(self):
		worker_selected()
	else:
		worker_removed()


func _on_selected_touched_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.global_mouse_entered = false
	GameManager.current_mouse_area = null

func worker_selected():
	if !GameManager.currentpawn.has(self):
		GameManager.currentpawn.append(self)
		GameManager.currentworkers +=1
		mousepos = position
		Gui.select_pawner()
		$SelectedSprite.show()
func worker_removed():
	if GameManager.currentpawn.has(self):
		GameManager.currentpawn.erase(self)
		GameManager.currentworkers -= 1
		Gui.select_pawner()
		$SelectedSprite.hide()

func selected_resources():
	print("Kaynak seçildi" + str(current_resources))

func start_working():
	work_metter +=1
	
	if current_resources.global_position.x > global_position.x:
		$VisualAnimation.play("GatheringRight")
	elif current_resources.global_position.x < global_position.x:
		$VisualAnimation.play("GatheringLeft")
	await  $VisualAnimation.animation_finished
	if work_metter < 3:
		start_working()
	else:
		$ResourcesSpirte.show()
		if resources_type == "Tree":
			$ResourcesSpirte.play("wood")
			
	
func resources_damage():
	current_resources.take_damage()
