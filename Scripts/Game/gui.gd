extends CanvasLayer




var multipletouch = false
var touchcounter = 0
var mutliplecollision = 0
var touch_points = {}
var start_position_knight_tab = Vector2.ZERO
var zoom_touch = false




func _ready():
	start_position_knight_tab = $ArmySelection/ArmySelectionKnight.global_position


func _process(delta):
	$ArmySelection/ArmySelectionKnight/KnightSelectionLabel.text = "X" + str(GameManager.currentwarriors)
	$ArmySelection/ArmySelectionArcher/ArchersSelectionLabel.text = "X" + str(GameManager.currentarrows)
	$ArmySelection/ArmySelectionPawner/PawnersSelectionLabel.text = "X" + str(GameManager.currentworkers)

func _input(event):
	if event is InputEventScreenTouch and event.double_tap:
		multipletouch = true
		#$CanvasLayer/MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.disabled = false
	if event.is_released():
		multipletouch = false
	


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
