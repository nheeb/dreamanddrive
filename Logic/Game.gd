extends Node

var car: KinematicBody
var map
var world
var dream_world
var dream_car

var dead := false
var intro := true

func _ready():
	randomize()
