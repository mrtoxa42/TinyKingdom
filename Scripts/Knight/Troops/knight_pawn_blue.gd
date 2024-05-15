extends CharacterBody2D


var current_resources = null
var gathering_resources = false
var castle_area = false
var resources_type = ""
var resources_area = false
var flag_pos
var speed = 200
var accel = 7
var onnav = false
var work_metter = 0
var resources_distance
var direction 
var mousepos = Vector2.ZERO
var army_line
@onready var nav = $NavigationAgent2D




func _process(delta):
	#if current_resources != null:
		#if current_resources.over == true:
			#current_resources = null
	pass
func _physics_process(delta):
	if current_resources == null and gathering_resources == false:
		if GameManager.currentpawn.has(self) or onnav == true:
			direction = Vector3()
			nav.target_position = mousepos
			direction = nav.get_next_path_position() - global_position
			if nav.distance_to_target() > 75:
				direction = direction.normalized()
				velocity = velocity.lerp(direction * speed, accel * delta)
				move_and_slide()
				if mousepos.x > global_position.x:
					$VisualAnimation.play("RunRight")
				else:
					$VisualAnimation.play("RunLeft")
			else:
				$VisualAnimation.play("Idle")
				
	else:
		if current_resources != null and gathering_resources == false and current_resources.over == false:
			direction = Vector3()
			nav.target_position = current_resources.global_position
			direction = nav.get_next_path_position() - global_position
			if nav.distance_to_target() > 75:
				direction = direction.normalized()
				velocity = velocity.lerp(direction * speed, accel * delta)
				move_and_slide()
				if current_resources.global_position.x > global_position.x:
					$VisualAnimation.play("RunRight")
				else:
					$VisualAnimation.play("RunLeft")
			else:
				if resources_area == false:
					resources_area = true
					start_working()
					

	if gathering_resources == true:
		direction = Vector3()
		nav.target_position = GameManager.maincastle.global_position
		direction = nav.get_next_path_position() - global_position
		if nav.distance_to_target() > 75:
			direction = direction.normalized()
			velocity = velocity.lerp(direction * speed, accel * delta)
			move_and_slide()
			if GameManager.maincastle.global_position.x > global_position.x:
				$VisualAnimation.play("GatheringRunRight")
			else:
				$VisualAnimation.play("GatheringRunLeft")


func _input(event):
	if event.is_released() and event is InputEventScreenTouch and GameManager.dragged == false:
		if GameManager.global_mouse_entered == false and GameManager.currentpawn.has(self):      
			army_line = GameManager.currentpawn.find(self)
			var army_pos = GameSystem.get_node("CanvasLayer/ArmyFormationPawner/Formation" + str(army_line)).global_position
			mousepos = army_pos
			onnav = true
			show()
			#current_resources = null
			if GameManager.current_mouse_area == "Resources":
				pass
			else:
				forget_resources()


func _on_selected_touched_pressed():
	GameManager.global_mouse_entered = true
	GameManager.current_mouse_area = "Pawn"
	if !GameManager.currentpawn.has(self):
		worker_selected()
	else:
		worker_removed()


func _on_selected_touched_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.global_mouse_entered = false
	GameManager.current_mouse_area = null


func worker_selected():
	if !GameManager.currentpawn.has(self):
		GameManager.currentpawn.append(self)
		GameManager.currentworkers +=1
		mousepos = position
		Gui.select_pawner()
		$SelectedSprite.show()
		
		if GameManager.currentknights != null:
			get_tree().call_group("Knight", "army_removed")
		if GameManager.currentarchers != null:
			get_tree().call_group("Archer", "army_removed")
func worker_removed():
	if GameManager.currentpawn.has(self):
		GameManager.currentpawn.erase(self)
		GameManager.currentworkers -= 1
		Gui.select_pawner()
		$SelectedSprite.hide()
		
		

func selected_resources():
	pass

func start_working():
	if current_resources != null:
		if current_resources.over == true:
			current_resources = null
		if resources_type == "Tree" and current_resources != null:
			work_metter +=1
			if current_resources.global_position.x > global_position.x:
				$VisualAnimation.play("GatheringRight")
			elif current_resources.global_position.x < global_position.x:
				$VisualAnimation.play("GatheringLeft")
			await  $VisualAnimation.animation_finished
			if work_metter < 3:
				#if current_resources != null:
					start_working()
			else:
				gathering_wood()
		if resources_type == "GoldMine" and current_resources != null:
			enter_mine()

	if current_resources != null:
		if resources_type == "Sheep":
			if current_resources.dead == false and current_resources.over == false:
				if current_resources.global_position.x > global_position.x:
					$VisualAnimation.play("GatheringRight")
				else:
					$VisualAnimation.play("GatheringLeft")
				await  $VisualAnimation.animation_finished
				if current_resources.dead == true:
					start_working()
			else:
				if work_metter < 3  and current_resources.over == false:
					work_metter +=1
					if current_resources.global_position.x > global_position.x:
						$VisualAnimation.play("BuildRight")
					elif current_resources.global_position.x < global_position.x:
						$VisualAnimation.play("BuildLeft")
					await  $VisualAnimation.animation_finished
					start_working()
				else:
					gathering_meat()


func gathering_wood():
	if work_metter > 0:
		work_metter = 0
		$ResourcesSprite.show()
		if resources_type == "Tree":
			if current_resources != null:
				$ResourcesSprite.global_position = current_resources.global_position
		$ResourcesSprite.play("wood")
		await $ResourcesSprite.animation_finished
		$ResourcesSprite.global_position = $ResourcesPosition.global_position
		gathering_resources = true
		resources_area = false
		
		
func enter_mine():
	hide()
	current_resources.Actived()
	var timer = get_tree().create_timer(1)
	await timer.timeout
	exit_mine()
func exit_mine():
	if current_resources != null and resources_type == "GoldMine":
		$ResourcesSprite.play("gold")
		await  $ResourcesSprite.animation_finished
		if current_resources !=null and resources_type == "GoldMine":
			current_resources.Actived()
			current_resources.pull_resources()
		$ResourcesSprite.show()
		$ResourcesSprite.global_position = $ResourcesPosition.global_position
		gathering_resources = true
		resources_area = false
		show()
	else:
		show()
		
func gathering_meat():
	current_resources.pull_resources()
	work_metter = 0
	$ResourcesSprite.show()
	if current_resources != null:
		$ResourcesSprite.play("meat")
	else:
		$ResourcesSprite.play("sheep")
	if current_resources != null:
		$ResourcesSprite.global_position = current_resources.global_position
		await  $ResourcesSprite.animation_finished
	$ResourcesSprite.global_position = $ResourcesPosition.global_position
	gathering_resources = true
	resources_area = false
func feedback_resources():
	current_resources = null
func resources_damage():
	if current_resources != null and current_resources.over == false:
		current_resources.take_damage()

func forget_resources():
	show()
	$ResourcesSprite.hide()
	current_resources = null
	resources_area = false
	resources_type = null

func _on_knight_pawn_blue_area_area_entered(area):
	if area.is_in_group("Castle"):
		if gathering_resources == true:
			gathering_resources = false
			$ResourcesSprite.hide()
		
		
