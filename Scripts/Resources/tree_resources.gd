extends Area2D

var resources_name = "Tree"
var count_resources = 3




func _on_selected_touched_pressed():
	if GameManager.currentpawn != null:
		for i in GameManager.currentpawn:
			GameManager.current_mouse_area = "Resources"
			i.current_resources = self
			i.resources_type = "Tree"
			i.selected_resources()



func _on_selected_touched_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.current_mouse_area = null


func take_damage():
	count_resources -= 1
	if count_resources > 0 :
		$VisualAnimation.play("take_damage")
		await $VisualAnimation.animation_finished
		$VisualAnimation.play("Idle")
	else:
		$VisualAnimation.play("over")
func pull_resources():
	pass
