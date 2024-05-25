extends Area2D


@onready var CastleDoor: Marker2D = $CastleDoor
func _ready():
	GameManager.maincastle = self
	GameManager.redflag = $RedFlag

