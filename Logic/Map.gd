extends Spatial

enum StreetParts {Straight, StraightTurnEast, StraightTurnNorth, DiagonalEast, EastTurn, DiagonalNorth, NorthTurn}

var possible_next_street := {	StreetParts.Straight: [StreetParts.Straight, StreetParts.StraightTurnEast, StreetParts.StraightTurnNorth],
								StreetParts.StraightTurnEast: [StreetParts.DiagonalEast, StreetParts.EastTurn],
								StreetParts.StraightTurnNorth: [StreetParts.DiagonalNorth, StreetParts.NorthTurn],
								StreetParts.DiagonalEast: [StreetParts.DiagonalEast, StreetParts.EastTurn],
								StreetParts.EastTurn: [StreetParts.Straight, StreetParts.StraightTurnNorth],
								StreetParts.DiagonalNorth: [StreetParts.DiagonalNorth, StreetParts.NorthTurn],
								StreetParts.NorthTurn: [StreetParts.Straight, StreetParts.StraightTurnEast]}

var street_offsets := {			StreetParts.Straight: [1, 0],
								StreetParts.StraightTurnEast: [1, 1],
								StreetParts.StraightTurnNorth: [1, -1],
								StreetParts.DiagonalEast: [1, 1],
								StreetParts.EastTurn: [1, 0],
								StreetParts.DiagonalNorth: [1, -1],
								StreetParts.NorthTurn: [1, 0]}

class StreetEntry:
	var x: int
	var z: int
	var street_part: int
	var built := false
	func _init(_x: int, _z: int, _street_part: int):
		x = _x
		z = _z
		street_part = _street_part

class TileEntry:
	var x: int
	var z: int
	var street_dist: int
	var built := false
	func _init(_x: int, _z: int, _street_dist: int):
		x = _x
		z = _z
		street_dist = _street_dist

var planned_street := []
var planned_tiles := {} # coords -> Tile Entry
var open_ends := []

var discovered_coords := []

func _ready():
	setup()

func _physics_process(_delta):
	discover_coord(get_player_coordinates())

func setup():
	var start_street := StreetEntry.new(0,0,StreetParts.Straight)
	planned_street = [start_street]
	open_ends = [start_street]

func get_random_from_list(l):
	var i := randi() % len(l)
	return l[i]

func coord_dist(coords_a: Array, coords_b: Array) -> int:
	return int(abs(coords_a[0] - coords_b[0]) + abs(coords_a[1] - coords_b[1]))

func plan_new_street():
	var open_end : StreetEntry = open_ends.pop_front()
	var open_end_type := open_end.street_part
	var next_type = get_random_from_list(possible_next_street[open_end_type])
	if Game.intro:
		next_type = StreetParts.Straight
	var next_x = open_end.x + street_offsets[open_end_type][0]
	var next_z = open_end.z + street_offsets[open_end_type][1]
	var next_entry := StreetEntry.new(next_x, next_z, next_type)
	planned_street.append(next_entry)
	open_ends.push_back(next_entry)
	
	var new_street_coords := [next_x,next_z]
	for coords in get_surrouding_coords(new_street_coords, 4):
		if coords in planned_tiles:
			planned_tiles[coords].street_dist = min(planned_tiles[coords].street_dist, coord_dist(coords, new_street_coords))
		else:
			planned_tiles[coords] = TileEntry.new(coords[0], coords[1], coord_dist(coords, new_street_coords))

func get_surrouding_coords(coords: Array, dist: int):
	var surrounding_coords := []
	for i in range(coords[0]-dist,coords[0]+dist+1):
		for j in range(coords[1]-dist,coords[1]+dist+1):
			surrounding_coords.append([i,j])
	return surrounding_coords

func get_player_coordinates():
	var x = int(Game.car.global_translation.x/20)
	var z = int(Game.car.global_translation.z/20)
	return [x, z]

func get_street(coords: Array):
	for street in planned_street:
		if street.x == coords[0]:
			if street.z == coords[1]:
				return street
	return null

func build_tile(coords: Array):
	if not coords in planned_tiles:
		return false
	var tile_entry : TileEntry = planned_tiles[coords]
	if tile_entry.built:
		return false
	tile_entry.built = true
	
	# Build Street
	if tile_entry.street_dist == 0:
		var street = get_street(coords)
		if street != null:
			street.built = true
			build_street(coords, street.street_part)
	
	# Build Ground
	build_ground(coords, tile_entry.street_dist)
	return true

const BASIC_GROUND = preload("res://GroundParts/BasicGround.tscn")
func build_ground(coords: Array, street_dist: int):
	var ground_object := BASIC_GROUND.instance()
	
	add_child(ground_object)
	ground_object.global_translation.x = coords[0] * 20.0
	ground_object.global_translation.z = coords[1] * 20.0
	
	ground_object.global_translation.y = 0.0#-50.0
#	var tween := get_tree().create_tween()
#	tween.set_ease(Tween.EASE_OUT)
#	tween.set_trans(Tween.TRANS_QUAD)
#	tween.tween_property(ground_object, "global_translation:y", 0.0, .4)
	
	Decorator.decorate(ground_object, street_dist)


var last_waypoint = null

const LAMP = preload("res://Deco/Lamp.tscn")
const STREET_STRAIGHT = preload("res://StreetParts/StreetStraight.tscn")
const STREET_CURVE = preload("res://StreetParts/StreetCurve.tscn")
const STREET_DIAGONAL = preload("res://StreetParts/StreetDiagonal.tscn")
const BLOCK = preload("res://StreetParts/StreetBlock.tscn")
func build_street(coords: Array, street_part: int):
	var street_object
	match(street_part):
		StreetParts.Straight:
			street_object = STREET_STRAIGHT.instance()
			if Game.ready_for_block:
				Game.ready_for_block = false
				street_object.add_child(BLOCK.instance())
				street_object.get_node("Straight").visible = false
		StreetParts.StraightTurnEast:
			street_object = STREET_CURVE.instance()
		StreetParts.StraightTurnNorth:
			street_object = STREET_CURVE.instance()
			street_object.scale.z = -1
			street_object.use_other_side = false
		StreetParts.DiagonalEast:
			street_object = STREET_DIAGONAL.instance()
		StreetParts.EastTurn:
			street_object = STREET_CURVE.instance()
			street_object.scale.z = -1
			street_object.use_other_side = false
			street_object.scale.x = -1
			street_object.use_wrong_order = true
		StreetParts.DiagonalNorth:
			street_object = STREET_DIAGONAL.instance()
			street_object.scale.z = -1
			street_object.use_other_side = false
		StreetParts.NorthTurn:
			street_object = STREET_CURVE.instance()
			street_object.scale.x = -1
			street_object.use_wrong_order = true
	
	add_child(street_object)
	street_object.global_translation.x = coords[0] * 20.0
	street_object.global_translation.z = coords[1] * 20.0

	street_object.global_translation.y = 0.0
	
	last_waypoint = street_object.connect_waypoints(last_waypoint)

	var lamp_condition := (randi() % 5 <= 2) or Game.intro

	if lamp_condition:
		var points : Array = street_object.get_node("LampSpots").get_children()
		points.shuffle()
		var lamp = LAMP.instance()
		points[0].add_child(lamp)
#	var tween := get_tree().create_tween()
#	tween.set_ease(Tween.EASE_OUT)
#	tween.set_trans(Tween.TRANS_QUAD)
#	tween.tween_property(street_object, "global_translation:y", 0.0, .4)

func get_unbuilt_street_count():
	var i = 0
	for s in planned_street:
		if not s.built:
			i += 1
	return i

func discover_coord(coords: Array):
	while get_unbuilt_street_count() < 4:
		plan_new_street()
	if coords in discovered_coords:
		return
	randomize()
	discovered_coords.append(coords)
	for surrounding in get_surrouding_coords(coords, 4):
		var has_build_something = build_tile(surrounding)
		if has_build_something:
			yield(get_tree(),"idle_frame")
