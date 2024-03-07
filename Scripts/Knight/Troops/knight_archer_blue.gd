extends CharacterBody2D

var speed = 20
var currentenemy = null
var enemyarea = null
var attack = false
var arrow = preload("res://Scenes/Knight/Items/archer_arrow_blue.tscn")
func _physics_process(delta):
	if currentenemy !=null and enemyarea == null:
		velocity = currentenemy.global_position - global_position
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


func _on_range_area_area_entered(area):
	if area.is_in_group("Enemy"):
		if enemyarea == null:
			enemyarea = area
			Attack()
		
func Attack():
	if enemyarea != null:
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
	if enemyarea !=null:
		$AttackTimer.start()
func create_arrow():
	if enemyarea != null:
		var Arrow = arrow.instantiate()
		get_tree().get_root().add_child(Arrow)
		Arrow.global_position = global_position
		Arrow.target = enemyarea
		Arrow.myarcher = self
func dead_enemy():
	enemyarea = null
	currentenemy = null
	attack = false
	
func take_damage():
	$AnimationTree
func _on_attack_timer_timeout():
	if enemyarea != null:
		Attack()
	else:
		dead_enemy()
