extends CharacterBody2D

var speed = 100
var accel = 7
var over = false
var count_resources = 100
var dead = false
var move_pos = Vector2.ZERO
var direction
var workers = []
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var resources_bar: ProgressBar = $ResourcesBar

func _ready():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var r = rng.randf_range(3,8)
	$MoveTimer.wait_time = r
	move_pos = global_position
	$MoveTimer.start()
	
func _process(delta):
	resources_bar.value = count_resources

func _physics_process(delta):
	if dead == false:
		direction = Vector3()
		nav.target_position = move_pos
		direction = nav.get_next_path_position() - global_position
		if nav.distance_to_target() > 35:
			direction = direction.normalized()
			velocity = velocity.lerp(direction * speed, accel * delta)
			move_and_slide()
			$AnimationPlayer.play("Happy")
			if move_pos.x > global_position.x:
				$SheepSprite.flip_h = false
			else:
				$SheepSprite.flip_h = true
		else:
			$AnimationPlayer.play("Idle")



func _on_selected_touched_pressed():
	if GameManager.currentpawn != null and over == false:
		for i in GameManager.currentpawn:
			GameManager.current_mouse_area = "Resources"
			i.current_resources = self
			i.resources_type = "Sheep"
			i.selected_resources()
			workers.append(i)


func _on_selected_touched_released():
	var timer = get_tree().create_timer(0,6)
	await timer.timeout
	GameManager.current_mouse_area = null


func _on_move_timer_timeout():
	if dead == false:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var rx = rng.randi_range(-300,300)
		var ry = rng.randi_range(-300,300)
		move_pos = global_position - Vector2(rx,ry)
		var rng2 = RandomNumberGenerator.new()
		rng2.randomize()
		var r = rng2.randf_range(3,12)
		$MoveTimer.wait_time = r
		

func take_damage():
		dead = true
		$AnimationPlayer.play("Dead")
			

func pull_resources():
	if count_resources >0:
		count_resources -= 10
	else:
		over = true
		for i in workers:
			#i.gathering_meat()
			i.forget_resources()
			queue_free()
	resources_bar.show()
	if count_resources > 80:
		resources_bar.get("theme_override_styles/fill").bg_color = Color.GREEN
	elif count_resources > 60:
		resources_bar.get("theme_override_styles/fill").bg_color = Color.GREEN_YELLOW
		
	elif count_resources > 40:
		resources_bar.get("theme_override_styles/fill").bg_color = Color.YELLOW
	elif count_resources < 20:
		resources_bar.get("theme_override_styles/fill").bg_color = Color.RED
	var timer = get_tree().create_timer(2)
	await timer.timeout
	resources_bar.hide()
