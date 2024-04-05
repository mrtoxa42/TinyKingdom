extends CanvasLayer




var multipletouch = false
var touchcounter = 0
var mutliplecollision = 0
var touch_points = {}
func _process(delta):
	$ArmySelection/ArmySelectionKnight/KnightSelectionLabel.text = "X" + str(GameManager.currentwarriors)
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



func _on_multiple_selection_army_area_area_entered(area):
	if area.is_in_group("Soldier"):
		area.get_owner().army_selected()


func _on_multiple_selection_army_timer_timeout():
	touchcounter = 0



func _on_touch_selected_knight_pressed():
	$ArmySelection/ArmySelectionKnight/KnightSelectAnimation.play("AniSelectedKnight")


func _on_touch_selected_knight_released():
	$ArmySelection/ArmySelectionKnight/KnightSelectAnimation.play("AniUnSelectedKnight")


func _on_knight_selection_area_mouse_shape_entered(shape_idx):
	GameManager.global_mouse_entered = true

func _on_knight_selection_area_mouse_shape_exited(shape_idx):
	GameManager.global_mouse_entered = false
