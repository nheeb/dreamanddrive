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
	yield(get_tree().create_timer(4.5),"timeout")
	Sound.fade_out_engine()
	Sound.play_acc()
	yield(get_tree().create_timer(.2),"timeout")
	car.intro_speed_up()
	yield(get_tree().create_timer(9),"timeout")
	dream_world.cam_in()
	world.cam_out()
	dream_car.intro_movement()
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(viewport_shader, "shader_param/dream_start", 1.0, 5.0).from(0.0)

var time_survived := 0.0
var time_goal := 120.0
func _physics_process(delta):
	if not intro:
		time_survived += delta
		viewport_shader.set("shader_param/dream_progress", time_survived / time_goal)
		if time_survived > time_goal:
			trigger_end()

func trigger_end():
	pass
