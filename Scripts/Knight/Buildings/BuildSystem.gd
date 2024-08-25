extends Node2D


var house = preload("res://Scenes/Knight/Buildings/knight_house.tscn")

var currentghostbuild
var otherarea = false

func _ready():
	GameManager.BuildSystem = self
func _process(delta):
	
	#if currentghostbuild != null:
		#$GhostSprite.global_position = get_global_mouse_position()
		#
	pass


func _input(event):
	if event.is_pressed():
		var timer = get_tree().create_timer(0.1)
		await timer.timeout
		if currentghostbuild == "House" and GameManager.global_mouse_entered == false and GameManager.dragged == false:
			global_position = get_global_mouse_position()






func build_started():
	GameManager.build_started = true
	
func build_finished():
	GameManager.build_started = false



func ghost_house():
	$GhostSprite.self_modulate = Color.WHITE
	show()
	$GhostSprite.texture = load("res://Assets/Tiny Swords (Update 010)/Factions/Knights/Buildings/House/House_Blue.png")
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	currentghostbuild = "House"


func build_house():
	currentghostbuild = null
	hide()
	build_finished()
func _on_ghost_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Build") or area.is_in_group("Resources"):
		$GhostSprite.self_modulate = Color.RED
		otherarea = true


func _on_ghost_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Build") or area.is_in_group("Resources"):
		$GhostSprite.self_modulate = Color.WHITE
		otherarea = false


func _on_accept_button_pressed() -> void:
	GameManager.global_mouse_entered = true
	if otherarea == false:
		building()


func _on_accept_button_released() -> void:
	var timer = get_tree().create_timer(0.1)
	await timer.timeout
	GameManager.global_mouse_entered = false


func _on_cancel_button_pressed() -> void:
	GameManager.global_mouse_entered = true


func _on_cancel_button_released() -> void:
	var timer = get_tree().create_timer(0.1)
	await timer.timeout
	GameManager.global_mouse_entered = false


func building():
	if currentghostbuild == "House":
		var House = house.instantiate()
		get_tree().get_root().add_child(House)
		House.global_position = $GhostSprite.global_position
		for i in GameManager.currentpawn:
			i.current_build = house
		hide()
		build_finished()
		
