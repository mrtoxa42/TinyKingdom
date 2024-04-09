extends CanvasLayer




var multipletouch = false
var touchcounter = 0
var mutliplecollision = 0
var touch_points = {}
var start_position_knight_tab = Vector2.ZERO

func _ready():
	start_position_knight_tab = $ArmySelection/ArmySelectionKnight.global_position
func _process(delta):
	$ArmySelection/ArmySelectionKnight/KnightSelectionLabel.text = "X" + str(GameManager.currentwarriors)
	$ArmySelection/ArmySelectionArcher/ArchersSelectionLabel.text = "X" + str(GameManager.currentarrows)
	if multipletouch == true:
		$MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.shape.radius +=10
		$MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.disabled = false
		$MultipleSelectionArmy/MultipleSelectionArmyArea/MultipleCircle.show()
		$MultipleSelectionArmy.global_position = GameManager.global_mouse_position
		#$MultipleSelectionArmy/MultipleSelectionArmyArea/MultipleCircle.scale 
		
		$MultipleSelectionArmy/MultipleSelectionArmyArea/MultipleCircle.scale = Vector2($MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.shape.radius,$MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.shape.radius) / 14
	else:
		$MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.shape.radius = 0
		$MultipleSelectionArmy/MultipleSelectionArmyArea/MultipleCircle.scale = Vector2(0,0)
		$MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.disabled = true
		$MultipleSelectionArmy/MultipleSelectionArmyArea/MultipleCircle.hide()

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
 

	
func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touchcounter +=1
		if touchcounter == 2:
			multipletouch = true
		$MultipleSelectionArmy/MultipleSelectionArmyTimer.start()
	else:
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

func _on_multiple_selection_army_area_area_entered(area):
	if area.is_in_group("Soldier"):
		area.get_owner().army_selected()


func _on_multiple_selection_army_timer_timeout():
	touchcounter = 0



func _on_knight_selection_area_mouse_shape_entered(shape_idx):
	GameManager.global_mouse_entered = true

func _on_knight_selection_area_mouse_shape_exited(shape_idx):
	GameManager.global_mouse_entered = false
	


func _on_knight_removed_button_pressed():
	var copycurrentknights = GameManager.currentknights.duplicate()
	for i in copycurrentknights:
		i.army_removed()



func _on_archer_selection_area_area_entered(area):
	GameManager.global_mouse_entered = true


func _on_archer_selection_area_area_exited(area):
	GameManager.global_mouse_entered = false


func _on_archer_removed_button_pressed():
	var copycurrentarchers = GameManager.currentarchers.duplicate()
	for i in copycurrentarchers:
		i.army_removed()
