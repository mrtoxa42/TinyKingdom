extends Node2D


@onready var minimap_icon = $CanvasLayer/MiniMap/SubViewportContainer/Icon

func _ready():
	GameManager.currentfinish = $Finish
	GameManager.currentlevel = self
	$NavigationRegion2D.bake_navigation_polygon(true)
	 
func create_bake_polygon():
	$NavigationRegion2D.bake_navigation_polygon(true)

func _process(delta):
	minimap_icon.position = $KnigthArcherBlue.position / 10
	pass
#func _on_game_started_timeout():
	#$NavigationRegion2D.bake_navigation_polygon(true)

func new_bake_navigation():
	$NavigationRegion2D.bake_navigation_polygon(true)


	
