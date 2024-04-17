extends CharacterBody2D

var hp = 3
var speed = 200
var accel = 7
var currentenemy
var enemyarea
var mousepos = Vector2.ZERO
var mousedistance
var enemydistance
var direction
var army_line
var onnav
@onready var nav: NavigationAgent2D = $NavigationAgent2D
var arrow = preload("res://Scenes/Knight/Items/archer_arrow_blue.tscn")



func _physics_process(delta):
	if currentenemy == null:
		if GameManager.currentarchers.has(self) or onnav == true:
			direction = Vector3()
			nav.target_position = mousepos
			direction = nav.get_next_path_position() - global_position
			#if direction.length() >10:
			
			#if nav.distance_to_target() > 25 * armysize:
			if nav.distance_to_target() > 25:
				#onnav = true
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
		if GameManager.global_mouse_entered == false and GameManager.currentarchers.has(self) and event is InputEventScreenTouch:
			army_line = GameManager.currentarchers.find(self)
			var armypos = GameSystem.get_node("CanvasLayer/ArmyFormationArcher/Formation" + str(army_line)).global_position
			mousepos = armypos
			onnav = true
			

func _on_selected_touched_pressed():
	GameManager.global_mouse_entered = true
	GameManager.current_mouse_area = "Archer"
	if !GameManager.currentarchers.has(self):
		army_selected()
	


func _on_selected_touched_released():
	var timer = get_tree()


func army_selected():
	if !GameManager.currentarchers.has(self):
		GameManager.currentarchers.append(self)
		GameManager.currentsoldiers.append(self)
		GameManager.currentarrows +=1
		mousepos = position
		$SelectedSprite.show()
		

func army_removed():
	if GameManager.currentarchers.has(self):
		for i in GameManager.currentarchers:
			if i == self:
				GameManager.currentarchers.erase(i)
				GameManager.currentsoldiers.erase(i)
				GameManager.currentarrows -=1
				$SelectedSprite.hide()

