extends Node2D



func _ready():
	GameManager.currentfinish = $Finish
	GameManager.currentlevel = self
	 
func create_bake_polygon():
	$NavigationRegion2D.bake_navigation_polygon(true)

func _process(delta):
	pass
#func _on_game_started_timeout():
	#$NavigationRegion2D.bake_navigation_polygon(true)

