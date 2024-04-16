extends CharacterBody2D


var current_resources
var speed
var resources_distance


func _physics_process(delta):
	if current_resources != null:
		resources_distance = current_resources.global_position - global_position
		resources_distance.normalized()
		velocity = resources_distance
		move_and_slide()


func _input(event):
	pass

func _on_selected_touched_pressed():
	if !GameManager.currentpawn.has(self):
		
