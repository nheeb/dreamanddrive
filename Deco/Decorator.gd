extends Node

func decorate(tile: Spatial, level: int):
	if level == 0:
		return
	if tile.has_node("DecoSpots"):
		var spots := tile.get_node("DecoSpots").get_children()
		for spot in spots:
			if randi() % 4 < level:
				build_random_deco(spot.global_translation + Vector3.UP)


const CACTUS1 = preload("res://Deco/Cactus1.tscn")
const CACTUS2 = preload("res://Deco/Cactus2.tscn")
const DEAD_TREE1 = preload("res://Deco/DeadTree1.tscn")
const DEAD_TREE2 = preload("res://Deco/DeadTree2.tscn")
const STONES1 = preload("res://Deco/Stones1.tscn")
const STONES2 = preload("res://Deco/Stones2.tscn")

var decos := [CACTUS1, CACTUS2, DEAD_TREE1, DEAD_TREE2, STONES1, STONES2]

func build_random_deco(pos: Vector3):
	var deco_scene : Resource = decos[randi()%len(decos)]
	var deco : Spatial = deco_scene.instance()
	Game.map.add_child(deco)
	deco.global_translation = pos
	#deco.rotation_degrees.y = randf() * 360.0
