extends Spatial

const OBSTACLE_CACTUS = preload("res://DreamObstacles/ObstacleCactus.tscn")
const OBSTACLE_SMALL_CACTUS = preload("res://DreamObstacles/ObstacleSmallCactus.tscn")
const OBSTACLE_TRUCK = preload("res://DreamObstacles/ObstacleTruck.tscn")

var obstacles := [OBSTACLE_CACTUS, OBSTACLE_SMALL_CACTUS, OBSTACLE_TRUCK]

func _ready():
	var obstacle_type : PackedScene = obstacles[randi() % len(obstacles)]
	var obstacle : Spatial = obstacle_type.instance()
	$Obstacle/SpinPivot.add_child(obstacle)
	obstacle.translation = Vector3.ZERO
