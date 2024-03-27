extends CharacterBody2D

var speed = 20
var currentenemy = null
var enemyarea = null
var attack = false
var hp = 3
var dead = false
var enemydistance
var arrow = preload("res://Scenes/Knight/Items/archer_arrow_blue.tscn")


func _physics_process(delta):
	if currentenemy !=null and dead == false:
		enemydistance = currentenemy.global_position - global_position
		var distancelenght = enemydistance.length()
		if distancelenght > 600:
			enemyarea = null
			attack = false
		elif distancelenght < 350:
			enemyarea = currentenemy
			if attack == false:
				Attack()
		if enemyarea == null:
			velocity = enemydistance
			velocity.normalized()
			move_and_slide()
			if velocity != Vector2(0,0) and attack == false:
				if currentenemy.global_position.x > global_position.x:
					$VisualAnimation.play("RunRight")
				else:
					$VisualAnimation.play("RunLeft")


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
	







 
