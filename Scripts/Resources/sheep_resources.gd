extends Area2D


var over = false
var current_resources = 100
var dead = false






func _on_selected_touched_pressed():
	if GameManager.currentpawn != null and over == false:
		for i in GameManager.currentpawn:
			GameManager.current_mouse_area = "Resources"
			i.current_resources = self
			i.resources_type = "Sheep"
			i.selected_resources()
			i.worker_removed()


func _on_selected_touched_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.current_mouse_area = null
