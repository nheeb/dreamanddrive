extends Node

var car: KinematicBody
var map
var world
var dream_world
var dream_car
var main

var viewport_shader: ShaderMaterial

var dead := false
var intro := true

func _ready():
	randomize()

func start_intro():
	yield(get_tree().create_timer(3.0),"timeout")
	dream_world.cam_in()
	world.cam_out()
	dream_car.intro_movement()
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(viewport_shader, "shader_param/dream_start", 1.0, 3.0).from(0.0)
