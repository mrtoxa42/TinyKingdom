# Minimap.gd
extends Control

@onready var minimap_texture = $MinimapTexture
@onready var soldiers = $MinimapViewport/Map/Soldiers
@onready var workers = $MinimapViewport/Map/Workers
@onready var buildings = $MinimapViewport/Map/Buildings

# Ana haritanın ve minimap'in boyutlarını belirleyin
var map_width = 1024
var map_height = 1024
var minimap_width = 256
var minimap_height = 256

# Ölçek faktörünü hesaplayın
var scale_factor = float(map_width) / minimap_width

func _ready():
	# ViewportTexture atama
	var viewport_texture = $MinimapViewport.get_texture()
	minimap_texture.texture = viewport_texture

func _process(delta):
	update_minimap()

func update_minimap():
	# Mini haritayı güncelleyen fonksiyon
	for soldier in get_tree().get_nodes_in_group("Soldiers"):
		update_sprite_position(soldiers, soldier)

	for worker in get_tree().get_nodes_in_group("Pawn"):
		update_sprite_position(workers, worker)

	for building in get_tree().get_nodes_in_group("Build"):
		update_sprite_position(buildings, building)

func update_sprite_position(parent_node, game_object):
	var sprite_name = str(game_object.name)  # `name`'i stringe çevirme
	if parent_node.has_node(sprite_name):
		var sprite = parent_node.get_node(sprite_name)
		sprite.position = game_object.position / scale_factor  # Ölçek faktörünü ayarlayın
	else:
		# Yeni sprite oluştur ve ekle
		var new_sprite = Sprite2D.new()
		new_sprite.texture = preload("res://Assets/Nothing.png")
		new_sprite.modulate = Color.BLUE
		new_sprite.name = sprite_name
		new_sprite.position = game_object.position / 4
		parent_node.add_child(new_sprite)
