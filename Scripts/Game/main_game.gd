extends Node2D



func _ready():
	GameManager.maincastle = $MainCastle
	GameManager.currentfinish = $Finish
	GameManager.currentlevel = self
	$NavigationRegion2D.bake_navigation_polygon(true)
	 
func create_bake_polygon():
	$NavigationRegion2D.bake_navigation_polygon(true)

func _process(delta):
	pass
#func _on_game_started_timeout():
	#$NavigationRegion2D.bake_navigation_polygon(true)

func new_bake_navigation():
	$NavigationRegion2D.bake_navigation_polygon(true)
