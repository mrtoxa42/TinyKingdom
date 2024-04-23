extends CharacterBody2D

var hp = 3
var dead = false
var attack = false
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
	if currentenemy == null and dead == false:
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
	else:
		if enemyarea == null and dead == false:
			enemydistance = currentenemy.global_position - global_position
			direction = enemydistance
			direction.normalized()
			velocity = direction
			if currentenemy.global_position.x > global_position.x:
					$VisualAnimation.play("RunRight")
			else:
					$VisualAnimation.play("RunLeft")
			move_and_slide()

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
	else:
		army_removed()


func _on_selected_touched_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.global_mouse_entered = false
	GameManager.current_mouse_area = null

func army_selected():
	if !GameManager.currentarchers.has(self):
		GameManager.currentarchers.append(self)
		GameManager.currentsoldiers.append(self)
		GameManager.currentarrows +=1
		Gui.select_archer()
		mousepos = position
		$SelectedSprite.show()
		
		if GameManager.currentpawn != null:
			get_tree().call_group("Pawn", "worker_removed")

func army_removed():
	if GameManager.currentarchers.has(self):
		for i in GameManager.currentarchers:
			if i == self:
				GameManager.currentarchers.erase(i)
				GameManager.currentsoldiers.erase(i)
				GameManager.currentarrows -=1
				Gui.select_archer()
				$SelectedSprite.hide()




func _on_tool_animation_animation_finished(anim_name):
	if currentenemy == null:
		$ToolAnimation.play("detected")
	else:
		if enemyarea == null:
			$ToolAnimation.play("range")

func _on_detected_area_area_entered(area):
	if area.is_in_group("Enemy"):
		if currentenemy == null:
			currentenemy = area
			

func _on_detected_area_area_exited(area):
	if area == currentenemy:
		currentenemy = null
		$ToolAnimation.play("detected")

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
	
		await  $VisualAnimation.animation_finished
		if enemyarea != null:
			Attack()
		else:
			attack = false
			
func create_arrow():
	if enemyarea != null:
		var Arrow = arrow.instantiate()
		get_tree().get_root().add_child(Arrow)
		Arrow.global_position = $ArrowMarker.global_position
		Arrow.target = enemyarea
		Arrow.myarcher = self
		Arrow.archertype = "Archer"

func take_damage():
	if hp >1:
		hp-=1
		$ExtraAnimation.play("take_damage")
	else:
		dead = true
		$ExtraAnimation.play("dead")
		$ArcherArea/CollisionShape2D.disabled = true
		GameManager.livearchers -= 1
		await $ExtraAnimation.animation_finished
		queue_free()


func _on_range_area_area_entered(area):
	if area == currentenemy:
		enemyarea = currentenemy
		Attack()


func _on_range_area_area_exited(area):
	if area == enemyarea:
		#var timer = get_tree().create_timer(1)
		#await timer.timeout 
		enemyarea = null
