extends CharacterBody2D



var currentenemy
var enemydistance
var mousedistance = Vector2.ZERO
var mousepos = Vector2.ZERO
var enemyarea
var speed = 200
var accel = 7
var onnav = false
var direction = Vector3.ZERO
var oncetouchpos = Vector3.ZERO
var mouseenter = false
var armysize = 1
var army_line
var hp = 10
var dead = false
var attack = false
@onready var nav: NavigationAgent2D = $NavigationAgent2D


func _ready():
	GameManager.liveknights +=1


func _physics_process(delta):
	
	if currentenemy == null:
		
		if GameManager.currentknights.has(self) or onnav == true:
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
			
	else:
		
		direction = currentenemy.global_position - global_position
		direction.normalized()
		velocity = direction
		if velocity != Vector2(0,0) and attack == false:
				if currentenemy.global_position.x > global_position.x:
					$VisualAnimation.play("RunRight")
				else:
					$VisualAnimation.play("RunLeft")
				move_and_slide()
			
		

#func _process(delta):
	#if Input.is_action_just_pressed("LeftClick") and GameManager.currentknights.has(self):
		#if GameManager.global_mouse_entered == false:5
			#mousepos = get_global_mouse_position()
			#onnav = true
func _input(event):
	if event.is_released():
		if GameManager.global_mouse_entered == false and GameManager.currentknights.has(self) and event is InputEventScreenTouch:
				army_line = GameManager.currentknights.find(self)
				var armypos = GameSystem.get_node("CanvasLayer/ArmyFormationKnight/Formation" + str(army_line)).global_position
				mousepos = armypos
				onnav = true





func _on_detected_area_area_entered(area):
	if area.is_in_group("Enemy") and enemyarea == null:
		if currentenemy == null:
			currentenemy = area
			print(name + str(currentenemy))
			
func take_damage():

	if hp >1:
		hp-=1
		$ExtraAnimation.play("take_damage")
	else:
		dead = true
		$ExtraAnimation.play("dead")
		$KnightArea/CollisionShape2D.disabled = true
		GameManager.liveknights -= 1
		await $ExtraAnimation.animation_finished
		queue_free()
		


func _on_knight_area_area_entered(area):
	if area.is_in_group("Enemy"):
		enemyarea = area
		Attack()
		

func _on_attack_timer_timeout():
	if enemyarea !=null:
		Attack()
	
func _on_knight_area_area_exited(area):
	if area == enemyarea:
		enemyarea = null
		currentenemy = null
		$ToolAnimation.play("Detected")
	
	
func Attack():
	attack = true
	if (enemyarea.global_position.y - global_position.y) > 50:
			$VisualAnimation.play("AttackDown")
	elif (enemyarea.global_position.y - global_position.y) < -50:
		$VisualAnimation.play("AttackUp")
	elif enemyarea.global_position.x > global_position.x:
		$VisualAnimation.play("AttackRight")
	else:
		$VisualAnimation.play("AttackLeft")
	await $VisualAnimation.animation_finished
	$VisualAnimation.play("Idle")
	$AttackTimer.start()
	

func deal_damage():
	if enemyarea != null:
		enemyarea.get_owner().take_damage()


func _on_tool_animation_animation_finished(anim_name):
	if anim_name == "Detected":
		if enemyarea == null:
			$ToolAnimation.play("Detected")


func _on_selected_touch_pressed():
	GameManager.global_mouse_entered = true
	GameManager.current_mouse_area = "Knight"
	if GameManager.currentknights.has(self) == false:
		army_selected()
	else:
		army_removed()
	
func army_selected():
	if GameManager.currentknights.has(self) == false:
		army_line = GameManager.currentwarriors
		$ArmySelected.show()
		GameManager.currentknights.append(self)
		GameManager.currentsoldiers.append(self)
		armysize = GameManager.currentsoldiers.size()
		GameManager.currentwarriors +=1
		mousepos = position
		Gui.select_warrior()
func army_removed():
	for i in GameManager.currentknights:
			if i == self:
				GameManager.currentknights.erase(i)
				GameManager.currentwarriors -=1
				GameManager.currentsoldiers.erase(i)
				$ArmySelected.hide()
				Gui.select_warrior()
				
	
				
func _on_knight_area_mouse_entered():
	#GameManager.current_mouse_area = "Knight"
	#GameManager.global_mouse_entered = true
	pass


func _on_knight_area_mouse_exited():
	pass




func _on_selected_touch_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.global_mouse_entered = false
	GameManager.current_mouse_area = null
