extends CharacterBody2D


var hp = 1
var speed = 200
var accel = 7
var dead = false
var enemyarea 
var archerarea
var patharea
var pathpos
@onready var nav = $NavigationAgent2D


func _physics_process(delta):
	if dead == false:
		var direction = Vector2()
		
		nav.target_position = GameManager.currentfinish.global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		
		move_and_slide()
		if direction != Vector2(0,0):
			$VisualAnimation.play("RunRight")




func take_damage():
	if dead == false:
		if hp >= 1:
			hp-=1
			$ToolAnimation.play("takedamage")
		else:
			dead = true
			$ToolAnimation.play("dead")
			$CollisionShape2D.disabled = true
			if archerarea != null:
				archerarea.dead_enemy()
				$GoblinTorchArea/CollisionShape2D.disabled = true	
			await $ToolAnimation.animation_finished
			queue_free()


func _on_goblin_torch_area_area_entered(area):
	if area.is_in_group("Knight"):
		enemyarea = area
	if area.is_in_group("Arrow"):
		archerarea = area.myarcher
		if enemyarea == null:
			enemyarea = area.myarcher
			



func _on_goblin_torch_area_area_exited(area):
	if area.is_in_group("Knight"):
		pass
			
