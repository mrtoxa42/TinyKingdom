extends Area2D


var target
var currentenemy
var myarcher
var speed = 15


func _physics_process(delta):
	if target !=null:
		var velocity = target.global_position - global_position
		velocity.normalized()
		position +=velocity * delta * speed
		look_at(target.global_position)


		


func _on_area_entered(area):
	if area.is_in_group("Enemy"):
		currentenemy = area
		if currentenemy != null:
			currentenemy.get_owner().take_damage()
			queue_free()
			


func _on_destroyed_timer_timeout():
	queue_free()
