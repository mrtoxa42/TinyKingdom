extends CanvasLayer




var multipletouch = false
var touchcounter = 0
var mutliplecollision = 0
func _process(delta):
	$ArmySelection/ArmySelectionKnight/KnightSelectionLabel.text = "X" + str(GameManager.currentwarriors)
	if multipletouch == true:
		$MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.shape.radius +=10
		#$MultipleSelectionArmy/MultipleSelectionArmyArea/MultipleCircle.scale 
	else:
		$MultipleSelectionArmy/MultipleSelectionArmyArea/CollisionShape2D.shape.radius = 0
	

func select_warrior():
	if GameManager.currentwarriors >=1:
		$ArmySelection/ArmySelectionKnight.show()
	else:
		$ArmySelection/ArmySelectionKnight.hide()


func _on_multiple_selection_army_timer_timeout():
	if touchcounter == 0:
		touchcounter = 0
		multipletouch = false
	elif touchcounter == 1:
		multipletouch = true
		touchcounter = 0
		


func _on_multiple_selection_army_touch_pressed():
	if touchcounter == 0:
		touchcounter = 1
		
	elif touchcounter == 1:
		$MultipleSelectionArmy/MultipleSelectionArmyTimer.start()


func _on_multiple_selection_army_touch_released():
	multipletouch = false
	if touchcounter == 1:
		touchcounter == 0
