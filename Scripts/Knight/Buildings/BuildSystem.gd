extends Node2D


var house = preload("res://Scenes/Knight/Buildings/knight_house.tscn")

var currentghostbuild
var otherarea = false

func _ready():
	GameManager.BuildSystem = self
func _process(delta):
	if currentghostbuild != null:
		$GhostSprite.global_position = get_global_mouse_position()


func _input(event):
	if event.is_pressed():
		if currentghostbuild != null and otherarea == false and GameManager.global_mouse_entered == false:
			currentghostbuild = null
			var House = house.instantiate()
			get_tree().get_root().add_child(House)
			House.global_position = get_global_mouse_position()

		
		


func ghost_house():
	currentghostbuild = "House"
	$GhostSprite.texture = load("res://Assets/Tiny Swords (Update 010)/Factions/Knights/Buildings/House/House_Blue.png")


func _on_ghost_area_area_entered(area):
	if area.is_in_group("Resources") or area.is_in_group("Build"):
		otherarea = true
		$GhostSprite.modulate = Color.RED


func _on_ghost_area_area_exited(area):
	if area.is_in_group("Resources") or area.is_in_group("Build"):
		otherarea = true
		$GhostSprite.modulate = Color.WHITE
		$GhostSprite.modulate.a = 0.5
