extends Node2D

var tween
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.game_in = false
	var tween = get_tree().create_tween()
	tween.tween_property($UI/RedLabels/InfiniteSoonLabel,"scale",Vector2(1.5,1.5),1)
	tween.connect("finished",tween_finished)
	
	

func tween_finished():
	if $UI/RedLabels/InfiniteSoonLabel.scale == Vector2(1.5,1.5):
		var tween = get_tree().create_tween()
		tween.tween_property($UI/RedLabels/InfiniteSoonLabel,"scale",Vector2(1,1),1)
		tween.connect("finished",tween_finished)
	if $UI/RedLabels/InfiniteSoonLabel.scale == Vector2(1,1):
		var tween = get_tree().create_tween()
		tween.tween_property($UI/RedLabels/InfiniteSoonLabel,"scale",Vector2(1.5,1.5),1)
		tween.connect("finished",tween_finished)
	

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


func _on_campaing_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/levels.tscn")


func _on_rogue_duck_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Extras/rogue_duck.tscn")


func _on_how_to_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menu/how_to_play.tscn")
