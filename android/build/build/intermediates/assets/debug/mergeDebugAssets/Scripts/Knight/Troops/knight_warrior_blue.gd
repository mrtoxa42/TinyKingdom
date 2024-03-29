extends CharacterBody2D


var currentdetectedenenmy 
var currentenemy
var mousedistance = Vector2.ZERO
var mousepos = Vector2.ZERO
var enemyarea
var speed = 200
var accel = 7
var onnav = false
var hp = 10
var dead = false
var attack = false
@onready var nav: NavigationAgent2D = $NavigationAgent2D


func _physics_process(delta):
		var direction = Vector3()
		nav.target_position = mousepos
		direction = nav.get_next_path_position() - global_position
		#if direction.length() >10:
		if nav.distance_to_target() > 5 :
			onnav = true
			direction = direction.normalized()
			velocity = velocity.lerp(direction * speed, accel * delta)
			move_and_slide()
			if mousepos.x > global_position.x:
				$VisualAnimation.play("RunRight")
			else:
				$VisualAnimation.play("RunLeft")
		else:
			$VisualAnimation.play("Idle")
			onnav = false
		if currentdetectedenenmy != null and enemyarea == null and onnav == false:
			velocity = currentdetectedenenmy.global_position - global_position
			#velocity.normalized()
			if velocity != Vector2(0,0) and attack == false:
				if mousepos.x > global_position.x:
					$VisualAnimation.play("RunRight")
				else:
					$VisualAnimation.play("RunLeft")
			else:
				$VisualAnimation.play("Idle")
			
		

func _process(delta):
	if Input.is_action_just_pressed("LeftClick"):
		mousepos = get_global_mouse_position()
	

func _on_detected_area_area_entered(area):
	if area.is_in_group("Enemy") and enemyarea == null:
		if currentdetectedenenmy == null:
			currentdetectedenenmy = area
			
func take_damage():

	if hp >1:
		hp-=1
		$ExtraAnimation.play("take_damage")
	else:
		dead = true
		$ExtraAnimation.play("dead")
		$KnightArea/CollisionShape2D.disabled = true
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
		currentdetectedenenmy = null
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
	if GameManager.currentsoldiers.has(self) == false:
		GameManager.currentsoldiers.append(self)
	print(GameManager.currentsoldiers)
	

