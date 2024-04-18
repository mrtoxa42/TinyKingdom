extends CharacterBody2D


var current_resources
var speed = 200
var accel = 7
var resources_distance
var direction 
var mousepos = Vector2.ZERO
var army_line
@onready var nav = $NavigationAgent2D


func _physics_process(delta):
	if current_resources != null:
		resources_distance = current_resources.global_position - global_position
		resources_distance.normalized()
		velocity = resources_distance
		move_and_slide()
	else:
		if GameManager.currentpawn.has(self):
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
func _input(event):
	if event.is_released():
		if GameManager.global_mouse_entered == false and GameManager.currentpawn.has(self) and event is InputEventScreenTouch:
			army_line = GameManager.currentpawn.find(self)
			var army_pos = GameSystem.get_node("CanvasLayer/ArmyFormationKnight/Formation" + str(army_line)).global_position
			mousepos = army_pos

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
		$SelectedSprite.show()
func worker_removed():
	if GameManager.currentpawn.has(self):
		GameManager.currentpawn.erase(self)
		GameManager.currentworkers -= 1
		$SelectedSprite.hide()
