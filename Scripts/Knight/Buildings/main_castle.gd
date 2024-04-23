extends Area2D



func _ready():
	GameManager.maincastle = self
	GameManager.redflag = $RedFlag

