extends Node2D

func _ready():
		if GameManager.current_mouse_area == null:
			play_touch()
		else:
			play_selected()
func play_touch():
	$AnimationPlayer.play("TouchAni")
	show()
	
func play_selected():
	$AnimationPlayer.play("SelectAni")
	show()
	
