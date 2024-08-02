extends CanvasLayer




var multipletouch = false
var touchcounter = 0
var mutliplecollision = 0
var touch_points = {}
var start_position_knight_tab = Vector2.ZERO
var zoom_touch = false

var touch_point = preload("res://Scenes/Extras/touch_point.tscn")


func _ready():
	start_position_knight_tab = $ArmySelection/ArmySelectionKnight.global_position
	GameManager.middlepoint = $ScreenMiddlePoint.global_position


func _process(delta):
	GameManager.middlepoint = $ScreenMiddlePoint.global_position
	$ArmySelection/ArmySelectionKnight/KnightSelectionLabel.text = "X" + str(GameManager.currentwarriors)
	$ArmySelection/ArmySelectionArcher/ArchersSelectionLabel.text = "X" + str(GameManager.currentarrows)
	$ArmySelection/ArmySelectionPawner/PawnersSelectionLabel.text = "X" + str(GameManager.currentworkers)
	
	$ResourcesGui/ResourcesHBox/WoodHBox/MarginContainer/WoodLabel.text = "X" + str(GameManager.currentwood)
	$ResourcesGui/ResourcesHBox/GoldHBox/MarginContainer/GoldLabel.text = "X" + str(GameManager.currentgold)
	$ResourcesGui/ResourcesHBox/MeatHBox/MarginContainer/MeatLabel.text = "X" + str(GameManager.currentmeat)

func _input(event):
	if event is InputEventScreenTouch and event.double_tap:
		multipletouch = true
		#$CanvasLayer/MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.disabled = false
	if event.is_released():
		multipletouch = false
	
	if event.is_action_pressed("LeftClick"):
		if GameManager.currentsoldiers.size() != 0 or GameManager.currentworkers != 0:
			var timer = get_tree().create_timer(0.1)
			await timer.timeout
			if GameManager.dragged == false and GameManager.selectedbox == false:
				if GameManager.current_mouse_area == null:
					var TouchPoints = touch_point.instantiate()
					TouchPoints.global_position = event.global_position
					get_tree().get_root().add_child(TouchPoints)
				
				elif GameManager.current_mouse_area == "Knight" or "Archer" or "Pawn":
					var TouchPoints = touch_point.instantiate()
					TouchPoints.global_position = GameManager.global_mouse_position
					get_tree().get_root().add_child(TouchPoints)
				
				if GameManager.current_mouse_area == "Resources":
					var TouchPoints = touch_point.instantiate()
					TouchPoints.modulate = Color.GREEN
					TouchPoints.global_position = GameManager.global_mouse_position
					add_child(TouchPoints)
func select_warrior():
	if GameManager.currentwarriors >=1:
		$ArmySelection/ArmySelectionKnight.show()
	else:
		$ArmySelection/ArmySelectionKnight.hide()

func select_archer():
	if GameManager.currentarrows >= 1:
		$ArmySelection/ArmySelectionArcher.show()
	else:
		$ArmySelection/ArmySelectionArcher.hide()
func select_pawner():
	if GameManager.currentworkers >= 1:
		$ArmySelection/ArmySelectionPawner.show()
		$TowerInfo.show()
	else:
		$ArmySelection/ArmySelectionPawner.hide()
		$TowerInfo.hide()



func _on_multiple_selection_army_timer_timeout():
	touchcounter = 0





func _on_knight_removed_button_pressed():
	GameManager.global_mouse_entered = true
	var copycurrentknights = GameManager.currentknights.duplicate()
	for i in copycurrentknights:
		i.army_removed()





func _on_archer_removed_button_pressed():
	GameManager.global_mouse_entered = true
	var copycurrentarchers = GameManager.currentarchers.duplicate()
	for i in copycurrentarchers:
		i.army_removed()



func _on_knight_removed_button_released():
	var timer = get_tree().create_timer(1)
	await timer.timeout
	GameManager.global_mouse_entered = false


func _on_archer_removed_button_released():
	var timer = get_tree().create_timer(1)
	await timer.timeout
	GameManager.global_mouse_entered = false


func _on_pawn_removed_button_pressed():
	GameManager.global_mouse_entered = true
	var copycurrentpawn = GameManager.currentpawn.duplicate()
	for i in copycurrentpawn:
		i.worker_removed()


func _on_pawn_removed_button_released():
	var timer = get_tree().create_timer(1)
	await timer.timeout
	GameManager.global_mouse_entered = false





func _on_right_area_mouse_entered():
	GameManager.mouseboundary = "Right"


func _on_right_area_mouse_exited():
	GameManager.mouseboundary = ""


func _on_left_area_mouse_entered():
	GameManager.mouseboundary = "Left"


func _on_left_area_mouse_exited():
	GameManager.mouseboundary = ""


func _on_up_area_mouse_entered():
	GameManager.mouseboundary = "Up"

func _on_up_area_mouse_exited():
	GameManager.mouseboundary = ""


func _on_down_area_mouse_entered():
	GameManager.mouseboundary = "Down"


func _on_down_area_mouse_exited():
	GameManager.mouseboundary = ""





func _on_house_blue_pressed():
	GameManager.global_mouse_entered = true
	GameManager.BuildSystem.ghost_house()
	var timer = get_tree().create_timer(0.1)
	await timer.timeout
	GameManager.global_mouse_entered = false

	
