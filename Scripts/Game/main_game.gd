extends Node2D
#
@onready var minimap_camera = $CanvasLayer/MiniMap/MinimapViewport/Camera2D
@onready var camera = $Camera2D
#@onready var minimap_icon = $CanvasLayer/MiniMap/SubViewportContainer/Icon

func _ready():
	#get_tree().paused = true+
	GameManager.game_navigation_node = $NavigationRegion2D
	GameManager.game_in = true
	GameManager.currentfinish = $Finish
	GameManager.currentlevel = self
	$NavigationRegion2D.bake_navigation_polygon(true)
	 
func create_bake_polygon():
	$NavigationRegion2D.bake_navigation_polygon(true)
		

func _process(delta):
	#minimap_icon.position = $KnigthArcherBlue.position / 10
	minimap_camera.position = camera.position
	
	GameManager.global_mouse_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("ui_select"):
		$LevelAni/LevelAnimation.speed_scale = 4
	
#func _on_game_started_timeout():
	#$NavigationRegion2D.bake_navigation_polygon(true)

func new_bake_navigation():
	$NavigationRegion2D.bake_navigation_polygon(true)
	print("geldi bake")



func _on_level_animation_animation_finished(anim_name):
	get_tree().paused = false
