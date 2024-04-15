extends CharacterBody2D

var speed = 200
var currentenemy = null
var enemyarea = null
var attack = false
var shot_range = 200
var hp = 3
var mousedistance = Vector2.ZERO
var mousepos = Vector2.ZERO
var accel = 7
var onnav = false
var direction = Vector3.ZERO
var oncetouchpos = Vector3.ZERO
var mouseenter = false
var armysize = 1
var army_line
var dead = false
var enemydistance
var arrow = preload("res://Scenes/Knight/Items/archer_arrow_blue.tscn")
@onready var nav = $NavigationAgent2D


func _physics_process(delta):
	if currentenemy == null:
		if GameManager.currentarchers.has(self) or onnav == true:
			direction = Vector3()
			nav.target_position = mousepos
			direction = nav.get_next_path_position() - global_position
			#if direction.length() >10:
			
					
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
		if (currentenemy.global_position - global_position).length() > shot_range:
			direction = currentenemy.global_position - global_position
			direction.normalized()
			velocity = direction
			if velocity != Vector2(0,0) and attack == false:
					if currentenemy.global_position.x > global_position.x:
						$VisualAnimation.play("RunRight")
					else:
						$VisualAnimation.play("RunLeft")
					move_and_slide()
		else:
			enemyarea = currentenemy
			Attack()

func _input(event):
	if event.is_released():
		if !event is InputEventScreenDrag and event is InputEventScreenTouch and GameManager.currentarchers.has(self):
			if GameManager.global_mouse_entered == false:
				army_line = GameManager.currentarchers.find(self)
				var armypos = GameSystem.get_node("CanvasLayer/ArmyFormationArcher/Formation" + str(army_line)).global_position
				mousepos = armypos
				onnav = true
				
			

func _on_detected_area_area_entered(area):
	if area.is_in_group("Enemy"):
		if currentenemy == null:
			currentenemy = area


func Attack():
	if enemyarea != null and dead == false: 
		attack = true
		if (enemyarea.global_position.y - global_position.y) > 50:
			$VisualAnimation.play("AttackDown")
		elif (enemyarea.global_position.y - global_position.y) < -50:
			$VisualAnimation.play("AttackUp")
		elif enemyarea.global_position.x > global_position.x:
			$VisualAnimation.play("AttackRight")
		else:
			$VisualAnimation.play("AttackLeft")
	#await $VisualAnimation.animation_finished

	if enemyarea !=null: 
		$AttackTimer.start()
	else:
		$VisualAnimation.play("Idle")
		attack = false
		
func create_arrow():
	if enemyarea != null:
		var Arrow = arrow.instantiate()
		get_tree().get_root().add_child(Arrow)
		Arrow.global_position = global_position
		Arrow.target = enemyarea
		Arrow.myarcher = self
		Arrow.archertype = "Archer"
		

func dead_enemy():
	enemyarea = null
	currentenemy = null
	attack = false
	

func take_damage():
	if hp >=1:
		hp -= 1
		$ExtraAnimation.play("take_damage")
	else:
		dead = true
		$ExtraAnimation.play("dead")
		$ArcherArea/CollisionShape2D.disabled = true
		await $ExtraAnimation.animation_finished
		queue_free()
	
	
	
func _on_attack_timer_timeout():
	if enemyarea != null:
		
		Attack()
	#else:
		#dead_enemy()
 

func _on_tool_animation_animation_finished(anim_name):
	if anim_name == "detected":
		if currentenemy == null:
			$ToolAnimation.play("detected")


func _on_detected_area_area_exited(area):
	if area == currentenemy:
		$ToolAnimation.play("detected")
		currentenemy = null
		enemyarea = null
		$VisualAnimation.play("Idle")
	


func _on_selected_touch_pressed():

	if GameManager.currentarchers.has(self) == false:
		army_selected()
	else:
		army_removed()
		
func army_selected():
	if GameManager.currentarchers.has(self) == false:
		army_line = GameManager.currentarchers
		$ArmySelected.show()
		GameManager.currentarchers.append(self)
		GameManager.currentsoldiers.append(self)
		armysize = GameManager.currentsoldiers.size()
		GameManager.currentarrows +=1
		mousepos = position
		Gui.select_archer()

func army_removed():
	for i in GameManager.currentarchers:
			if i == self:
				GameManager.currentarchers.erase(i)
				GameManager.currentarrows -=1
				GameManager.currentsoldiers.erase(i)
				$ArmySelected.hide()
				Gui.select_archer()
				


func _on_archer_area_mouse_entered():
	pass


func _on_archer_area_mouse_exited():
	pass






func _on_selected_touch_released():
	var timer = get_tree().create_timer(0,5)
	await timer.timeout
	GameManager.global_mouse_entered = false
	GameManager.current_mouse_area = null
