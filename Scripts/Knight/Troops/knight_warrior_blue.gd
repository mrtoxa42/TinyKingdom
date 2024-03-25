extends CharacterBody2D


var currentdetectedenenmy 
var currentenemy
var enemyarea
var speed = 20
var hp = 5
var attack = false
func _process(delta):
	if currentdetectedenenmy != null and enemyarea == null:
		velocity = currentdetectedenenmy.global_position - global_position
		velocity.normalized()
		if velocity != Vector2(0,0) and attack == false:
			if currentdetectedenenmy.global_position.x > global_position.x:
				$VisualAnimation.play("RunRight")
			else:
				$VisualAnimation.play("RunLeft")
			move_and_slide()
	if currentdetectedenenmy == null and attack == false and enemyarea == null:
		$VisualAnimation.play("Idle")

func _on_detected_area_area_entered(area):
	if area.is_in_group("Enemy") and enemyarea == null:
		if currentdetectedenenmy == null:
			currentdetectedenenmy = area
			
func take_damage():
	if hp >1:
		hp -=1
		$ExtraAnimation.play("take_damage")
	else:
		$ToolAnimation.play("dead")
		$KnightArea/CollisionShape2D.disabled = true
		await $ToolAnimation.animation_finished
		queue_free()
		


func _on_knight_area_area_entered(area):
	if area.is_in_group("Enemy"):
		enemyarea = area.get_owner()
		Attack()
		

func _on_attack_timer_timeout():
	if enemyarea !=null:
		Attack()
	
func _on_knight_area_area_exited(area):
	pass # Replace with function body.
	
	
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
		enemyarea.take_damage()
func dead_enemy():
	enemyarea = null
	currentdetectedenenmy = null
	attack = false

	


