extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.game_in = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_campain_area_mouse_entered():
	$UI/CampaingButton.scale = Vector2(2.2,2.2)



func _on_campain_area_mouse_exited():
	$UI/CampaingButton.scale = Vector2(2,2)


func _on_infinite_mode_area_mouse_entered():
	$UI/InfiniteModeButton.scale = Vector2(2.2,2.2)


func _on_infinite_mode_area_mouse_exited():
	$UI/InfiniteModeButton.scale = Vector2(2,2)


func _on_how_to_play_area_mouse_entered():
	$UI/HowToPlayButton.scale = Vector2(2.2,2.2)


func _on_how_to_play_area_mouse_exited():
	$UI/HowToPlayButton.scale = Vector2(2,2)
