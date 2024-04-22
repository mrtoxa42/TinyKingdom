extends Area2D

var resources_name = "Tree"
var count_resources = 100
var over = false
@onready var resources_bar = $ResourcesBar


func _process(delta):
	
	$ResourcesBar.value = count_resources
	
func _on_selected_touched_pressed():
	if GameManager.currentpawn != null and over == false:
		for i in GameManager.currentpawn:
			GameManager.current_mouse_area = "Resources"
			i.current_resources = self
			i.resources_type = "Tree"
			#i.selected_resources()
			i.worker_removed()
			


func _on_selected_touched_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.current_mouse_area = null


func take_damage():
	count_resources -= 30
	pull_resources()
	if count_resources > 0 :
		
		$VisualAnimation.play("take_damage")
		await $VisualAnimation.animation_finished
		$VisualAnimation.play("Idle")
	else:
		over = true
		$VisualAnimation.play("over")
		
	resources_bar.show()
	var timer = get_tree().create_timer(2)
	await timer.timeout
	resources_bar.hide()
func pull_resources():
	
	if count_resources > 80:
		resources_bar.get("theme_override_styles/fill").bg_color = Color.GREEN
	elif count_resources > 60:
		resources_bar.get("theme_override_styles/fill").bg_color = Color.GREEN_YELLOW
		
	elif count_resources > 40:
		resources_bar.get("theme_override_styles/fill").bg_color = Color.YELLOW
	elif count_resources < 20:
		resources_bar.get("theme_override_styles/fill").bg_color = Color.RED



