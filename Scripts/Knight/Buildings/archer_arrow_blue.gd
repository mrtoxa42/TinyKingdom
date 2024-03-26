extends Area2D



var currentenemy 
var enemyarea
var attack = false
var arrow = preload("res://Scenes/Knight/Items/archer_arrow_blue.tscn")


func _on_range_area_area_entered(area):
	if area.is_in_group("Enemy"):
		if enemyarea == null:
			enemyarea = area.get_owner()
			Attack()
		
			
			
func Attack():
	if enemyarea != null:
		attack = true
		if (enemyarea.global_position.y - global_position.y) > 50:
			$ArcherAnimation.play("AttackDown")
		elif (enemyarea.global_position.y - global_position.y) < -50:
			$ArcherAnimation.play("AttackUp")
		elif enemyarea.global_position.x > global_position.x:
			$ArcherAnimation.play("AttackRight")
		else:
			$ArcherAnimation.play("AttackLeft")
	await $ArcherAnimation.animation_finished
	$ArcherAnimation.play("Idle")
	if enemyarea !=null:
		$AttackTimer.start()
	else:
		$ArcherAnimation.play("Idle")
func create_arrow():
	if enemyarea != null:
		var Arrow = arrow.instantiate()
		get_tree().get_root().add_child(Arrow)
		Arrow.global_position = global_position
		Arrow.target = enemyarea
		Arrow.myarcher = self
		Arrow.archertype = "Tower"
func dead_enemy():
	enemyarea = null
	currentenemy = null
	attack = false
	
func _on_attack_timer_timeout():
	if enemyarea != null:
		Attack()
	else:
		$ArcherAnimation.play("Idle")

func _on_range_area_area_exited(area):
	pass
		
