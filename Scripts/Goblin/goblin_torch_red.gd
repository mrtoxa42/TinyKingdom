extends CharacterBody2D



var hp = 3
var speed = 50
var enemyspeed = 10
var accel = 7
var dead = false
var currentenemy 
var enemyarea
var archerarea
var attack = false
var enemydistance = null
@onready var nav = $NavigationAgent2D


func _physics_process(delta):
	if dead == false:
		if currentenemy == null and enemyarea == null:
			var direction = Vector2()
		
			nav.target_position = GameManager.currentfinish.global_position
		
			direction = nav.get_next_path_position() - global_position
			direction = direction.normalized()
		
			velocity = velocity.lerp(direction * speed, accel * delta)
		
			move_and_slide()
			if nav.get_next_path_position().x > global_position.x:
				$VisualAnimation.play("RunRight")
			else:
				$VisualAnimation.play("RunLeft")
		else:
			if enemyarea == null:
				
				if enemydistance == null:
					
					enemydistance = currentenemy.global_position - global_position 
					enemydistance.normalized()
				velocity = enemydistance * delta * enemyspeed
				move_and_slide()
				if velocity != Vector2(0,0) and attack == false:
					if currentenemy.global_position.x > global_position.x:
						$VisualAnimation.play("RunRight")
					else:
						$VisualAnimation.play("RunLeft")


func Attack():
	if dead == false:
		attack = true
		if (currentenemy.global_position.y - global_position.y) > 50:
				$VisualAnimation.play("AttackDown")
		elif (currentenemy.global_position.y - global_position.y) < -50:	
			$VisualAnimation.play("AttackUp")
		elif currentenemy.global_position.x > global_position.x:
			$VisualAnimation.play("AttackRight")
		else:
			$VisualAnimation.play("AttackLeft")
		await $VisualAnimation.animation_finished
		$VisualAnimation.play("Idle")
		$AttackTimer.start()
	

func take_damage():
	if dead == false:
		hp -=1
		if hp == 0:
			dead = true
			$ToolAnimation.play("dead")
			$CollisionShape2D.disabled = true
			$GoblinTorchArea.queue_free()
			await $ToolAnimation.animation_finished
			queue_free()
		else:
			$ToolAnimation.play("takedamage")


func deal_damage():
	if enemyarea != null:
		enemyarea.take_damage()
		




func _on_goblin_torch_area_area_entered(area):
	if enemyarea == null:
		if area.is_in_group("Knight"):
				currentenemy = area
				enemyarea = area.get_owner()
				Attack()
		if area.is_in_group("Arrow"):
			if area.archertype == "Archer":
				archerarea = area.myarcher
				if currentenemy == null:
					currentenemy = area.myarcher
		if area.is_in_group("Archer"):
			if currentenemy == null:
				currentenemy = area
			if enemyarea == null:
				enemyarea = area.get_owner()
				Attack()
			



func _on_goblin_torch_area_area_exited(area):
	if area.is_in_group("Knight"):
		if area.get_owner() == enemyarea:
			enemyarea = null
			currentenemy = null
	if area.is_in_group("Archer"):
		if area.get_owner() == enemyarea:
			enemyarea = null
			currentenemy = null
			


func _on_attack_timer_timeout():
	if enemyarea !=null and dead == false:
		Attack()
