extends Area2D

var resources_name = "Tree"
var count_resources = 20
var over = false
var workers = []
@onready var resources_bar = $ResourcesBar


func _process(delta):
	
	$ResourcesBar.value = count_resources
	
func _on_selected_touched_pressed():
	if GameManager.currentpawn != null and over == false:
		for i in GameManager.currentpawn:
			i.forget_resources()
			GameManager.current_mouse_area = "Resources"
			i.current_resources = self
			i.resources_type = "Tree"
			#i.selected_resources()
			workers.append(i)



func _on_selected_touched_released():
	var timer = get_tree().create_timer(0.6)
	await timer.timeout
	GameManager.current_mouse_area = null


func take_damage():
	if over == false:
		count_resources -= 1
		pull_resources()
		if count_resources > 0 :
			
			$VisualAnimation.play("take_damage")
			await $VisualAnimation.animation_finished
			if over == false:
				$VisualAnimation.play("Idle")
		else:
			if over == false:
				over = true
				$VisualAnimation.play("over")
				if workers !=null:
					for i in workers:
						i.forget_resources()
						i.gathering_wood()
						workers.erase(i)
	else:
		
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





func _on_visual_animation_animation_finished(anim_name):
	if over == true and anim_name != "over":
		$VisualAnimation.play("over")
