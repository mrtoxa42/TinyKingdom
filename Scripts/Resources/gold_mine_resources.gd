extends Area2D



var count_resources = 100
var over = false
var actived = false
var workers = []
@onready var resources_bar = $ResourcesBar


func _process(delta):
	resources_bar.value = count_resources


func _on_selected_touched_pressed():
	if GameManager.currentpawn != null and over == false:
		for i in GameManager.currentpawn:
			i.forget_resources()
			GameManager.current_mouse_area = "Resources"
			i.current_resources = self
			i.resources_type = "GoldMine"
			#i.selected_resources()
			workers.append(i)


func _on_selected_touched_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.current_mouse_area = null


func Actived():
	$AnimationPlayer.play("Activie")
	
func DeActived():
	if workers == null:
		$AnimationPlayer.play("DeActive")


func pull_resources():
	count_resources -= 1
	if count_resources > 0 :
		if count_resources > 80:
			resources_bar.get("theme_override_styles/fill").bg_color = Color.GREEN
		elif count_resources > 60:
			resources_bar.get("theme_override_styles/fill").bg_color = Color.GREEN_YELLOW
			
		elif count_resources > 40:
			resources_bar.get("theme_override_styles/fill").bg_color = Color.YELLOW
		elif count_resources < 20:
			resources_bar.get("theme_override_styles/fill").bg_color = Color.RED
	else:
		over = true
		$AnimationPlayer.play("over")
		if workers != null:
			for i in workers:
				i.forget_resources()
				i.exit_mine()
				workers.erase(i)
		


